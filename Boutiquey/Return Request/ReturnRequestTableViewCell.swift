//
//  ReturnRequestTableViewCell.swift
//  OpenCartApplication
//
//  Created by Kunal Parsad on 05/09/17.
//  Copyright © 2017 webkul. All rights reserved.
//

import UIKit

class ReturnRequestTableViewCell: UITableViewCell {
@IBOutlet weak var cellView: UIView!
    
@IBOutlet weak var statusLabel: UILabel!
@IBOutlet weak var statusLabelValue: UILabel!
@IBOutlet weak var dateAddedLabel: UILabel!
@IBOutlet weak var dateAddedLabelValue: UILabel!
@IBOutlet weak var orderIdLabel: UILabel!
@IBOutlet weak var orderIdLabelValue: UILabel!
@IBOutlet weak var customerLabel: UILabel!
@IBOutlet weak var customerLabelValue: UILabel!
@IBOutlet weak var viewButton: UIButton!
    
    @IBOutlet var returnIdLabel: UILabel!
    
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        returnIdLabel.layer.cornerRadius = 3;
        returnIdLabel.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        statusLabel.text = NetworkManager.sharedInstance.language(key: "status");
        dateAddedLabel.text = NetworkManager.sharedInstance.language(key: "dateadded");
        orderIdLabel.text = NetworkManager.sharedInstance.language(key: "orderid");
        customerLabel.text = NetworkManager.sharedInstance.language(key: "customer");
        viewButton.setTitleColor(UIColor().HexToColor(hexString: BUTTON_COLOR), for: .normal)
        viewButton.setTitle("view".localized, for: .normal)
    }
    
    
    
}
