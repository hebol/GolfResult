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
        spelare1Label.text = names[0].trim()
        spelare2Label.text = names[1].trim()
        spelare3Label.text = names[2].trim()
        spelare4Label.text = names[3].trim()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
