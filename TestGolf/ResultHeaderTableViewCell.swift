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
        spelare1Label.text = names.count > 0 ? names[0] : ""
        spelare2Label.text = names.count > 1 ? names[1] : ""
        spelare3Label.text = names.count > 2 ? names[2] : ""
        spelare4Label.text = names.count > 3 ? names[3] : ""
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
