//
//  ScoreViewController.swift
//  TestGolf
//
//  Created by Martin Sjöblom on 2017-09-03.
//  Copyright © 2017 Martin Sjöblom. All rights reserved.
//

import UIKit

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
        NSLog("Värde %d, nu lista %@", value!, values)
        
        if (values.count >= numberOfPlayers) {
            appDelegate.addResult(currentHole, values)
        }
        increasedValue = 0;
        displayValues();
    }
    
    func displayValues() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        for anIndex in 0..<appDelegate.players!.count {
            var value = "";
            if (anIndex < values.count) {
                value = String(values[anIndex]);
            }
            resultLabels[anIndex].text = value;
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
        for index in 0..<appDelegate.players!.count {
            let hasResult = appDelegate.round!.results.count > currentHole && appDelegate.round!.results[currentHole].count > index
            var result = ""
            if (hasResult) {
                result = String(appDelegate.round!.results[currentHole][index])
            }
            resultLabels[index].text = result
        }
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
