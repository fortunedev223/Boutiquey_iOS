//
//  DownloadTableViewCell.swift
//  OpenCartApplication
//
//  Created by Kunal Parsad on 04/09/17.
//  Copyright © 2017 webkul. All rights reserved.
//

import UIKit

class DownloadTableViewCell: UITableViewCell {

@IBOutlet weak var orderID: UILabel!
@IBOutlet weak var nameLabel: UILabel!
@IBOutlet weak var nameValue: UILabel!
@IBOutlet weak var sizeLabel: UILabel!
@IBOutlet weak var sizeValue: UILabel!
@IBOutlet weak var dateLabel: UIView!
@IBOutlet weak var dateValue: UILabel!
@IBOutlet weak var downloadButton: UIButton!
    
@IBOutlet weak var dateLabel1: UILabel!
@IBOutlet weak var containerView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        nameLabel.text = NetworkManager.sharedInstance.language(key: "name");
        sizeLabel.text = NetworkManager.sharedInstance.language(key: "size");
        dateLabel1.text = NetworkManager.sharedInstance.language(key: "date");
        downloadButton.setTitle(NetworkManager.sharedInstance.language(key: "downloads"), for: .normal)
    
    }
    
}
