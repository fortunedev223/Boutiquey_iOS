//
//  AddressViewCell.swift
//  OpenCartMpV3
//
//  Created by kunal on 15/12/17.
//  Copyright © 2017 kunal. All rights reserved.
//

import UIKit

class AddressViewCell: UITableViewCell {

@IBOutlet weak var addressValue: UILabel!
@IBOutlet weak var addressLabel: UILabel!
@IBOutlet weak var line: UILabel!
@IBOutlet weak var editButton: UIButton!
@IBOutlet weak var deleteButton: UIButton!
@IBOutlet weak var mainView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        mainView.backgroundColor = UIColor.white
        mainView.layer.cornerRadius = 10;
        mainView.myBorder()
        line.backgroundColor = UIColor().HexToColor(hexString: LIGHTGREY)
        editButton.setTitle(NetworkManager.sharedInstance.language(key: "editaddress"), for: .normal)
        deleteButton.setTitle(NetworkManager.sharedInstance.language(key: "deleteaddress"), for: .normal)
        addressLabel.textColor = UIColor().HexToColor(hexString: LIGHTGREY)
        editButton.setTitleColor(UIColor().HexToColor(hexString: BUTTON_COLOR), for: .normal)
        
        
   
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
