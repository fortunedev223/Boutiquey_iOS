//
//  SpecificationCell.swift
//  Opencart
//
//  Created by kunal on 12/01/18.
//  Copyright © 2018 Kunal Parsad. All rights reserved.
//

import UIKit

class SpecificationCell: UITableViewCell {

@IBOutlet weak var heading: UILabel!
@IBOutlet weak var value: UILabel!
@IBOutlet weak var mainView: UIView!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        mainView.layer.cornerRadius = 2
        mainView.layer.shadowOffset = CGSize(width: 0, height: 0)
        mainView.layer.shadowRadius = 3
        mainView.layer.shadowOpacity = 0.5
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
