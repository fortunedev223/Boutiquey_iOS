//
//  BillingInformation.swift
//  OpenCartMpV3
//
//  Created by kunal on 19/12/17.
//  Copyright © 2017 kunal. All rights reserved.
//



@objc protocol BillingAddressPickerDelegate: class {
    func selectBillingAddress(data:Bool,addressId:String,address:String)
    
}










import UIKit

class BillingInformation: UIViewController,BillingAddressPickerDelegate,UIPickerViewDelegate,UIPickerViewDataSource {

    
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
@IBOutlet weak var billingAddressLabel: UILabel!
    
    
    
    
    
    
@IBOutlet weak var view1: UIView!
@IBOutlet weak var view2: UIView!
@IBOutlet weak var view3: UIView!
@IBOutlet weak var view4: UIView!
@IBOutlet weak var view5: UIView!
    
    
@IBOutlet weak var billingAddress: UILabel!
@IBOutlet weak var changeAddressButton: UIButton!
@IBOutlet weak var signInViewHeight: NSLayoutConstraint!
@IBOutlet weak var signInView: UIView!
@IBOutlet weak var mainViewHeightConstarints: NSLayoutConstraint!
@IBOutlet weak var guestView: UIView!
@IBOutlet weak var firstNametextField: UIFloatLabelTextField!
@IBOutlet weak var lastNameTextfield: UIFloatLabelTextField!
@IBOutlet weak var emailAddresstextField: UIFloatLabelTextField!
@IBOutlet weak var telephoneTextFiel: UIFloatLabelTextField!
@IBOutlet weak var faxTextField: UIFloatLabelTextField!
@IBOutlet weak var companyTextField: UIFloatLabelTextField!
@IBOutlet weak var addressLabel: UILabel!
@IBOutlet weak var street1Textfield: UIFloatLabelTextField!
@IBOutlet weak var street2textField: UIFloatLabelTextField!
@IBOutlet weak var citytextField: UIFloatLabelTextField!
@IBOutlet weak var ziptextField: UIFloatLabelTextField!
@IBOutlet weak var countryTextField: UIFloatLabelTextField!
@IBOutlet weak var stateTextField: UIFloatLabelTextField!
@IBOutlet weak var shipToThisLabel: UILabel!
@IBOutlet weak var continueButton: UIButton!
var billingShippingSameFlag = "0";
    
    
 
@IBOutlet var mainView: UIView!
    
var stateArray:NSArray = []
var countryId:String  = ""
var zoneId:String = ""
var addressId:String = ""
var whichApiToProcess = ""
let defaults = UserDefaults.standard;
var billingAddressViewModel:BillingAddressViewModel!
var shippingAddressViewModel:ShippingAddressViewModel!
var shipmentMethodViewModel:ShipmentMethodViewModel!
var paymentMethodViewModel :PaymentMethodViewModel!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "billingaddress".localized
        self.navigationController!.isNavigationBarHidden = false
        self.tabBarController?.navigationController?.navigationBar.isHidden = true
        self.tabBarController?.tabBar.isHidden = true
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
        
        self.continueButton.setTitle(NetworkManager.sharedInstance.language(key: "continue"), for: .normal)

        
        billingView.layer.cornerRadius = 10
        billingView.layer.masksToBounds = true;
        billingView.layer.borderWidth = 2.0
        billingView.layer.backgroundColor = UIColor.white.cgColor
        billingView.layer.borderColor = UIColor().HexToColor(hexString: BUTTON_COLOR).cgColor
        
        shippingView.layer.cornerRadius = 10
        shippingView.layer.masksToBounds = true;
        
        shipmentView.layer.cornerRadius = 10
        shipmentView.layer.masksToBounds = true;
        
        paymentView.layer.cornerRadius = 10
        paymentView.layer.masksToBounds = true;
        
