//
//  ScoreViewController.swift
//  TestGolf
//
//  Created by Martin Sjöblom on 2017-09-03.
//  Copyright © 2017 Martin Sjöblom. All rights reserved.
//

import UIKit
import BugfenderSDK

class ScoreViewController: UIViewController {
    var currentHole = 0
    var currentPlayer = 0
    var increasedValue = 0;
    var values = [Int]()
    @IBAction func pressNumber(_ sender: UIButton) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate;
        let numberOfPlayers = appDelegate.round!.players.count;
        
        if (values.count >= numberOfPlayers) {
            values = [Int]()
        }
        
        let value = Int(sender.title(for: .normal)!);
        values.append(value! + increasedValue);
        BFLog("Värde %d, nu lista %@", value!, values)
        
        if (values.count >= numberOfPlayers) {
            appDelegate.addResult(currentHole, values)
            nextHole(sender);
        }
        increasedValue = 0;
        displayValues();
    }
    
    func displayValues() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        var isFirst = true;
        let fontSize : CGFloat = 25;
        for anIndex in 0..<appDelegate.players!.count {
            var value = "";
            spelareLabels[anIndex].font = UIFont.systemFont(ofSize: fontSize)
            if (anIndex < values.count) {
                value = String(values[anIndex]);
            } else {
                if (isFirst) {
                    spelareLabels[anIndex].font = UIFont.boldSystemFont(ofSize: fontSize)
                    isFirst = false;
                }
            }
            resultLabels[anIndex].text = value;
        }
        if (isFirst) {
            spelareLabels[0].font = UIFont.boldSystemFont(ofSize: fontSize)
        }
    }
    
    @IBAction func plus8(_ sender: Any) {
        increasedValue += 8;
    }
    @IBAction func readyResult(_ sender: Any) {
    }
    @IBOutlet weak var spelare1Label: UILabel!
    @IBOutlet weak var spelare2Label: UILabel!
    @IBOutlet weak var spelare3Label: UILabel!
    @IBOutlet weak var spelare4Label: UILabel!
    @IBOutlet weak var result1Label: UILabel!
    @IBOutlet weak var result2Label: UILabel!
    @IBOutlet weak var result3Label: UILabel!
    @IBOutlet weak var result4Label: UILabel!
    @IBOutlet weak var halLabel: UILabel!

    var spelareLabels = [UILabel]()
    var resultLabels = [UILabel]()
    
    @IBAction func previousHole(_ sender: Any) {
        currentHole -= 1
        if (currentHole < 0) {
            currentHole = 17
        }
        displayHole(currentHole)
    }
    @IBAction func nextHole(_ sender: Any) {
        currentHole += 1
        if (currentHole > 17) {
            currentHole = 0
        }
        displayHole(currentHole)
    }
    @IBOutlet weak var nextHole: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        spelareLabels = [spelare1Label, spelare2Label, spelare3Label, spelare4Label]
        resultLabels = [result1Label, result2Label, result3Label, result4Label]
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        for anIndex in 0..<4 {
            let visible = anIndex < appDelegate.players!.count
            spelareLabels[anIndex].isHidden = !visible
            resultLabels[anIndex].isHidden = !visible
            if (visible) {
                spelareLabels[anIndex].text = appDelegate.players?[anIndex].name
            }
        }
        displayHole(currentHole)
    }
    
    func displayHole(_ hole: Int) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        halLabel.text = "Hål " + String(hole + 1)
        increasedValue = 0;
        if (appDelegate.round!.results.count > currentHole) {
            values = appDelegate.round!.results[currentHole];
        } else {
            values = [Int]();
        }
        displayValues()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func readyAddingValues(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
