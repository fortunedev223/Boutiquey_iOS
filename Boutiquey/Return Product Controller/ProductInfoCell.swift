//
//  ProductInfoCell.swift
//  Boutiquey
//
//  Created by kunal on 08/06/18.
//  Copyright © 2018 yogesh. All rights reserved.
//

import UIKit

class ProductInfoCell: UITableViewCell {

@IBOutlet var productNameField: UIFloatLabelTextField!
@IBOutlet var productCodeField: UIFloatLabelTextField!
@IBOutlet var quantityField: UIFloatLabelTextField!
@IBOutlet var productopenedLAbel: UILabel!
@IBOutlet var faultsLabel: UILabel!
@IBOutlet var faultField: UITextField!
 var productReturnViewModel:ProductReturnViewModel!
    
    @IBOutlet var switchButton: UISwitch!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
       productNameField.placeholder = NetworkManager.sharedInstance.language(key: "productname")+NetworkManager.sharedInstance.language(key: "required")
        productCodeField.placeholder = NetworkManager.sharedInstance.language(key: "productcode")+NetworkManager.sharedInstance.language(key: "required")
        quantityField.placeholder = NetworkManager.sharedInstance.language(key: "qty")+NetworkManager.sharedInstance.language(key: "required")
        productopenedLAbel.text = NetworkManager.sharedInstance.language(key: "productisopened")
        faultsLabel.text = NetworkManager.sharedInstance.language(key: "faults")
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

      
    }
    
    
    
    
    @IBAction func switchClick(_ sender: UISwitch) {
        productReturnViewModel.productReturnModel.isOpened = sender.isOn
        
    }
    
    @IBAction func productNameClick(_ sender: UIFloatLabelTextField) {
        productReturnViewModel.productReturnModel.product = sender.text!
    }
    
 
    
    @IBAction func productcodeFieldClick(_ sender: UIFloatLabelTextField) {
        productReturnViewModel.productReturnModel.model = sender.text!
    }
    
    
    
    
    
    @IBAction func quantFieldClick(_ sender: UIFloatLabelTextField) {
        productReturnViewModel.productReturnModel.qty = sender.text!
    }
    
    
    
    @IBAction func faultFieldClick(_ sender: UITextField) {
        productReturnViewModel.productReturnModel.faultMessage = sender.text!
    }
    
    
    
    
    
    
    
    
    
    
    
}
