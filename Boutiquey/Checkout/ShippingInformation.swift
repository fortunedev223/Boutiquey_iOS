//
//  ShippingInformation.swift
//  OpenCartMpV3
//
//  Created by kunal on 20/12/17.
//  Copyright © 2017 kunal. All rights reserved.
//



@objc protocol ShippingAddressPickerDelegate: class {
    func selectShippingAddress(data:Bool,addressId:String,address:String)
    
}







import UIKit

class ShippingInformation: UIViewController,ShippingAddressPickerDelegate,UIPickerViewDelegate,UIPickerViewDataSource{
@IBOutlet weak var ParentView: UIView!
@IBOutlet weak var billingView: UIView!
@IBOutlet weak var line1: UILabel!

@IBOutlet weak var shippingView: UIView!
@IBOutlet weak var line2: UILabel!
@IBOutlet weak var line3: UILabel!
@IBOutlet weak var shipmentView: UIView!
@IBOutlet weak var line4: UILabel!
@IBOutlet weak var line5: UILabel!
@IBOutlet weak var paymentView: UIView!
@IBOutlet weak var line6: UILabel!
@IBOutlet weak var line7: UILabel!
@IBOutlet weak var reviewView: UIView!
@IBOutlet weak var line8: UILabel!

@IBOutlet weak var billingLabel: UILabel!
@IBOutlet weak var shippingLabel: UILabel!
@IBOutlet weak var shipmentLabel: UILabel!
@IBOutlet weak var paymentLabel: UILabel!
@IBOutlet weak var reviewLabel: UILabel!


@IBOutlet weak var view1: UIView!
@IBOutlet weak var view2: UIView!
@IBOutlet weak var view3: UIView!
@IBOutlet weak var view4: UIView!
@IBOutlet weak var view5: UIView!
    
    
    
    
    
@IBOutlet weak var continueButton: UIButton!
    
@IBOutlet weak var shippingAddress: UILabel!
@IBOutlet weak var shippingAddressLabel: UILabel!
@IBOutlet weak var changeAddressButton: UIButton!
@IBOutlet weak var signInViewHeight: NSLayoutConstraint!
@IBOutlet weak var signInView: UIView!
@IBOutlet weak var mainViewHeightConstarints: NSLayoutConstraint!
var whichApiToProcess = ""
let defaults = UserDefaults.standard;
var shippingId:String = ""
var shippingAddressViewModel:ShippingAddressViewModel!
var shipmentMethodViewModel:ShipmentMethodViewModel!
var billingAddressViewModel:BillingAddressViewModel!
    
    
@IBOutlet weak var guestView: UIView!
@IBOutlet weak var firstNametextField: UIFloatLabelTextField!
@IBOutlet weak var lastNameTextfield: UIFloatLabelTextField!
@IBOutlet weak var companyTextField: UIFloatLabelTextField!
@IBOutlet weak var addressLabel: UILabel!
@IBOutlet weak var street1Textfield: UIFloatLabelTextField!
@IBOutlet weak var street2textField: UIFloatLabelTextField!
@IBOutlet weak var citytextField: UIFloatLabelTextField!
@IBOutlet weak var ziptextField: UIFloatLabelTextField!
@IBOutlet weak var countryTextField: UIFloatLabelTextField!
@IBOutlet weak var stateTextField: UIFloatLabelTextField!
var stateArray:NSArray = []
var countryId:String  = ""
var zoneId:String = ""
var billingShippingSameFlag = "0";

    
    
    
    
    
    
    
    


