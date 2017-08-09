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
    var names = [String]()

   
    @IBAction func avslutaRunda(_ sender: Any) {
        let alert = UIAlertController(title: "Avsluta runda", message: "Skall du avsluta rundan?", preferredStyle: .alert)
        let clearAction = UIAlertAction(title: "Ja, Avsluta", style: .destructive) { (alert: UIAlertAction!) -> Void in
            _ = self.navigationController?.popViewController(animated: true)
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
    
    func updatedScore(notification:Notification) -> Void {
        NSLog("App: Did receive notification %@", notification.userInfo!)
        result = notification.userInfo!["results"] as! [[Int]]
        tableView.reloadData()
    }
    
    func newRound(notification:Notification) -> Void {
        NSLog("App: Did receive notification %@", notification.userInfo!)
        names = notification.userInfo!["names"] as! [String]
        setNameList(names)
        
        tableView.reloadData()
    }
    
    func setNameList(_ names: [String]) {
        guard let headerCell = self.tableView.tableHeaderView as? ResultHeaderTableViewCell  else {
            fatalError("No header view!")
        }
        headerCell.spelare1Label.text = names[0].trim()
        headerCell.spelare2Label.text = names[1].trim()
        headerCell.spelare3Label.text = names[2].trim()
        headerCell.spelare4Label.text = names[3].trim()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    
    var result = [[Int]]()

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return result.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "ResultTableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ResultTableViewCell  else {
            fatalError("The dequeued cell is not an instance of " + cellIdentifier + ".")
        }
        cell.halLabel.text = String(indexPath.row + 1)
        cell.result1Label.isHidden = result[indexPath.row].count < 1;
        cell.result2Label.isHidden = result[indexPath.row].count < 2;
        cell.result3Label.isHidden = result[indexPath.row].count < 3;
        cell.result4Label.isHidden = result[indexPath.row].count < 4;
        cell.result1Label.text = getValue(0, result[indexPath.row]);
        cell.result2Label.text = getValue(1, result[indexPath.row]);
        cell.result3Label.text = getValue(2, result[indexPath.row]);
        cell.result4Label.text = getValue(3, result[indexPath.row]);

        return cell
    }
    
    func getValue( _ index: Int, _ array: [Int]) -> String {
        var returnValue = "";
        if (array.count > index) {
            returnValue = String(array[index]);
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
