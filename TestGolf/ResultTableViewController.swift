//
//  ResultTableViewController.swift
//  TestGolf
//
//  Created by Martin Sjöblom on 2017-08-07.
//  Copyright © 2017 Martin Sjöblom. All rights reserved.
//

import UIKit
import BugfenderSDK
import MessageUI

class ResultTableViewController: UITableViewController, MFMailComposeViewControllerDelegate {
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
        
        if MFMailComposeViewController.canSendMail() {
            let zeTarget = self;
            let mailAction = UIAlertAction(title: "Nej, Maila bara", style: .default) { (alert: UIAlertAction!) -> Void in
                BFLog("Will mail result");
                let composeVC = MFMailComposeViewController()
                composeVC.mailComposeDelegate = zeTarget;
                
                // Configure the fields of the interface.
                composeVC.setToRecipients(["golfresult@sjoblom.se"])
                BFLog("Has set recipient");

                let dateformatter = DateFormatter()
                dateformatter.dateFormat = "yyyy-MM-dd HH:mm"
                let now = dateformatter.string(from: NSDate() as Date)
                BFLog("Will send now: \(now)");
                let appDelegate = UIApplication.shared.delegate as! AppDelegate

                if (appDelegate.round != nil) {
                    do {
                        BFLog("Will generate HTML");
                        let result = try self.generateHtmlReport(appDelegate);
                        
                        BFLog("HTML result ready!");
                        composeVC.setMessageBody(result, isHTML: true)
                    } catch {
                        BFLog("Error generating HTML \(error)");
                    }
                } else {
                    composeVC.setMessageBody("<h1>Ingen runda</h1>", isHTML: true)
                }
                composeVC.setSubject("Resultat från runda " + now + " på " + SelectedCourse.name)
                
                BFLog("Presenting mail view");
                // Present the view controller modally.
                zeTarget.navigationController?.present(composeVC, animated: true, completion: nil)
            }
            alert.addAction(mailAction)
        }

        alert.addAction(clearAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion:nil)
    }
    
    func generateHtmlReport(_ appDelegate: AppDelegate) throws -> String  {
        var result = "";
        if ( appDelegate.round != nil) {
            var partSums = Array(repeating: Array(repeating: 0, count: appDelegate.round!.results.count), count: 2);
            var partPoints = Array(repeating: Array(repeating: 0, count: appDelegate.round!.results.count), count: 2);

            BFLog("Start of HTML");
            result = "<table>";
            result += "<tr>";
            result += "<th>Hål</th>";
            for  player in appDelegate.round!.players {
                result += "<th>" + player.name + "</th>";
            }
            result += "</tr>";
            BFLog("Names set");
            for row in 0 ..< SelectedCourse.parList.count {
                result += "<tr>";
                result += "<th>" + String(row + 1) + "</th>";
                if (row < appDelegate.round!.results.count) {
                    for playerIndex in 0 ..< appDelegate.round!.players.count {
                        let score = appDelegate.round!.results[row][playerIndex];
                        
                        let hcp = GolfResult.calculateHcp(holePar: appDelegate.round!.course.parList[row], holeIndex: appDelegate.round!.course.indexList[row], playerHcp: appDelegate.round!.players[playerIndex].effectiveHcp!)
                        let points = max(hcp - score + 2, 0);
                        partPoints[row < 9 ? 0 : 1][playerIndex] += points;
                        
                        result += "<td>" + String(score) + " (" + String(points) + ")</td>";
                        
                        partSums[row < 9 ? 0 : 1][playerIndex] += score;
                    }
                }
                result += "</tr>";
                if (row == 8) {
                    BFLog("First summary");
                    result += "<tr><th>Ut</th>";
                    if (row < appDelegate.round!.results.count) {
                        for playerIndex in 0 ..< appDelegate.round!.players.count {
                            result += "<td>" + String(partSums[0][playerIndex]) + " (" + String(partPoints[0][playerIndex]) + ")</td>";
                        }
                    }
                    result += "</tr>";
                }
                if (row == 17) {
                    BFLog("Second summary");
                    result += "<tr><th>In</th>";
                    if (row < appDelegate.round!.results.count) {
                        for playerIndex in 0 ..< appDelegate.round!.players.count {
                            result += "<td>" + String(partSums[1][playerIndex]) + " (" + String(partPoints[1][playerIndex]) + ")</td>";
                        }
                        result += "</tr><tr><th>Summa</th>";
                        for playerIndex in 0 ..< appDelegate.round!.players.count {
                            result += "<td>" + String(partSums[0][playerIndex] + partSums[1][playerIndex]) + " (" + String(partPoints[0][playerIndex] + partPoints[1][playerIndex]) + ")</td>";
                        }
                    }
                    result += "</tr>";
                }
            }
            result += "</table>";
        }
        return result;
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController,
                               didFinishWith result: MFMailComposeResult, error: Error?) {
        BFLog("Mail ready %d", result.rawValue);
        
        // Dismiss the mail compose view controller.
        controller.dismiss(animated: true, completion: nil)
    }

    
    override func viewDidLoad() {
        BFLog("viewDidLoad");
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
        cell.roundDirectionLabel.text = section == 0 ? "Ut" : (section == 1 ? "In" : "Tot")
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let round  = appDelegate.round!
        let start  = section == 1 ?  9 : 0
        let length = section == 2 ? 18 : 9

        let resultFields = [cell.player1ResultLabel, cell.player2ResultLabel, cell.player3ResultLabel, cell.player4ResultLabel]
        
        for col in 0 ..< 4 {
            resultFields[col]?.isHidden = col >= round.players.count
            var result:Int       = 0
            var resultPoints:Int = 0
            for row in start ..< start + length {
                if row < round.results.count && col < round.results[row].count {
                    let strokes = round.results[row][col]
                    result += strokes
                    
                    let hcp = GolfResult.calculateHcp(holePar: round.course.parList[row], holeIndex: round.course.indexList[row], playerHcp: round.players[col].effectiveHcp!)
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
        BFLog("App: Did receive notification score", notification.userInfo!)
        result = (notification.userInfo!["round"] as! Round).results
        tableView.reloadData()
    }
    
    func newRound(notification:Notification) -> Void {
        BFLog("App: Did receive notification new round", notification.userInfo!)
        
        tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    
    var result = [[Int]]()

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section <  2 ? 9 : 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "ResultTableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ResultTableViewCell  else {
            fatalError("The dequeued cell is not an instance of " + cellIdentifier + ".")
        }
        let row = indexPath.row + 9 * indexPath.section
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let courseHcp = appDelegate.round!.course.parList[row]
        let courseIndex = appDelegate.round!.course.indexList[row]
        
        cell.halLabel.text = String(row + 1)
        cell.hcpLabel.text = "(" + String(courseHcp) + ")"
        let data = row < result.count ? result[row] : [Int]()
        let resultFields = [cell.result1Label, cell.result2Label, cell.result3Label, cell.result4Label]
        let players = appDelegate.round!.players
        
        for col in 0 ..< 4 {
            resultFields[col]?.isHidden = data.count <= col
            if (col < players.count) {
                let hcp = GolfResult.calculateHcp(holePar: courseHcp, holeIndex: courseIndex, playerHcp: players[col].effectiveHcp!)
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
    
   
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let index = tableView.indexPath(for:sender as! UITableViewCell)?.row;
        let section = tableView.indexPath(for:sender as! UITableViewCell)?.section;
        let detailVC = segue.destination as! ScoreViewController
        detailVC.currentHole = index! + 9 * section!;
        BFLog("prepareForSegue %d", detailVC.currentHole);
    }
    
}
