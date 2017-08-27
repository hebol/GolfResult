//
//  AppDelegate.swift
//  TestGolf
//
//  Created by Martin Sjöblom on 2017-07-28.
//  Copyright © 2017 Martin Sjöblom. All rights reserved.
//

import UIKit
import WatchConnectivity

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, WCSessionDelegate {
    var session : WCSession!
    let roundNotification = Notification.Name(rawValue:"RoundNotification")
    let scoreNotification = Notification.Name(rawValue:"ScoreNotification")

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        if (WCSession.isSupported()) {
            session = WCSession.default()
            session.delegate = self;
            session.activate()
        }
        
        let defaults = UserDefaults.standard
        if let temp = defaults.object(forKey: "players") {
            players = temp as? [Player]
        }
        // Registering for notification
        NotificationCenter.default.addObserver(forName:roundNotification, object:nil, queue:nil, using:newRound)
        return true
    }
    
    var round : Round?;
    var players : [Player]?;
    
    func clearResults() {
        do {
            round?.results = [[Int]]()
            var data = [String : Any]()
            data["date"]  = Date()
            data["round"] = round
            
            try session.updateApplicationContext(data)
        } catch {
            NSLog("App: error")
        }
    }
    
    func newRound(notification:Notification) -> Void {
        NSLog("App(del): Did receive notification", notification.userInfo!)
        do {
            var data = notification.userInfo! as! [String : Any]
            round   = data["round"] as? Round
            players = round?.players
            
            let defaults = UserDefaults.standard
            defaults.set(players, forKey: "players")

            round?.results = [[Int]]()
            
            data["date"]      = Date()
            try session.updateApplicationContext(data)
        } catch {
            NSLog("App: error")
        }
    }
    
    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
        NSLog("App(del): Received data", applicationContext)
        //Use this to update the UI instantaneously (otherwise, takes a little while)
        DispatchQueue.main.async() {
            self.round?.results = [[Int]]()
            for index in 1...18 {
                let key:String = String(index)
                var resultList = [Int]()
                if (applicationContext[key] != nil) {
                    resultList = (applicationContext[key] as! [Int])
                }
                self.round?.results.append(resultList)
            }
            let defaults = UserDefaults.standard
            defaults.set(self.round, forKey: "round")
            NotificationCenter.default.post(name:self.scoreNotification, object: nil, userInfo:["round":self.round!])
        }
    }
    
//    optional public func session(_ session: WCSession, didReceiveMessage message: [String : Any])


    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        NSLog("App(del): activationDidCompleteWith session:%@", session)
        if (session.isReachable) {
            NSLog("App(del): sending message to app")
            session.sendMessage(["getState":""], replyHandler: { reply in
                NSLog("App(del): got result: %@", reply)
            }, errorHandler: { error in
                NSLog("App(del): got error: %@", error.localizedDescription)
            })
        } else {
            NSLog("App(del): Watch is NOT reachable")
        }
    }
    
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        
    }
    
    
    func sessionDidDeactivate(_ session: WCSession) {
        
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

