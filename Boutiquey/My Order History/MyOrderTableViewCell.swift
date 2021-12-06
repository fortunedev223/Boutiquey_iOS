//
//  MyOrderTableViewCell.swift
//  WooCommerce
//
//  Created by Kunal Parsad on 18/11/17.
//  Copyright © 2017 Kunal Parsad. All rights reserved.
//

import UIKit

class MyOrderTableViewCell: UITableViewCell {
@IBOutlet weak var orderLabel: UILabel!
@IBOutlet weak var orderId: UILabel!
@IBOutlet weak var imageData: UIImageView!
@IBOutlet weak var statusMessage: UILabel!
@IBOutlet weak var placedonLabel: UILabel!
@IBOutlet weak var placedOnDate: UILabel!
@IBOutlet weak var orderDetails: UILabel!
@IBOutlet weak var mainView: UIView!
@IBOutlet weak var viewOrderButton: UIButton!
@IBOutlet weak var shipToLabel: UILabel!
@IBOutlet weak var shipToValue: UILabel!
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        orderLabel.textColor = UIColor().HexToColor(hexString: LIGHTGREY)
        orderLabel.text = NetworkManager.sharedInstance.language(key: "orderid")
        placedonLabel.text = NetworkManager.sharedInstance.language(key: "placeon")
        shipToLabel.text = NetworkManager.sharedInstance.language(key: "shipto")
        viewOrderButton.setTitle(NetworkManager.sharedInstance.language(key: "vieworder"), for: .normal)
        
        placedonLabel.textColor = UIColor().HexToColor(hexString: LIGHTGREY)
        statusMessage.textColor = UIColor().HexToColor(hexString: LIGHTGREY)
        shipToLabel.textColor = UIColor().HexToColor(hexString: LIGHTGREY)
        mainView.layer.cornerRadius = 2
        mainView.layer.shadowOffset = CGSize(width: 0, height: 0)
        mainView.layer.shadowRadius = 3
        mainView.layer.shadowOpacity = 0.5
        viewOrderButton.setTitleColor(UIColor().HexToColor(hexString: BUTTON_COLOR), for: .normal)
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
