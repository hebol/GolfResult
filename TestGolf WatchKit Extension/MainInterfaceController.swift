//
//  MainInterfaceController.swift
//  TestGolf WatchKit Extension
//
//  Created by Martin Sjöblom on 2017-07-28.
//  Copyright © 2017 Martin Sjöblom. All rights reserved.
//

import WatchKit
import Foundation
import UIKit
import WatchConnectivity

class MainInterfaceController: WKInterfaceController, ScoreHandler, WCSessionDelegate {
    @IBOutlet weak var holeLabel: WKInterfaceLabel!
    @IBOutlet weak var scoreLabel: WKInterfaceLabel!
    @IBOutlet weak var parLabel: WKInterfaceLabel!
    @IBOutlet weak var resultButton: WKInterfaceButton!
    @IBOutlet weak var lockButton: WKInterfaceButton!
    
    var currentHole = 1
    var results   = [String:[Int]]()
    var round :Round?
    
    var session : WCSession!
    
    @IBAction func unlockResult() {
        WKInterfaceDevice.current().play(WKHapticType.success)
        selectedScore([Int]())
    }
    
    let notification = Notification.Name(rawValue:"ScoreNotification")
    
    func selectedScore(_ values: [Int]) {
        results[String(currentHole)] = values
        displayHole(currentHole);
        do {
            try session.updateApplicationContext(results)
        } catch {
            print("WK: error uppdating IOS")
        }
    }

    override init() {
        super.init()
        if (session == nil) {
            if (WCSession.isSupported()) {
                session = WCSession.default
                session.delegate = self
                session.activate()
            }
        } else {
            NSLog("WK Session already initiated!")
        }
        
        NotificationCenter.default.addObserver(forName:notification, object:nil, queue:nil, using:scoreNotification)
        if (round == nil || round?.players.count == 0) {
            self.pushController(withName: "Waiting", context: [])
        }
    }
    
    func scoreNotification(notification:Notification) -> Void {
        NSLog("WK Did receive notification %@", notification.userInfo!)
        round = (notification.userInfo as! [String:Any])["round"] as? Round
        
        results = [String:[Int]]()
        if (round == nil || round?.players.count == 0) {
            self.pushController(withName: "Waiting", context: [])
        } else {
            currentHole     = 1
            displayHole(currentHole)
        }
    }
    
    @IBAction func selectScore() {
        self.pushController(withName: "Score", context: ["delegate":self, "players": round!.players])
    }
    
    @IBAction func showNextHole() {
        WKInterfaceDevice.current().play(WKHapticType.click)
        currentHole += 1;
        if currentHole > 18 {
            currentHole = 1;
        }
        displayHole(currentHole)
    }
    
    func displayHole(_ hole: Int) {
        holeLabel.setText(String(hole));
        let values = results[String(hole)]
        let hasValue = values != nil && values!.count > 0;
        resultButton.setEnabled(!hasValue)
        
        if (hasValue) {
            var result = ""
            for value in values! {
                if (result.count > 0) {
                    result += " "
                }
                result += String(value)
            }
            scoreLabel.setText(result)
            lockButton.setBackgroundImageNamed("lock-128-red.png")
        } else {
            scoreLabel.setText("-")
            lockButton.setBackgroundImageNamed("unlock-128.png")
        }
        var result = ""
        let holePar   = round!.course.parList[hole - 1]
        let holeIndex = round!.course.indexList[hole - 1]
        for index in 0..<round!.players.count {
            if (result.count > 0) {
                result += " "
            }
            let hcp = GolfResult.calculateHcp(holePar:holePar, holeIndex:holeIndex, playerHcp: round!.players[index].effectiveHcp!)
            result += String(hcp)
        }
        parLabel.setText(result + " (" + String(holeIndex) + ")")
    }
    
    @IBAction func showPreviousHole() {
        WKInterfaceDevice.current().play(WKHapticType.click)
        currentHole -= 1;
        if currentHole < 1 {
            currentHole = 18;
        }
        displayHole(currentHole)
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        NSLog("activationDidCompleteWith session:%@", session)
    }
    func sessionReachabilityDidChange(_ session: WCSession) {
        NSLog("sessionReachabilityDidChange session:%@", session)
    }
    
     func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        NSLog("WK: got message from App %@", message)
    }
    func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) ->
        Void) {
        NSLog("WK: got message from App %@ with reply handler", message);
        replyHandler(["reply":results]);
    }
    
    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
        NSLog("WK Received data %@", applicationContext)
        //Use this to update the UI instantaneously (otherwise, takes a little while)
        DispatchQueue.main.async() {
            let data = Round.fromDefaults(applicationContext)
            NotificationCenter.default.post(name:self.notification, object: nil, userInfo:["round":data]);
        }
    }
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
