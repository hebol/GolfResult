//
//  ScoreController.swift
//  TestGolf
//
//  Created by Martin Sjöblom on 2017-08-04.
//  Copyright © 2017 Martin Sjöblom. All rights reserved.
//

import WatchKit
import Foundation

protocol ScoreHandler {
    func selectedScore(_ value: [Int])
}

class ScoreInterfaceController: WKInterfaceController {
    @IBOutlet var nameLabel: WKInterfaceLabel!
    var delegate: ScoreHandler?
    var players: [Player]?
    var results = [Int]()
    var added = 0
    
    func process(_ value: Int) {
        WKInterfaceDevice.current().play(WKHapticType.click)
        results.append(value + added)
        //NSLog("WK:Process %d => %@", value, results)
        if (results.count >= (players?.count)!) {
            delegate?.selectedScore(results)
            self.pop()
        } else {
            nameLabel.setText(players?[results.count].name)
        }
        added = 0
    }
    
    @IBAction func selectedButton1() {
        process(1);
    }
    @IBAction func selectedButton2() {
        process(2);
    }
    @IBAction func selectedButton3() {
        process(3);
    }
    @IBAction func selectedButton4() {
        process(4);
    }
    @IBAction func selectedButton5() {
        process(5);
    }
    @IBAction func selectedButton6() {
        process(6);
    }
    @IBAction func selectedButton7() {
        process(7);
    }
    @IBAction func selectedButton8() {
        process(8);
    }
    @IBAction func selectedPlus() {
        WKInterfaceDevice.current().play(WKHapticType.click)
        added += 8;
        let name = players?[results.count].name;
        nameLabel.setText(name! + " +" + String(added))
    }
    
    @IBAction func cancel() {
        self.pop()
    }
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        let data = context as! [String:Any]
        self.players  = data["players"] as? [Player]
        self.delegate = data["delegate"] as? ScoreHandler
        if (players != nil && (players?.count)! > results.count) {
            nameLabel.setText(players?[results.count].name)
        }
    }
}
