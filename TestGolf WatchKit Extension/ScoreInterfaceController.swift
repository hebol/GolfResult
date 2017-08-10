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
    var names: [String]?
    var results = [Int]()
    
    func process(_ value: Int) {
        results.append(value)
        NSLog("WK:Process %d => %@", value, results)
        if (results.count >= (names?.count)!) {
            delegate?.selectedScore(results)
            self.dismiss()
        } else {
            nameLabel.setText(names?[results.count])
        }
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
    
    @IBAction func cancel() {
        self.dismiss()
    }
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        let data = context as! [String:Any]
        self.delegate = data["delegate"] as? ScoreHandler
        self.names    = data["names"] as? [String]
        nameLabel.setText(names?[results.count])

        // Configure interface objects here.
        //NSLog(self.delegate != nil ? "Set" : "Not Set");
    }
}
