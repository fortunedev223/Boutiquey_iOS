//
//  RewardTableViewCell.swift
//  BroPhone
//
//  Created by kunal on 15/01/18.
//  Copyright © 2018 kunal. All rights reserved.
//

import UIKit

class RewardTableViewCell: UITableViewCell {
    
@IBOutlet weak var dateLabel: UILabel!
@IBOutlet weak var dateValue: UILabel!
@IBOutlet weak var descriptionLabel: UILabel!
@IBOutlet weak var descriptionValue: UILabel!
@IBOutlet weak var pointsLabel: UILabel!
@IBOutlet weak var pointsValue: UILabel!
@IBOutlet weak var mainView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
       dateLabel.text = NetworkManager.sharedInstance.language(key: "date")
       descriptionLabel.text = NetworkManager.sharedInstance.language(key: "description")
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
