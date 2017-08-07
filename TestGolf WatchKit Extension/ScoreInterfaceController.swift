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
    func selectedScore(_ value: Int)
}

class ScoreInterfaceController: WKInterfaceController {
    @IBOutlet var itemPicker: WKInterfacePicker!
    var delegate: ScoreHandler?
    
    @IBAction func pickerSelectedItemChanged(value: Int) {
        NSLog("Selected %d", value)
    }
    @IBAction func selectedButton1() {
        self.delegate?.selectedScore(1)
        self.dismiss()
    }
    @IBAction func selectedButton2() {
        self.delegate?.selectedScore(2)
        self.dismiss()
    }
    @IBAction func selectedButton3() {
        self.delegate?.selectedScore(3)
        self.dismiss()
    }
    @IBAction func selectedButton4() {
        self.delegate?.selectedScore(4)
        self.dismiss()
    }
    @IBAction func selectedButton5() {
        self.delegate?.selectedScore(5)
        self.dismiss()
    }
    @IBAction func selectedButton6() {
        self.delegate?.selectedScore(6)
        self.dismiss()
    }
    @IBAction func selectedButton7() {
        self.delegate?.selectedScore(7)
        self.dismiss()
    }
    @IBAction func selectedButton8() {
        self.delegate?.selectedScore(8)
        self.dismiss()
    }
    
    @IBAction func cancel() {
        self.dismiss()
    }
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        self.delegate = context as? ScoreHandler
        // Configure interface objects here.
        NSLog(self.delegate != nil ? "Set" : "Not Set");

        let pickerItems: [WKPickerItem] = options.map {
            let pickerItem = WKPickerItem()
            pickerItem.title = $0.0
            pickerItem.caption = $0.1
            return pickerItem
        }
        NSLog("Setting items %@", pickerItems)
        itemPicker.setItems(pickerItems)
    }
    
    var options: [(String, String)] = [
        ("9", "9"),
        ("10", "10"),
        ("11", "11"),
        ("12", "12")]
    
}
