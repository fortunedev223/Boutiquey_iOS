//
//  ShippingAddressPicker.swift
//  OpenCartMpV3
//
//  Created by kunal on 21/12/17.
//  Copyright © 2017 kunal. All rights reserved.
//

import UIKit

class ShippingAddressPicker: UIViewController,UITableViewDelegate, UITableViewDataSource,NewAddressAddHandlerDelegate {
@IBOutlet weak var addNewAddressButton: UIButton!
@IBOutlet weak var addressTableView: UITableView!
var shippingAddressViewModel:ShippingAddressViewModel!
var addressPickerDelegate:ShippingAddressPickerDelegate!
let defaults = UserDefaults.standard;
var shippingId:String = ""
    

    override func viewDidLoad() {
        super.viewDidLoad()
        addressTableView.register(UINib(nibName: "PaymentTableViewCell", bundle: nil), forCellReuseIdentifier: "PaymentTableViewCell")
        addressTableView.rowHeight = UITableView.automaticDimension
        self.addressTableView.estimatedRowHeight = 50
        addressTableView.separatorColor = UIColor.clear
        addressTableView.dataSource = self
        addressTableView.delegate = self
        self.addNewAddressButton.setTitle(NetworkManager.sharedInstance.language(key: "addnewaddress"), for: .normal)

    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return shippingAddressViewModel.getShippingAddressData.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:PaymentTableViewCell = tableView.dequeueReusableCell(withIdentifier: "PaymentTableViewCell") as! PaymentTableViewCell
        cell.methodDescription.text = shippingAddressViewModel.getShippingAddressData[indexPath.row].addressData
        
        if shippingId == shippingAddressViewModel.getShippingAddressData[indexPath.row].addressId{
            cell.roundImageView.backgroundColor = UIColor().HexToColor(hexString: BUTTON_COLOR)
        }else{
            cell.roundImageView.backgroundColor = UIColor.white
        }
        
        return cell;
    }
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return NetworkManager.sharedInstance.language(key: "shippingaddress")
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        shippingId = shippingAddressViewModel.getShippingAddressData[indexPath.row].addressId
        let address = shippingAddressViewModel.getShippingAddressData[indexPath.row].addressData
        addressPickerDelegate.selectShippingAddress(data: true, addressId:shippingId , address: address!)
        self.navigationController?.popViewController(animated: true)
        
    }
    
    
    
    func newAddAddreressSuccess(data:Bool){
        callingHttppApi()
    }
    
    func loginRequest(){
        var loginRequest = [String:String]();
        loginRequest["apiKey"] = API_USER_NAME;
        loginRequest["apiPassword"] = API_KEY.md5;
        if self.defaults.object(forKey: "language") != nil{
            loginRequest["language"] = self.defaults.object(forKey: "language") as? String;
        }
        if self.defaults.object(forKey: "currency") != nil{
            loginRequest["currency"] = self.defaults.object(forKey: "currency") as? String;
        }
        if self.defaults.object(forKey: "customer_id") != nil{
            loginRequest["customer_id"] = self.defaults.object(forKey: "customer_id") as? String;
        }
        NetworkManager.sharedInstance.callingHttpRequest(params:loginRequest, apiname:"common/apiLogin", cuurentView: self){val,responseObject in
            if val == 1{
                let dict = responseObject as! NSDictionary
                
                self.defaults.set(dict.object(forKey: "wk_token") as! String, forKey: "wk_token")
                self.defaults.set(dict.object(forKey: "language") as! String, forKey: "language")
                self.defaults.set(dict.object(forKey: "currency") as! String, forKey: "currency")
                self.defaults.synchronize();
                self.callingHttppApi()
            }else if val == 2{
                NetworkManager.sharedInstance.dismissLoader()
                self.loginRequest();
                
            }
        }
    }
    
    
    func callingHttppApi(){
        self.view.isUserInteractionEnabled = false
        NetworkManager.sharedInstance.showLoader()
        let customerId = self.defaults.object(forKey:"customer_id");
        let sessionId = self.defaults.object(forKey:"wk_token");
        var requstParams = [String:Any]();
        requstParams["wk_token"] = sessionId;
        if customerId != nil{
            requstParams["function"] = "shippingAddress"
            requstParams["address_id"] = self.shippingId
            requstParams["payment_address"] = "existing"
        }
        NetworkManager.sharedInstance.callingHttpRequest(params:requstParams, apiname:"checkout/checkout", cuurentView: self){success,responseObject in
            if success == 1 {
                let dict = responseObject as! NSDictionary;
                if dict.object(forKey: "fault") != nil{
                    let fault = dict.object(forKey: "fault") as! Bool;
                    if fault == true{
                        self.loginRequest()
                    }
                }else{
                    self.view.isUserInteractionEnabled = true
                    NetworkManager.sharedInstance.dismissLoader()
                    self.shippingAddressViewModel = ShippingAddressViewModel(data:JSON(responseObject as! NSDictionary))
                    GlobalVariables.shippingAddressViewModel = self.shippingAddressViewModel
                    self.addressTableView.reloadData()
                    
                }
            }else if success == 2{
                NetworkManager.sharedInstance.dismissLoader()
                self.callingHttppApi();
            }
        }
        
        
        
    }
    
    
    
    
    
@IBAction func addNewAddressButtonClick(_ sender: UIButton) {
    self.performSegue(withIdentifier: "addnewaddress", sender: self)
}

    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier! == "addnewaddress") {
            let viewController:AddNewAddress = segue.destination as UIViewController as! AddNewAddress
            viewController.newAddressDelegate = self
            viewController.currentClass = "shipping"
            viewController.addNewAddress = true
            
            
        }
        
    }
    
    
    
    
    
}