    override func viewDidLoad() {
        super.viewDidLoad()
        ParentView.backgroundColor = UIColor().HexToColor(hexString: EXTRALIGHTGREY)
        billingView.backgroundColor = UIColor().HexToColor(hexString: LIGHTGREY)
        shippingView.backgroundColor = UIColor().HexToColor(hexString: LIGHTGREY)
        shipmentView.backgroundColor = UIColor().HexToColor(hexString: LIGHTGREY)
        paymentView.backgroundColor = UIColor().HexToColor(hexString: LIGHTGREY)
        reviewView.backgroundColor = UIColor().HexToColor(hexString: LIGHTGREY)
        view1.backgroundColor = UIColor().HexToColor(hexString: EXTRALIGHTGREY)
        view2.backgroundColor = UIColor().HexToColor(hexString: EXTRALIGHTGREY)
        view3.backgroundColor = UIColor().HexToColor(hexString: EXTRALIGHTGREY)
        view4.backgroundColor = UIColor().HexToColor(hexString: EXTRALIGHTGREY)
        view5.backgroundColor = UIColor().HexToColor(hexString: EXTRALIGHTGREY)
        
        line1.backgroundColor = UIColor().HexToColor(hexString: LIGHTGREY)
        line2.backgroundColor = UIColor().HexToColor(hexString: LIGHTGREY)
        line3.backgroundColor = UIColor().HexToColor(hexString: LIGHTGREY)
        line4.backgroundColor = UIColor().HexToColor(hexString: LIGHTGREY)
        line5.backgroundColor = UIColor().HexToColor(hexString: LIGHTGREY)
        line6.backgroundColor = UIColor().HexToColor(hexString: LIGHTGREY)
        line7.backgroundColor = UIColor().HexToColor(hexString: LIGHTGREY)
        line8.backgroundColor = UIColor().HexToColor(hexString: LIGHTGREY)
        
        
        billingView.layer.cornerRadius = 10
        billingView.layer.masksToBounds = true;
        billingView.layer.borderWidth = 2.0
        billingView.layer.backgroundColor = UIColor().HexToColor(hexString: BUTTON_COLOR).cgColor
        billingView.layer.borderColor = UIColor().HexToColor(hexString: BUTTON_COLOR).cgColor
        
        shippingView.layer.cornerRadius = 10
        shippingView.layer.masksToBounds = true;
        shippingView.layer.borderWidth = 2.0
        shippingView.layer.backgroundColor = UIColor.white.cgColor
        shippingView.layer.borderColor = UIColor().HexToColor(hexString: BUTTON_COLOR).cgColor
        
        shipmentView.layer.cornerRadius = 10
        shipmentView.layer.masksToBounds = true;
        
        paymentView.layer.cornerRadius = 10
        paymentView.layer.masksToBounds = true;
        
        reviewView.layer.cornerRadius = 10
        reviewView.layer.masksToBounds = true;
        
        
        signInView.layer.cornerRadius = 5;
        signInView.layer.borderWidth = 2.0
        signInView.layer.borderColor = UIColor().HexToColor(hexString: LIGHTGREY).cgColor
        
        let customerId = sharedPrefrence.object(forKey:"customer_id");
        
        let billingNavigationController = self.tabBarController?.viewControllers?[0]
        let nav = billingNavigationController as! UINavigationController;
        let billingViewController = nav.viewControllers[0] as! BillingInformation
        shippingAddressViewModel = billingViewController.shippingAddressViewModel
        
        if customerId != nil{
            mainViewHeightConstarints.constant = 600;
            signInView.isHidden = false
            guestView.isHidden  = true
            
            if self.shippingAddressViewModel.getShippingAddressData.count > 0{
                shippingAddress.text = self.shippingAddressViewModel.getShippingAddressData[0].addressData
                shippingId = self.shippingAddressViewModel.getShippingAddressData[0].addressId
            }
            signInViewHeight.constant = (shippingAddress.text?.height(withConstrainedWidth: SCREEN_WIDTH - 40, font: UIFont.systemFont(ofSize: 15)))! + 70
            
            
   
        }else{
            signInView.isHidden = true;
            guestView.isHidden = false
            mainViewHeightConstarints.constant = 650;
            signInViewHeight.constant = 0;
        }
   
        continueButton.backgroundColor = UIColor().HexToColor(hexString: BUTTON_COLOR)
        continueButton.setTitleColor(UIColor.white, for: .normal)
        continueButton.layer.cornerRadius = 5;
        continueButton.layer.masksToBounds = true
        continueButton.setTitle(NetworkManager.sharedInstance.language(key: "continue"), for: .normal)
        
        shippingAddressLabel.text = NetworkManager.sharedInstance.language(key: "shippingaddress")
        changeAddressButton.setTitle(NetworkManager.sharedInstance.language(key: "changeaddress"), for: .normal)
        billingLabel.text = NetworkManager.sharedInstance.language(key: "billingadd")
        shippingLabel.text = NetworkManager.sharedInstance.language(key: "shippingadd")
        paymentLabel.text = NetworkManager.sharedInstance.language(key: "payment")
        shipmentLabel.text = NetworkManager.sharedInstance.language(key: "shipment")
        reviewLabel.text = NetworkManager.sharedInstance.language(key: "reviews")
        
        
        self.navigationItem.title = "shippingaddress".localized
        addressLabel.text = NetworkManager.sharedInstance.language(key: "address")
        firstNametextField.placeholder = NetworkManager.sharedInstance.language(key: "firstname")+" "+ASTERISK
        lastNameTextfield.placeholder = NetworkManager.sharedInstance.language(key: "lastname")+" "+ASTERISK
        companyTextField.placeholder = NetworkManager.sharedInstance.language(key: "companyname")
        street1Textfield.placeholder = NetworkManager.sharedInstance.language(key: "street1")+" "+ASTERISK
        street2textField.placeholder = NetworkManager.sharedInstance.language(key: "street2")
        citytextField.placeholder = NetworkManager.sharedInstance.language(key: "city")+" "+ASTERISK
        ziptextField.placeholder = NetworkManager.sharedInstance.language(key: "zip")
        countryTextField.placeholder = NetworkManager.sharedInstance.language(key: "country")+" "+ASTERISK
        stateTextField.placeholder = NetworkManager.sharedInstance.language(key: "state")+" "+ASTERISK
        
        firstNametextField.applyAlingment()
        lastNameTextfield.applyAlingment()
        companyTextField.applyAlingment()
        street1Textfield.applyAlingment()
        street2textField.applyAlingment()
        citytextField.applyAlingment()
        ziptextField.applyAlingment()
        countryTextField.applyAlingment()
        stateTextField.applyAlingment()
        
    }
    
    
    