        reviewView.layer.cornerRadius = 10
        reviewView.layer.masksToBounds = true;
        
        
        let sessionId = defaults.object(forKey:"wk_token")
        let customerId = sharedPrefrence.object(forKey:"customer_id");
        whichApiToProcess = ""
        if customerId != nil{
            mainViewHeightConstarints.constant = 600;
            signInView.isHidden = false
            guestView.isHidden  = true
            
            
        }else{
            signInView.isHidden = true;
            guestView.isHidden = false
            mainViewHeightConstarints.constant = 850;
            signInViewHeight.constant = 0;
        }
        
        
        signInView.layer.cornerRadius = 5;
        signInView.layer.borderWidth = 2.0
        signInView.layer.borderColor = UIColor().HexToColor(hexString: LIGHTGREY).cgColor
        continueButton.backgroundColor = UIColor().HexToColor(hexString: BUTTON_COLOR)
        continueButton.setTitleColor(UIColor.white, for: .normal)
        continueButton.layer.cornerRadius = 5;
        continueButton.layer.masksToBounds = true
        
        
        if(sessionId == nil){
            loginRequest();
        }
        else{
            callingHttppApi();
            
        }
        
        addressLabel.text = NetworkManager.sharedInstance.language(key: "address")
        firstNametextField.placeholder = NetworkManager.sharedInstance.language(key: "firstname")+" "+ASTERISK
        lastNameTextfield.placeholder = NetworkManager.sharedInstance.language(key: "lastname")+" "+ASTERISK
        emailAddresstextField.placeholder = NetworkManager.sharedInstance.language(key: "email")+" "+ASTERISK
        telephoneTextFiel.placeholder = NetworkManager.sharedInstance.language(key: "telephoneno")+" "+ASTERISK
        faxTextField.placeholder = NetworkManager.sharedInstance.language(key: "fax")
        companyTextField.placeholder = NetworkManager.sharedInstance.language(key: "companyname")
        street1Textfield.placeholder = NetworkManager.sharedInstance.language(key: "street1")+" "+ASTERISK
        street2textField.placeholder = NetworkManager.sharedInstance.language(key: "street2")
        citytextField.placeholder = NetworkManager.sharedInstance.language(key: "city")+" "+ASTERISK
        ziptextField.placeholder = NetworkManager.sharedInstance.language(key: "zip")+" "+ASTERISK
        countryTextField.placeholder = NetworkManager.sharedInstance.language(key: "country")+" "+ASTERISK
        stateTextField.placeholder = NetworkManager.sharedInstance.language(key: "state")+" "+ASTERISK
        shipToThisLabel.text = NetworkManager.sharedInstance.language(key: "shiptothisaddress")
        
        billingAddressLabel.text = NetworkManager.sharedInstance.language(key: "billingaddress")
        changeAddressButton.setTitle(NetworkManager.sharedInstance.language(key: "changeaddress"), for: .normal)
        billingLabel.text = NetworkManager.sharedInstance.language(key: "billingadd")
        shippingLabel.text = NetworkManager.sharedInstance.language(key: "shippingadd")
        paymentLabel.text = NetworkManager.sharedInstance.language(key: "payment")
        shipmentLabel.text = NetworkManager.sharedInstance.language(key: "shipment")
        reviewLabel.text = NetworkManager.sharedInstance.language(key: "reviews")
        
        self.mainView.isHidden = true
        
        
        
