//
//  AppDelegate.swift
//  TestGolf
//
//  Created by Martin Sjöblom on 2017-07-28.
//  Copyright © 2017 Martin Sjöblom. All rights reserved.
//

import UIKit
import WatchConnectivity
import BugfenderSDK

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, WCSessionDelegate {
    var session : WCSession!
    let roundNotification = Notification.Name(rawValue:"RoundNotification")
    let scoreNotification = Notification.Name(rawValue:"ScoreNotification")

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        Bugfender.activateLogger("Afi6IeKlW38maXBXp2EL5KhKTSZHyFBe")
//        Bugfender.enableUIEventLogging()  // optional, log user interactions automatically
        Bugfender.enableCrashReporting() // optional, log crashes automatically
        BFLog("Starting up bugfender!") // use BFLog as you would use NSLog

        // Override point for customization after application launch.
        if (WCSession.isSupported()) {
            session = WCSession.default
            session.delegate = self;
            session.activate()
        }
        
        let defaults = UserDefaults.standard
        players = Player.fromDefaults(defaults.dictionaryRepresentation());
        // Registering for notification
        BFLog("Adding notification observer");
        NotificationCenter.default.addObserver(forName:roundNotification, object:nil, queue:nil, using:newRound)
        return true
    }
    
    var round : Round?;
    var players : [Player]?;
    
    func clearResults() {
        do {
            round?.results = [[Int]]()
            var data = round!.toDefaults()
            data["date"]  = Date()
            
            try session.updateApplicationContext(data)
        } catch {
            BFLog("App: error clearing results")
        }
    }
    
    func newRound(notification:Notification) -> Void {
        NSLog("App(del): Did receive notification", notification.userInfo!)
        do {
            round = (notification.userInfo! as! [String : Any])["round"] as? Round
            players = round!.players
            var data : [String:Any] = round!.toDefaults()
            
            round!.results = [[Int]]()
            
            UserDefaults.standard.setDefault(data)

            data["date"]      = Date()
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "Resultat") as! ResultTableViewController
            let root = self.window!.rootViewController! as! UINavigationController
            root.show(newViewController, sender: self)
            
            try session.updateApplicationContext(data)
        } catch {
            BFLog("App: error notifying new round")
        }
    }
    
    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
        BFLog("App(del): Received data", applicationContext)
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
//            let defaults = UserDefaults.standard
//            defaults.set(self.round, forKey: "round")
            BFLog("Posting notification");
            NotificationCenter.default.post(name:self.scoreNotification, object: nil, userInfo:["round":self.round!])
        }
    }
    
    func addResult(_ hole: Int, _ result: [Int]) {
        while (round!.results.count <= hole) {
            round?.results.append([Int]())
        }
        round!.results[hole] = result
        NotificationCenter.default.post(name:self.scoreNotification, object: nil, userInfo:["round":self.round!])
//        do {
//            try session.updateApplicationContext(round!.toDefaults())
//       } catch {
//            BFLog("App: error sending result from phone")
//        }
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        BFLog("App(del): activationDidCompleteWith session:%@", session)
        if (session.isReachable) {
            DispatchQueue.main.async() {
                BFLog("App(del): sending message to app")
                session.sendMessage(["getState":""], replyHandler: { reply in
                    BFLog("App(del): got result: %@", reply)
                }, errorHandler: { error in
                    BFLog("App(del): got error: %@", error.localizedDescription)
                })
            }
        } else {
            BFLog("App(del): Watch is NOT reachable")
        }
    }
    
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        BFLog("sessionDidBecomeInactive");
    }
    
    
    func sessionDidDeactivate(_ session: WCSession) {
        BFLog("sessionDidDeactivate");
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        BFLog("applicationWillResignActive");
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        BFLog("applicationDidEnterBackground");
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        BFLog("applicationWillEnterForeground");
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        BFLog("applicationDidBecomeActive");
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        BFLog("applicationWillTerminate");
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

