//
//  ResultHeaderTableViewCell.swift
//  TestGolf
//
//  Created by Martin Sjöblom on 2017-08-09.
//  Copyright © 2017 Martin Sjöblom. All rights reserved.
//

import UIKit
import BugfenderSDK

class ResultHeaderTableViewCell: UITableViewCell {

    @IBOutlet weak var spelare1Label: UILabel!
    @IBOutlet weak var spelare2Label: UILabel!
    @IBOutlet weak var spelare3Label: UILabel!
    @IBOutlet weak var spelare4Label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        BFLog("HeaderTable: header init")
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let players = appDelegate.round!.players
        let fields = [spelare1Label, spelare2Label, spelare3Label, spelare4Label]
        for col in 0..<4 {
            let hcp = players.count > col ? String(players[col].effectiveHcp!) : ""
            fields[col]?.text = (players.count > col ? players[col].name  + " (" + hcp + ")" : "")
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
