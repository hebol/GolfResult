//
//  InterfaceController.swift
//  TestGolf WatchKit Extension
//
//  Created by Martin Sjöblom on 2017-07-28.
//  Copyright © 2017 Martin Sjöblom. All rights reserved.
//

import WatchKit
import Foundation
import UIKit

class InterfaceController: WKInterfaceController, ScoreHandler {
    @IBOutlet weak var holeLabel: WKInterfaceLabel!
    @IBOutlet weak var scoreLabel: WKInterfaceLabel!
    @IBOutlet weak var lockImage: WKInterfaceImage!
    var currentHole = 1;
    
    func selectedScore(_ value: Int) {
        scoreLabel.setText(String(value))
    }

    
    @IBAction func selectScore() {
        NSLog("Will present controller")
        self.presentController(withName: "Score", context: self)
    }
    @IBAction func showNextHole() {
        currentHole += 1;
        if currentHole > 18 {
            currentHole = 1;
        }
        holeLabel.setText(String(currentHole));
    }
    @IBAction func showPreviousHole() {
        currentHole -= 1;
        if currentHole < 1 {
            currentHole = 18;
        }
        
        holeLabel.setText(String(currentHole));
    }
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        lockImage.setImageNamed("lock-128-red.png")
        
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
