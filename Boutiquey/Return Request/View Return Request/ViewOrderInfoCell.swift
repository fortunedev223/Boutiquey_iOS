//
//  ViewOrderInfoCell.swift
//  Boutiquey
//
//  Created by kunal on 02/06/18.
//  Copyright © 2018 yogesh. All rights reserved.
//

import UIKit

class ViewOrderInfoCell: UITableViewCell {

@IBOutlet var returnDetailsLabel: UILabel!
@IBOutlet var retiurnIdLabel: UILabel!
@IBOutlet var orderIdLabel: UILabel!
@IBOutlet var dateAddedLabel: UILabel!
@IBOutlet var orderDateLabel: UILabel!
@IBOutlet var productInformationLabel: UILabel!
@IBOutlet var productNameLabel: UILabel!
@IBOutlet var productNameLabelValue: UILabel!
@IBOutlet var modelLabel: UILabel!
@IBOutlet var modelLabelValue: UILabel!
@IBOutlet var qtyLabel: UILabel!
@IBOutlet var qtyLabelValue: UILabel!
@IBOutlet var reasonforReturnLabel: UILabel!
@IBOutlet var reasonLabel: UILabel!
@IBOutlet var reasonLabelValue: UILabel!
@IBOutlet var openedLabel: UILabel!
@IBOutlet var openedLabelValue: UILabel!
@IBOutlet var actionLabel: UILabel!
@IBOutlet var actionLabelValue: UILabel!
    
    @IBOutlet var mainView: UIView!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        returnDetailsLabel.text = NetworkManager.sharedInstance.language(key: "returndetails")
        productInformationLabel.text = NetworkManager.sharedInstance.language(key: "productinfo")
        productNameLabel.text = NetworkManager.sharedInstance.language(key: "product")+" "+":"
        modelLabel.text = NetworkManager.sharedInstance.language(key: "model")+" "+":"
        qtyLabel.text = NetworkManager.sharedInstance.language(key: "qty")
        reasonforReturnLabel.text = NetworkManager.sharedInstance.language(key: "reasonforreturn")
        reasonLabel.text = NetworkManager.sharedInstance.language(key: "reason")+" "+":"
        openedLabel.text = NetworkManager.sharedInstance.language(key: "opened")+" "+":"
        actionLabel.text = NetworkManager.sharedInstance.language(key: "action")+" "+":"
        mainView.layer.cornerRadius = 2
        mainView.layer.shadowOffset = CGSize(width: 0, height: 0)
        mainView.layer.shadowRadius = 3
        mainView.layer.shadowOpacity = 0.5
        
        productNameLabel.textColor = UIColor().HexToColor(hexString: LIGHTGREY)
        modelLabel.textColor = UIColor().HexToColor(hexString: LIGHTGREY)
        qtyLabel.textColor = UIColor().HexToColor(hexString: LIGHTGREY)
        reasonLabel.textColor = UIColor().HexToColor(hexString: LIGHTGREY)
        openedLabel.textColor = UIColor().HexToColor(hexString: LIGHTGREY)
        actionLabel.textColor = UIColor().HexToColor(hexString: LIGHTGREY)
        
    
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
