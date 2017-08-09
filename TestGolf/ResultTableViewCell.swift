//
//  ResultTableViewCell.swift
//  TestGolf
//
//  Created by Martin Sjöblom on 2017-08-07.
//  Copyright © 2017 Martin Sjöblom. All rights reserved.
//

import UIKit

class ResultTableViewCell: UITableViewCell {
//MARK: Properties
    
    @IBOutlet weak var halLabel: UILabel!
    @IBOutlet weak var result1Label: UILabel!
    @IBOutlet weak var result2Label: UILabel!
    @IBOutlet weak var result3Label: UILabel!
    @IBOutlet weak var result4Label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