        firstNametextField.applyAlingment()
        lastNameTextfield.applyAlingment()
        emailAddresstextField.applyAlingment()
        telephoneTextFiel.applyAlingment()
        faxTextField.applyAlingment()
        companyTextField.applyAlingment()
        street1Textfield.applyAlingment()
        street2textField.applyAlingment()
        citytextField.applyAlingment()
        ziptextField.applyAlingment()
        countryTextField.applyAlingment()
        stateTextField.applyAlingment()
        
        
        
        
        
  
    }

    
    func selectBillingAddress(data:Bool,addressId:String,address:String){
        self.addressId = addressId
        billingAddress.text = address
        signInViewHeight.constant = (billingAddress.text?.height(withConstrainedWidth: SCREEN_WIDTH - 40, font: UIFont.systemFont(ofSize: 15)))! + 70
    }
    
    
    
    @IBAction func ClickOnCountry(_ sender: UIFloatLabelTextField) {
        let thePicker = UIPickerView()
        thePicker.tag = 2000;
        countryTextField.inputView = thePicker
        thePicker.delegate = self
    }
    
    @IBAction func ClickOnState(_ sender: UIFloatLabelTextField) {
        let thePicker = UIPickerView()
        thePicker.tag = 3000;
        stateTextField.inputView = thePicker
        thePicker.delegate = self
    }
    
    
    @IBAction func ShipToThisAddressSwitch(_ sender: UISwitch) {
        if sender.isOn{
            billingShippingSameFlag = "1";
        }else{
            billingShippingSameFlag = "0";
        }
        
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if(pickerView.tag == 2000){
            return self.billingAddressViewModel.getCountryData.count;
        }
        else if(pickerView.tag == 3000){
            return stateArray.count;
        }else {
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 2000{
            return billingAddressViewModel.getCountryData[row].countryName
        }else if pickerView.tag == 3000{
            let dict = stateArray.object(at: row) as! NSDictionary;
            return dict.object(forKey: "name") as? String
        }
        else {
            return ""
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        if(pickerView.tag == 2000){
            countryTextField.text = billingAddressViewModel.getCountryData[row].countryName
            countryId = billingAddressViewModel.getCountryData[row].countryId
            stateArray = billingAddressViewModel.getCountryData[row].zoneArr! as NSArray
            if stateArray.count>0{
                let dict = stateArray.object(at: 0) as! NSDictionary;
                stateTextField.text = dict.object(forKey: "name") as? String
                zoneId = (dict.object(forKey: "zone_id") as? String)!
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
        
        if whichApiToProcess == "shippingAddress"{
            if customerId != nil{
                requstParams["function"] = "shippingAddress"
                requstParams["address_id"] = self.addressId
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
                        if self.billingAddressViewModel.isShippingRequired == 0{
                            self.paymentMethodViewModel = PaymentMethodViewModel(data:JSON(responseObject as! NSDictionary))
                        }
                        
                        self.doFurtherWork()
                       
                        
                    }
                }else if success == 2{
                    NetworkManager.sharedInstance.dismissLoader()
                    self.callingHttppApi();
                }
            }
            
        }else if whichApiToProcess == "saveguest"{
            requstParams["function"] = "saveGuest"
            requstParams["address_id"] = ""
            requstParams["shipping_address"] = self.billingShippingSameFlag
            requstParams["email"] = self.emailAddresstextField.text
            requstParams["telephone"] = self.telephoneTextFiel.text
            requstParams["fax"] = self.faxTextField.text
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
                        if self.billingShippingSameFlag == "1"{
                            self.shipmentMethodViewModel = ShipmentMethodViewModel(data:JSON(responseObject as! NSDictionary))
                        }else{
                            self.shippingAddressViewModel = ShippingAddressViewModel(data:JSON(responseObject as! NSDictionary))
                        }
                        self.doFurtherWork()
                    
                        
                    }
                }else if success == 2{
                    NetworkManager.sharedInstance.dismissLoader()
                    self.callingHttppApi();
                }
            }
     
        }
        else{
        if customerId != nil{
            requstParams["function"] = "paymentAddress"
        }else{
            requstParams["function"] = "guest"
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
                        self.mainView.isHidden = false
                        let responseData =  JSON(responseObject as! NSDictionary)
                       
                        if responseData["error"].intValue == 1{
                            NetworkManager.sharedInstance.showWarningSnackBar(msg: "somethingwentwrongpleasetryagain".localized)
                            GlobalVariables.proceedToCheckOut = false
                            self.dismiss(animated: true)
                        }else{
                        self.billingAddressViewModel = BillingAddressViewModel(data:responseData)
                        GlobalVariables.billingAddressViewModel = self.billingAddressViewModel
                        self.doFurtherWork()
                        
                        }
                    }
                }else if success == 2{
                    NetworkManager.sharedInstance.dismissLoader()
                    self.callingHttppApi();
                }
            }
    
        }
        
    }
    
    
    
    
    @IBAction func ChangeAddressClick(_ sender: UIButton) {
        self.performSegue(withIdentifier: "addresspicker", sender: self)
    }
    
    
    
    @IBAction func continueClick(_ sender: UIButton) {
        let customerId = sharedPrefrence.object(forKey:"customer_id");
        if customerId != nil{
            self.tabBarController?.tabBar.items?[1].isEnabled = true
            GlobalVariables.CurrentIndex = 2;
            whichApiToProcess = "shippingAddress"
            if self.addressId == ""{
                let AC = UIAlertController(title: NetworkManager.sharedInstance.language(key: "warning"), message:NetworkManager.sharedInstance.language(key: "youdonthaveaddress") , preferredStyle: .alert)
                let okBtn = UIAlertAction(title: NetworkManager.sharedInstance.language(key: "ok"), style: .default, handler: {(_ action: UIAlertAction) -> Void in
                })
                AC.addAction(okBtn)
                self.present(AC, animated: true, completion: {  })
            }else{
                callingHttppApi()
            }
        }else{
            var isValid:Int = 0
            var errorMessage = NetworkManager.sharedInstance.language(key: "pleaseselect")+" ";
            if firstNametextField.text == ""{
                isValid = 1;
                errorMessage = errorMessage+NetworkManager.sharedInstance.language(key: "firstname");
            }else if lastNameTextfield.text == ""{
                isValid = 1;
                errorMessage = errorMessage+NetworkManager.sharedInstance.language(key: "lastname");
            }else if emailAddresstextField.text == ""{
                isValid = 1;
                errorMessage = errorMessage+NetworkManager.sharedInstance.language(key: "email");
            }else if NetworkManager.sharedInstance.emailTest(emailText: emailAddresstextField.text!){
                isValid = 1;
                errorMessage = NetworkManager.sharedInstance.language(key:"invalidemail");
            }
            else if telephoneTextFiel.text == ""{
                isValid = 1;
                errorMessage = errorMessage+NetworkManager.sharedInstance.language(key: "telephoneno");
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
                whichApiToProcess = "saveguest";
                callingHttppApi()
                
            }

            
        }
        
        
        
    }
    
    
    @IBAction func CloseController(_ sender: UIBarButtonItem) {
        GlobalVariables.proceedToCheckOut = false
        self.dismiss(animated: true)
    }
    
    
    func doFurtherWork(){
        if whichApiToProcess == "shippingAddress"{
            if self.billingAddressViewModel.isShippingRequired == 1{
                GlobalVariables.CurrentIndex = 2;
                self.tabBarController!.selectedIndex = 1
            }else{
                GlobalVariables.CurrentIndex = 4;
                self.tabBarController!.selectedIndex = 3
            }
        }else if self.whichApiToProcess == "saveguest"{
            if self.billingShippingSameFlag == "1"{
                GlobalVariables.ExecuteShippingAddress = false
                self.tabBarController?.tabBar.items?[1].isEnabled = true
                self.tabBarController?.tabBar.items?[2].isEnabled = true
                self.tabBarController!.selectedIndex = 2
            }else{
                self.tabBarController?.tabBar.items?[1].isEnabled = true
                GlobalVariables.CurrentIndex = 2;
                self.tabBarController!.selectedIndex = 1
            }
            
            
        }
        else{
        let customerId = sharedPrefrence.object(forKey:"customer_id");
        if customerId != nil{
        if self.billingAddressViewModel.getBillingAddressData.count > 0{
            billingAddress.text = self.billingAddressViewModel.getBillingAddressData[0].addressData
            addressId = self.billingAddressViewModel.getBillingAddressData[0].addressId
        }else{
            addressId = ""
            billingAddress.text = NetworkManager.sharedInstance.language(key: "youdonthaveaddress");
        }
        signInViewHeight.constant = (billingAddress.text?.height(withConstrainedWidth: SCREEN_WIDTH - 40, font: UIFont.systemFont(ofSize: 15)))! + 70
        }else{
            let defaultCountryID = billingAddressViewModel.countryID
            var pos = -1;
            var i = 0
            
            for data in self.billingAddressViewModel.billingCountryData{
                if data.countryId == defaultCountryID{
                    pos = i
                    break;
                }
                i = i+1
            }
            
            if pos != -1{
                countryTextField.text = billingAddressViewModel.getCountryData[pos].countryName
                countryId = billingAddressViewModel.getCountryData[pos].countryId
                stateArray = billingAddressViewModel.getCountryData[pos].zoneArr! as NSArray
                if stateArray.count>0{
                    let dict = stateArray.object(at: 0) as! NSDictionary;
                    stateTextField.text = dict.object(forKey: "name") as? String
                    zoneId = (dict.object(forKey: "zone_id") as? String)!
                }
            }
            
            }
        }
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier! == "addresspicker") {
            let viewController:BillingAddressPicker = segue.destination as UIViewController as! BillingAddressPicker
            viewController.billingAddressViewModel = GlobalVariables.billingAddressViewModel
            viewController.addressID = self.addressId
            viewController.addressPickerDelegate = self
        }
        
    }
    
    
    

}
