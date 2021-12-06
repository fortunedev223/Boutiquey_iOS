//
//  PriceCellTableViewCell.swift
//  Abdullah
//
//  Created by kunal on 03/02/18.
//  Copyright © 2018 kunal. All rights reserved.
//

import UIKit

class PriceCellTableViewCell: UITableViewCell {
    
@IBOutlet weak var title: UILabel!
@IBOutlet weak var value: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
