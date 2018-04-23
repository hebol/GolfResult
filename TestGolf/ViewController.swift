//
//  ViewController.swift
//  TestGolf
//
//  Created by Martin Sjöblom on 2017-07-28.
//  Copyright © 2017 Martin Sjöblom. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    let roundNotification = Notification.Name(rawValue:"RoundNotification")

    @IBOutlet weak var startButton: UIButton!
    
    @IBOutlet weak var spelare1TextField: UITextField!
    @IBOutlet weak var spelare2TextField: UITextField!
    @IBOutlet weak var spelare3TextField: UITextField!
    @IBOutlet weak var spelare4TextField: UITextField!
    
    @IBOutlet weak var spelare1Hcp: UITextField!
    @IBOutlet weak var spelare2Hcp: UITextField!
    @IBOutlet weak var spelare3Hcp: UITextField!
    @IBOutlet weak var spelare4Hcp: UITextField!
    
    @IBOutlet weak var spelare1Slag: UILabel!
    @IBOutlet weak var spelare2Slag: UILabel!
    @IBOutlet weak var spelare3Slag: UILabel!
    @IBOutlet weak var spelare4Slag: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let players = appDelegate.round?.players ?? []
        let nameLabels = [spelare1TextField, spelare2TextField, spelare3TextField, spelare4TextField]
        for index in 0  ..< nameLabels.count  {
            nameLabels[index]?.text = players.count > index ? players[index].name : ""
        }
        let hcpLabels = [spelare1Hcp, spelare2Hcp, spelare3Hcp, spelare4Hcp]
        for index in 0  ..< hcpLabels.count  {
            hcpLabels[index]?.text = players.count > index ? String(players[index].exactHcp) : ""
            hcpfieldWasUpdated(hcpLabels[index] as Any)
        }

        startButton.isEnabled = hasSetValue(spelare1TextField) && hasSetValue(spelare1Hcp);
    }
    
    func hasSetValue(_ field: UITextField) -> Bool {
        return (field.text?.trim().characters.count)! > 0
    }
    
    @IBAction func hcpfieldWasUpdated(_ sender: Any) {
        let labelMap = [spelare1Hcp:spelare1Slag, spelare2Hcp:spelare2Slag, spelare3Hcp:spelare3Slag, spelare4Hcp:spelare4Slag]
        let senderField = sender as! UITextField
        let label  = labelMap[senderField]
        if (hasSetValue(senderField)) {
            let hcp    = Float(senderField.text!)
            label??.text = convertHcp(hcp)
        } else {
            label??.text = ""
        }
    }
    
    
    func convertHcp(_ value: Float?) -> String {
        if (value != nil && value != Float.nan) {
            var result: String? = nil;
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let slopeList = appDelegate.round?.course.slopeList
            if (slopeList != nil) {
                for index in 0..<slopeList!.count {
                    if (value! >= slopeList![index][0] && value! <= slopeList![index][1]) {
                        result = String(Int(slopeList![index][2]))
                        break;
                    }
                }
            }
            if (result == nil) {
                result = String(Int(roundf(value!)))
            }
            return result!
        } else {
            return "";
        }
    }
    
    @IBAction func player1NameChanged(_ sender: Any) {
        startButton.isEnabled = hasSetValue(spelare1TextField) && hasSetValue(spelare1Hcp);
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getPlayers() -> [Player] {
        var result = [Player]()
        let nameFields = [spelare1TextField, spelare2TextField, spelare3TextField, spelare4TextField]
        let effectiveHcpFields = [spelare1Slag, spelare2Slag, spelare3Slag, spelare4Slag]
        let exactHcpFields = [spelare1Hcp, spelare2Hcp, spelare3Hcp, spelare4Hcp]
        for index in 0 ..< nameFields.count {
            let name         = nameFields[index]!.text!.trim()
            let effectiveHcp = effectiveHcpFields[index]!.text!.trim()
            let exactHcp     = exactHcpFields[index]!.text!.trim()
            if (!name.isEmpty && !effectiveHcp.isEmpty && !exactHcp.isEmpty) {
                result.append(Player(name, Float(exactHcp)!, Int(effectiveHcp)!))
            }
        }
        
        return result
    }
    
    @IBAction func startRound(_ sender: Any) {
        NSLog("App: Starting round")
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        if (appDelegate.round == nil || appDelegate.round!.results.count == 0) {
            let players = getPlayers()
            let round = Round(players, SaroPark54Data)
            NotificationCenter.default.post(name:self.roundNotification, object: nil,
                                            userInfo:["round":round])
            
        } else {
            NSLog("App: Reusing old values");
        }
    }
}

