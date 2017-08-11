//
//  ResultHeaderTableViewCell.swift
//  TestGolf
//
//  Created by Martin Sjöblom on 2017-08-09.
//  Copyright © 2017 Martin Sjöblom. All rights reserved.
//

import UIKit

class ResultHeaderTableViewCell: UITableViewCell {

    @IBOutlet weak var spelare1Label: UILabel!
    @IBOutlet weak var spelare2Label: UILabel!
    @IBOutlet weak var spelare3Label: UILabel!
    @IBOutlet weak var spelare4Label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        NSLog("App: header init")
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let names = appDelegate.getPlayerNames()
        let hcps = appDelegate.getPlayerHcps()
        let fields = [spelare1Label, spelare2Label, spelare3Label, spelare4Label]
        for col in 0..<4 {
            let hcp = hcps.count > col ? String(hcps[col]) : ""
            fields[col]?.text = (names.count > col ? names[col]  + " (" + hcp + ")" : "")
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
