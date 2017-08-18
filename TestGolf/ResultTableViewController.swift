//
//  ResultTableViewController.swift
//  TestGolf
//
//  Created by Martin Sjöblom on 2017-08-07.
//  Copyright © 2017 Martin Sjöblom. All rights reserved.
//

import UIKit

class ResultTableViewController: UITableViewController {
    let roundNotification = Notification.Name(rawValue:"RoundNotification")
    let scoreNotification = Notification.Name(rawValue:"ScoreNotification")

   
    @IBAction func avslutaRunda(_ sender: Any) {
        let alert = UIAlertController(title: "Avsluta runda", message: "Skall du avsluta rundan?", preferredStyle: .alert)
        let clearAction = UIAlertAction(title: "Ja, Avsluta", style: .destructive) { (alert: UIAlertAction!) -> Void in
            _ = self.navigationController?.popViewController(animated: true)
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.clearResults()
        }
        let cancelAction = UIAlertAction(title: "Nej, Fortsätt", style: .default) { (alert: UIAlertAction!) -> Void in
            //print("You pressed Cancel")
        }
        
        alert.addAction(clearAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion:nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.hidesBackButton = true
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        NotificationCenter.default.addObserver(forName:scoreNotification, object:nil, queue:nil, using:updatedScore)
        NotificationCenter.default.addObserver(forName:roundNotification, object:nil, queue:nil, using:newRound)

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        let cellIdentifier = "ResultHeaderTableViewCell"
        guard let headerCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? ResultHeaderTableViewCell  else {
            fatalError("The dequeued cell is not an instance of " + cellIdentifier + ".")
        }
        self.tableView.tableHeaderView = headerCell;
    }
    
    override public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let cellIdentifier = "ResultFooterSectionTableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? ResultFooterSectionTableViewCell  else {
            fatalError("The dequeued cell is not an instance of " + cellIdentifier + ".")
        }
        cell.roundDirectionLabel.text = section == 0 ? "Ut" : "In"
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let names = appDelegate.getPlayerNames()
        let start   = section == 0 ? 0 : 9
        let results = appDelegate.getPlayerResults()
        
        let playerHcps = appDelegate.getPlayerHcps()
        let courseHcps = appDelegate.getCourseHcps()
        
        let resultFields = [cell.player1ResultLabel, cell.player2ResultLabel, cell.player3ResultLabel, cell.player4ResultLabel]
        
        for col in 0 ..< 4 {
            resultFields[col]?.isHidden = col >= names.count
            var result:Int       = 0
            var resultPoints:Int = 0
            for row in start ..< start + 9 {
                if row < results.count && col < results[row].count {
                    let strokes = results[row][col]
                    result += strokes
                    
                    let courseHcp = courseHcps[row]
                    
                    let hcp = GolfResult.calculateHcp(GullbringaNyaData.parList[row], courseHcp, playerHcps[col])
                    let points = max(hcp - strokes + 2, 0);
                    resultPoints += points
                }
            }
            resultFields[col]?.text = String(result) + " (" + String(resultPoints) + ")"
        }

        return cell;
    }
    
    override func tableView( _ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 44
    }
    
    func updatedScore(notification:Notification) -> Void {
        NSLog("App: Did receive notification score", notification.userInfo!)
        result = notification.userInfo!["results"] as! [[Int]]
        tableView.reloadData()
    }
    
    func newRound(notification:Notification) -> Void {
        NSLog("App: Did receive notification new round", notification.userInfo!)
        
        tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    
    var result = [[Int]]()

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 9
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "ResultTableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ResultTableViewCell  else {
            fatalError("The dequeued cell is not an instance of " + cellIdentifier + ".")
        }
        let row = indexPath.row + 9 * indexPath.section
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let courseHcp = appDelegate.getCourseHcps()[row]
        
        cell.halLabel.text = String(row + 1)
        cell.hcpLabel.text = "(" + String(courseHcp) + ")"
        let data = row < result.count ? result[row] : [Int]()
        let resultFields = [cell.result1Label, cell.result2Label, cell.result3Label, cell.result4Label]
        let names = appDelegate.getPlayerNames()
        let playerHcps = appDelegate.getPlayerHcps()
        
        for col in 0 ..< 4 {
            resultFields[col]?.isHidden = data.count <= col
            if (col < names.count) {
                let hcp = GolfResult.calculateHcp(GullbringaNyaData.parList[row], courseHcp, playerHcps[col])
                let strokes = getValue(col, data)
                let points = max(hcp - strokes + 2, 0);
                
                resultFields[col]?.text = String(strokes) + " (" + String(points) + ")"
/*                if (strokes > 0) {
                    NSLog("Player %@ hcp:%d strokes:%d points: %d", names[col], hcp, strokes, points);
                }*/
            }
        }

        return cell
    }
    
    func getValue( _ index: Int, _ array: [Int]) -> Int {
        var returnValue = 0;
        if (array.count > index) {
            returnValue = array[index];
        }
        return returnValue;
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
