//
//  CustomerInfoCell.swift
//  Boutiquey
//
//  Created by kunal on 08/06/18.
//  Copyright © 2018 yogesh. All rights reserved.
//

import UIKit

class CustomerInfoCell: UITableViewCell {

    @IBOutlet var firstNameField: UIFloatLabelTextField!
    @IBOutlet var lastNameField: UIFloatLabelTextField!
    @IBOutlet var emailField: UIFloatLabelTextField!
    @IBOutlet var telephoneField: UIFloatLabelTextField!
    @IBOutlet var orderIdField: UIFloatLabelTextField!
    @IBOutlet var dateField: UIFloatLabelTextField!
    var productReturnViewModel:ProductReturnViewModel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.firstNameField.placeholder = NetworkManager.sharedInstance.language(key: "firstname")+" "+ASTERISK
        self.lastNameField.placeholder = NetworkManager.sharedInstance.language(key: "lastname")+" "+ASTERISK
        self.emailField.placeholder = NetworkManager.sharedInstance.language(key: "email")+" "+ASTERISK
        self.telephoneField.placeholder = NetworkManager.sharedInstance.language(key: "telephoneno")+" "+ASTERISK
        self.orderIdField.placeholder = NetworkManager.sharedInstance.language(key: "orderid")+" "+ASTERISK
        self.dateField.placeholder = NetworkManager.sharedInstance.language(key: "date")+" "+ASTERISK

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    
    
    
    
    
    
    @IBAction func firstNameClick(_ sender: UIFloatLabelTextField) {
        productReturnViewModel.productReturnModel.firstname = sender.text!
    }
    
    
    @IBAction func lastNameClick(_ sender: UIFloatLabelTextField) {
        productReturnViewModel.productReturnModel.lastname = sender.text!
    }
    
    
    @IBAction func emailClick(_ sender: UIFloatLabelTextField) {
        productReturnViewModel.productReturnModel.email = sender.text!
    }
    
    
    
    @IBAction func TelephoneClick(_ sender: UIFloatLabelTextField) {
        productReturnViewModel.productReturnModel.telephone = sender.text!
    }
    
    
    
    
    @IBAction func orderIdClick(_ sender: UIFloatLabelTextField) {
        productReturnViewModel.productReturnModel.order_id = sender.text!
    }
    
    
    
    
    @IBAction func orderDateClick(_ sender: UIFloatLabelTextField) {
        let datePickerView:UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePicker.Mode.date
        sender.inputView = datePickerView
        
        datePickerView.addTarget(self, action: #selector(CustomerInfoCell.datePickerFromValueChanged), for: UIControl.Event.valueChanged)
    }
    
    @objc func datePickerFromValueChanged(sender:UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateField.text = dateFormatter.string(from: sender.date)
        productReturnViewModel.productReturnModel.date_ordered = dateFormatter.string(from: sender.date)
        
    }
    
    
    
    
}
