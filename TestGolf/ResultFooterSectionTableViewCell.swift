//
//  ResultFooterSectionTableViewCell.swift
//  TestGolf
//
//  Created by Martin Sjöblom on 2017-08-10.
//  Copyright © 2017 Martin Sjöblom. All rights reserved.
//

import UIKit

class ResultFooterSectionTableViewCell: UITableViewCell {
    @IBOutlet weak var roundDirectionLabel: UILabel!
    
    @IBOutlet weak var player1ResultLabel: UILabel!
    @IBOutlet weak var player2ResultLabel: UILabel!
    @IBOutlet weak var player3ResultLabel: UILabel!
    @IBOutlet weak var player4ResultLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