    @IBAction func billingClick(_ sender: UITapGestureRecognizer) {
        self.tabBarController!.selectedIndex = 0
    }
    
    
    
    @IBAction func closeController(_ sender: UIBarButtonItem) {
        GlobalVariables.proceedToCheckOut = false
        self.dismiss(animated: true)
    }
    
    
    
   
    
    @IBAction func CountryClick(_ sender: UIFloatLabelTextField) {
        let thePicker = UIPickerView()
        thePicker.tag = 2000;
        countryTextField.inputView = thePicker
        thePicker.delegate = self
        
    }
    
    
    @IBAction func StsteClick(_ sender: UIFloatLabelTextField) {
        let thePicker = UIPickerView()
        thePicker.tag = 3000;
        stateTextField.inputView = thePicker
        thePicker.delegate = self
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if(pickerView.tag == 2000){
            if billingShippingSameFlag == "1"{
                return self.billingAddressViewModel.getCountryData.count
            }else{
                return self.shippingAddressViewModel.getCountryData.count;
            }
        }
        else if(pickerView.tag == 3000){
            return stateArray.count;
        }else{
            return shippingAddressViewModel.getShippingAddressData.count
        }
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 2000{
            if billingShippingSameFlag == "1"{
                return billingAddressViewModel.getCountryData[row].countryName
            }
            else{
                return shippingAddressViewModel.getCountryData[row].countryName
                
            }
        }
        else if pickerView.tag == 3000{
            let dict = stateArray.object(at: row) as! NSDictionary;
            return dict.object(forKey: "name") as? String
        }else{
            pickerView.subviews[1].backgroundColor = UIColor.black
            pickerView.subviews[2].backgroundColor = UIColor.black
            return  shippingAddressViewModel.getShippingAddressData[row].addressData
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        if(pickerView.tag == 2000){
            if billingShippingSameFlag == "1"{
                countryTextField.text = billingAddressViewModel.getCountryData[row].countryName
                countryId = billingAddressViewModel.getCountryData[row].countryId
                stateArray = billingAddressViewModel.getCountryData[row].zoneArr! as NSArray
                if stateArray.count>0{
                    let dict = stateArray.object(at: 0) as! NSDictionary;
                    stateTextField.text = dict.object(forKey: "name") as? String
                    zoneId = (dict.object(forKey: "zone_id") as? String)!
                }
            }
            else{
                countryTextField.text = shippingAddressViewModel.getCountryData[row].countryName
                countryId = shippingAddressViewModel.getCountryData[row].countryId
                stateArray = shippingAddressViewModel.getCountryData[row].zoneArr! as NSArray
                if stateArray.count>0{
                    let dict = stateArray.object(at: 0) as! NSDictionary;
                    stateTextField.text = dict.object(forKey: "name") as? String
                    zoneId = (dict.object(forKey: "zone_id") as? String)!
                }
            }
            
        }else if (pickerView.tag == 3000){
            if stateArray.count>0{
                let dict = stateArray.object(at: row) as! NSDictionary;
                stateTextField.text = dict.object(forKey: "name") as? String
                zoneId = (dict.object(forKey: "zone_id") as? String)!
            }
        }
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
        
        if whichApiToProcess == "shippingmethod"{
        if customerId != nil{
            requstParams["function"] = "shippingMethod"
            requstParams["address_id"] = self.shippingId
            requstParams["shipping_address"] = "existing"
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
                    self.shipmentMethodViewModel = ShipmentMethodViewModel(data:JSON(responseObject as! NSDictionary))
                    self.doFurtherWork()
                   
                    
                }
            }else if success == 2{
                NetworkManager.sharedInstance.dismissLoader()
                self.callingHttppApi();
            }
        }
        }else{
            requstParams["function"] = "saveGuestShipping"
            requstParams["address_id"] = ""
            //requstParams["shipping_address"] = ""
            requstParams["firstname"] = self.firstNametextField.text
            requstParams["lastname"] = self.lastNameTextfield.text
            requstParams["company"] = self.companyTextField.text
            requstParams["address_1"] = self.street1Textfield.text
            requstParams["address_2"] = self.street2textField.text
            requstParams["city"] = self.citytextField.text
            requstParams["zone_id"] = self.zoneId
            requstParams["postcode"] = self.ziptextField.text
            requstParams["country_id"] = self.countryId
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
                        self.shipmentMethodViewModel = ShipmentMethodViewModel(data:JSON(responseObject as! NSDictionary))
                        self.doFurtherWork()
                    
                        
                    }
                }else if success == 2{
                    NetworkManager.sharedInstance.dismissLoader()
                    self.callingHttppApi();
                }
            }
            
            
            
            
        }
        
        
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        let billingNavigationController = self.tabBarController?.viewControllers?[0]
        let navBilling = billingNavigationController as! UINavigationController;
        let billingViewController = navBilling.viewControllers[0] as! BillingInformation
        
        let customerId = sharedPrefrence.object(forKey:"customer_id");
        if customerId == nil{
        if billingViewController.billingShippingSameFlag == "1"{
            billingAddressViewModel = billingViewController.billingAddressViewModel;
            billingShippingSameFlag = "1";
            if GlobalVariables.ExecuteShippingAddress == false{
                firstNametextField.text = billingViewController.firstNametextField.text
                lastNameTextfield.text = billingViewController.lastNameTextfield.text
                companyTextField.text = billingViewController.companyTextField.text
                street1Textfield.text = billingViewController.street1Textfield.text
                street2textField.text = billingViewController.street2textField.text
                citytextField.text = billingViewController.citytextField.text
                ziptextField.text = billingViewController.ziptextField.text
                countryTextField.text = billingViewController.countryTextField.text
                stateTextField.text = billingViewController.stateTextField.text
                countryId = billingViewController.countryId
                zoneId = billingViewController.zoneId
                GlobalVariables.ExecuteShippingAddress = true;
            }
        }
        else{
            let billingNavigationController = self.tabBarController?.viewControllers?[0]
            let nav = billingNavigationController as! UINavigationController;
            let billingViewController = nav.viewControllers[0] as! BillingInformation
            shippingAddressViewModel = billingViewController.shippingAddressViewModel;
            
        }
    }
    
    
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    func doFurtherWork(){
        self.tabBarController?.tabBar.items?[2].isEnabled = true
        GlobalVariables.CurrentIndex = 3;
        self.tabBarController!.selectedIndex = 2
    
    }
    
    
    
    
    func selectShippingAddress(data:Bool,addressId:String,address:String){
        self.shippingId = addressId
        shippingAddress.text = address
        signInViewHeight.constant = (shippingAddress.text?.height(withConstrainedWidth: SCREEN_WIDTH - 40, font: UIFont.systemFont(ofSize: 15)))! + 70
    }
    
    
    @IBAction func continueClick(_ sender: UIButton) {
        let customerId = sharedPrefrence.object(forKey:"customer_id");
        if customerId != nil{
           whichApiToProcess = "shippingmethod"
           callingHttppApi()
        }else{
            var isValid:Int = 0
            var errorMessage = NetworkManager.sharedInstance.language(key: "pleaseselect");
            if firstNametextField.text == ""{
                isValid = 1;
                errorMessage = errorMessage+NetworkManager.sharedInstance.language(key: "firstname");
            }else if lastNameTextfield.text == ""{
                isValid = 1;
                errorMessage = errorMessage+NetworkManager.sharedInstance.language(key: "lastname");
            }else if street1Textfield.text == ""{
                isValid = 1;
                errorMessage = errorMessage+NetworkManager.sharedInstance.language(key: "street1");
            }else if citytextField.text == ""{
                isValid = 1;
                errorMessage = errorMessage+NetworkManager.sharedInstance.language(key: "city");
            }else if ziptextField.text == ""{
                isValid = 1;
                errorMessage = errorMessage+NetworkManager.sharedInstance.language(key: "zip");
            }else if countryTextField.text == ""{
                isValid = 1;
                errorMessage = errorMessage+NetworkManager.sharedInstance.language(key: "country");
            }else if stateTextField.text == ""{
                isValid = 1;
                errorMessage = errorMessage+NetworkManager.sharedInstance.language(key: "state");
            }
            
            if isValid == 1{
                NetworkManager.sharedInstance.showErrorSnackBar(msg: errorMessage)
            }else{
                whichApiToProcess = "";
                callingHttppApi()
                
            }
            
            
        }
    }
    
    

   
    @IBAction func ChangeAddressClick(_ sender: UIButton) {
       self.performSegue(withIdentifier: "addresspicker", sender: self)
    
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier! == "addresspicker") {
            let viewController:ShippingAddressPicker = segue.destination as UIViewController as! ShippingAddressPicker
            viewController.shippingAddressViewModel = GlobalVariables.shippingAddressViewModel
            viewController.shippingId = self.shippingId
            viewController.addressPickerDelegate = self
        }
        
    }
    
    
    
    

}
