//
//  CreateAccount.swift
//  OpenCartApplication
//
//  Created by shobhit on 16/08/17.
//  Copyright © 2017 webkul. All rights reserved.
//

import UIKit

class CreateAccount: UIViewController, UIPickerViewDelegate,UIPickerViewDataSource{
    
    var createAccountViewModel:CreateAccountViewModel!
    var stateArray:NSArray = []

    
    @IBOutlet weak var firstNameTextField: UIFloatLabelTextField!
    @IBOutlet weak var lastNameTextField: UIFloatLabelTextField!
    @IBOutlet weak var emailTextField: UIFloatLabelTextField!
    @IBOutlet weak var mobilrNumberTextField: UIFloatLabelTextField!
    @IBOutlet weak var faxTextField: UIFloatLabelTextField!
    @IBOutlet weak var companyTextField: UIFloatLabelTextField!
    @IBOutlet weak var address1TextField: UIFloatLabelTextField!
    @IBOutlet weak var address2TextField: UIFloatLabelTextField!
    @IBOutlet weak var cityTextField: UIFloatLabelTextField!
    @IBOutlet weak var zipTextField: UIFloatLabelTextField!
    @IBOutlet weak var countryTextField: UIFloatLabelTextField!
    @IBOutlet weak var stateTextField: UIFloatLabelTextField!
    @IBOutlet weak var newsLetterSwitch: UISwitch!
    @IBOutlet weak var agreeSwitch: UISwitch!

    @IBOutlet var passwordTextField: HideShowPasswordTextField!
    
    @IBOutlet var confirmPasswordTextField: HideShowPasswordTextField!
    
    
@IBOutlet weak var yourpersonnelDetailsLabel: UILabel!
@IBOutlet weak var yourAddressLabel: UILabel!
@IBOutlet weak var yourpasswordlabel: UILabel!
@IBOutlet weak var newsLaterLabel: UILabel!
@IBOutlet weak var privacypolicyLabel: UILabel!
@IBOutlet weak var headerView: UIView!
@IBOutlet weak var headerTitleLabel: UILabel!
    
    @IBOutlet var becomeSellerView: UIView!
    
    
    @IBOutlet var becomeSellerLabel: UILabel!
    
    @IBOutlet var shopUrlField: UIFloatLabelTextField!
    
    
    
    var firstName:String = ""
    var lastName:String = ""
    var emailId:String=""
    var mobileNo:String = ""
    var password:String = ""
    var conPassword:String = ""
    var taxFieldValue:String = ""
    var mobileno:String = ""
    var groupIdStr:String = ""
    var newsLetterSubscribeStr:String = ""
    var agreeStr:String = ""
    var countryId:String = ""
    var zoneId:String = ""
    var isSeller:Bool = false
    
    
    
    public var movetoSignal:String = "customerLogin"
    @IBOutlet weak var registerButton: UIButton!
    let defaults = UserDefaults.standard;
    var url:String!
    var titleName:String!
    @IBOutlet weak var mainView: UIView!
    var whichApiToProcess:String = ""
    
    
    
 
    
    
    @IBAction func newsLetterSwitchAction(_ sender: UISwitch) {
        let mySwitch = (sender )
        if mySwitch.isOn {
            newsLetterSubscribeStr = "1"
        }else{
            newsLetterSubscribeStr = "0"
        }

    }
    
    
    
    @IBAction func becomeSellerClick(_ sender: UISwitch) {
        if sender.isOn{
            isSeller = true
            shopUrlField.isHidden = false
        }else{
            isSeller = false
            shopUrlField.isHidden = true
        }
        
        
    }
    
    
    @IBAction func agreeSwitchAction(_ sender: UISwitch) {
        let mySwitch = (sender )
        if mySwitch.isOn {
            agreeStr = "1"
        }
    }
    
    
    @IBAction func selectCountryClick(_ sender: UIFloatLabelTextField) {
        let thePicker = UIPickerView()
        thePicker.tag = 1000;
        countryTextField.inputView = thePicker
        thePicker.delegate = self
        
        if createAccountViewModel.getCountryData.count > 0{
            countryTextField.text = createAccountViewModel.getCountryData[0].countryName
            countryId = createAccountViewModel.getCountryData[0].countryId
            stateArray = createAccountViewModel.getCountryData[0].zoneArr! as NSArray
            if stateArray.count>0{
                let dict = stateArray.object(at: 0) as! NSDictionary;
                stateTextField.text = dict.object(forKey: "name") as? String
                zoneId = (dict.object(forKey: "zone_id") as? String)!
            }
        }
        
        
    }
    
    @IBAction func selectStateClick(_ sender: UIFloatLabelTextField) {
        let thePicker = UIPickerView()
        thePicker.tag = 2000;
        stateTextField.inputView = thePicker
        thePicker.delegate = self
        
    }
    
  

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = NetworkManager.sharedInstance.languageBundle.localizedString(forKey: "createaccount", value: "", table: nil);
        
        firstNameTextField.textAlignment = UITextField().isLanguageLayoutDirectionRightToLeft() ? .right : .left;
        lastNameTextField.textAlignment = UITextField().isLanguageLayoutDirectionRightToLeft() ? .right : .left;
        emailTextField.textAlignment = UITextField().isLanguageLayoutDirectionRightToLeft() ? .right : .left;
        passwordTextField.textAlignment = UITextField().isLanguageLayoutDirectionRightToLeft() ? .right : .left;
        mobilrNumberTextField.textAlignment = UITextField().isLanguageLayoutDirectionRightToLeft() ? .right : .left;
        faxTextField.textAlignment = UITextField().isLanguageLayoutDirectionRightToLeft() ? .right : .left;
        companyTextField.textAlignment = UITextField().isLanguageLayoutDirectionRightToLeft() ? .right : .left;
        address1TextField.textAlignment = UITextField().isLanguageLayoutDirectionRightToLeft() ? .right : .left;
        address2TextField.textAlignment = UITextField().isLanguageLayoutDirectionRightToLeft() ? .right : .left;
        cityTextField.textAlignment = UITextField().isLanguageLayoutDirectionRightToLeft() ? .right : .left;
        zipTextField.textAlignment = UITextField().isLanguageLayoutDirectionRightToLeft() ? .right : .left;
        countryTextField.textAlignment = UITextField().isLanguageLayoutDirectionRightToLeft() ? .right : .left;
        stateTextField.textAlignment = UITextField().isLanguageLayoutDirectionRightToLeft() ? .right : .left;
        passwordTextField.textAlignment = UITextField().isLanguageLayoutDirectionRightToLeft() ? .right : .left;
        confirmPasswordTextField.textAlignment = UITextField().isLanguageLayoutDirectionRightToLeft() ? .right : .left;
        mobilrNumberTextField.textAlignment = UITextField().isLanguageLayoutDirectionRightToLeft() ? .right : .left;
        mobilrNumberTextField.textAlignment = UITextField().isLanguageLayoutDirectionRightToLeft() ? .right : .left;
    
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(CreateAccount.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        firstNameTextField.placeholder = NetworkManager.sharedInstance.language(key: "firstname")+" "+ASTERISK
        lastNameTextField.placeholder = NetworkManager.sharedInstance.language(key: "lastname")+" "+ASTERISK
        emailTextField.placeholder = NetworkManager.sharedInstance.language(key: "email")+" "+ASTERISK
        mobilrNumberTextField.placeholder = NetworkManager.sharedInstance.language(key: "mobileno")+" "+ASTERISK
        faxTextField.placeholder = NetworkManager.sharedInstance.language(key: "fax")
        companyTextField.placeholder = NetworkManager.sharedInstance.language(key: "companyname")
        address1TextField.placeholder = NetworkManager.sharedInstance.language(key: "street1")+" "+ASTERISK
        address2TextField.placeholder = NetworkManager.sharedInstance.language(key: "street2")
        cityTextField.placeholder = NetworkManager.sharedInstance.language(key: "city")+" "+ASTERISK
        zipTextField.placeholder = NetworkManager.sharedInstance.language(key: "zip")+" "+ASTERISK
        countryTextField.placeholder = NetworkManager.sharedInstance.language(key: "country")+" "+ASTERISK
        stateTextField.placeholder = NetworkManager.sharedInstance.language(key: "state")+" "+ASTERISK
        passwordTextField.placeholder = NetworkManager.sharedInstance.language(key: "password")+" "+ASTERISK
        confirmPasswordTextField.placeholder = NetworkManager.sharedInstance.language(key:"conpassword")+" "+ASTERISK
        registerButton.setTitle(NetworkManager.sharedInstance.language(key:"register"), for: .normal)
        yourpersonnelDetailsLabel.text = NetworkManager.sharedInstance.language(key:"yourpersoneldetails")
        yourAddressLabel.text = NetworkManager.sharedInstance.language(key:"youraddress")
        yourpasswordlabel.text = NetworkManager.sharedInstance.language(key:"yourpassword")
        newsLaterLabel.text = NetworkManager.sharedInstance.language(key:"newsletter")
        
        let underlineAttribute = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue]
        let underlineAttributedString = NSAttributedString(string: NetworkManager.sharedInstance.language(key:"privacypolicy"), attributes: underlineAttribute)
        privacypolicyLabel.attributedText = underlineAttributedString

        
     
        let tap1: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(CreateAccount.privacyPolicy))
        privacypolicyLabel.addGestureRecognizer(tap1)
        
        registerButton.backgroundColor = UIColor().HexToColor(hexString: BUTTON_COLOR);
        self.navigationController?.isNavigationBarHidden = false
        
      
        firstNameTextField.textColor = UIColor.black
        lastNameTextField.textColor = UIColor.black
        emailTextField.textColor = UIColor.black
        passwordTextField.textColor = UIColor.black
        confirmPasswordTextField.textColor = UIColor.black
        headerView.isHidden = true
        headerView.applyGradientToTopView(colours: GRADIENTCOLOR, locations: nil)
        
        headerTitleLabel.text = NetworkManager.sharedInstance.language(key: "applicationname")
        registerButton.layer.cornerRadius = 5.0
        registerButton.layer.masksToBounds = true
        countryId = ""
        zoneId = ""
        groupIdStr = "1"
        newsLetterSubscribeStr = "0"
        whichApiToProcess = ""
        callingHttppApi();
        
        faxTextField.isHidden = true
        becomeSellerLabel.text = "becomeseller".localized
        shopUrlField.placeholder = "shopurl".localized+" "+ASTERISK
        shopUrlField.isHidden = true
        
        if isMarketPlace{
            self.becomeSellerView.isHidden = false
        }else{
            self.becomeSellerView.isHidden = true
        }
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
        self.tabBarController?.tabBar.isHidden = false
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        headerView.applyGradientToTopView(colours: GRADIENTCOLOR, locations: nil)
        headerView.isHidden = false
    }
    
    
    @objc func privacyPolicy(){
        NetworkManager.sharedInstance.dismissLoader()
        self.performSegue(withIdentifier: "privacypolicy", sender: self)
        
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
                 self.loginRequest()
            }
        }
    }

    
    func callingHttppApi(){
        DispatchQueue.main.async{
            self.view.isUserInteractionEnabled = false
            NetworkManager.sharedInstance.showLoader()
            if self.whichApiToProcess == "addCustomer"{
                let sessionId = self.defaults.object(forKey:"wk_token");
                var requstParams = [String:Any]();
                requstParams["wk_token"] = sessionId;
                requstParams["customer_group_id"] = self.groupIdStr
                requstParams["firstname"] = self.firstNameTextField.text
                requstParams["lastname"] = self.lastNameTextField.text
                requstParams["email"] = self.emailTextField.text
                requstParams["telephone"] = self.mobilrNumberTextField.text
                requstParams["fax"] = self.faxTextField.text
                requstParams["company"] = self.companyTextField.text
                requstParams["address_1"] = self.address1TextField.text
                requstParams["address_2"] = self.address2TextField.text
                requstParams["city"] = self.cityTextField.text
                requstParams["postcode"] = self.zipTextField.text
                requstParams["country_id"] = self.countryId
                requstParams["zone_id"] = self.zoneId
                requstParams["password"] = self.passwordTextField.text
                requstParams["isSubscribe"] = self.newsLetterSubscribeStr
                requstParams["agree"] = self.agreeStr
                if self.isSeller{
                    requstParams["tobecomepartner"]  = "1"
                    requstParams["shoppartner"] =  self.shopUrlField.text!
                    
                }

                
                
                NetworkManager.sharedInstance.callingHttpRequest(params:requstParams, apiname:"customer/addCustomer", cuurentView: self){success,responseObject in
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
                            let resultDict = JSON(responseObject as! NSDictionary)
                            if self.whichApiToProcess == "addCustomer"{
                             
                                if resultDict["error"].intValue == 1{
                                    NetworkManager.sharedInstance.showErrorSnackBar(msg: resultDict["message"].stringValue)
                                }else{
                                    self.defaults.set(resultDict["customer_id"].stringValue, forKey: "customer_id")
                                    self.defaults.set(self.emailTextField.text, forKey: "email")
                                    self.defaults.set(self.firstNameTextField.text, forKey: "firstname")
                                    self.defaults.set("", forKey: "image")
                                    self.defaults.set(self.lastNameTextField.text, forKey: "lastname")
                                    self.defaults.set(self.mobilrNumberTextField.text, forKey: "phone")
                                    self.defaults.set("", forKey: "profileImage")
                                    
                                    if resultDict["partner"].intValue  == 1{
                                        self.defaults.set("true", forKey: "partner")
                                    }else{
                                        self.defaults.set("false", forKey: "partner")
                                    }
                                    
                                    self.defaults.synchronize()
                                    
                                    let AC = UIAlertController(title: NetworkManager.sharedInstance.language(key: "success"), message: resultDict["message"].stringValue, preferredStyle: .alert)
                                    let okBtn = UIAlertAction(title: NetworkManager.sharedInstance.language(key: "ok"), style: .default, handler: {(_ action: UIAlertAction) -> Void in
                                        if self.movetoSignal == "firstlaunch"{
                                            self.dismiss(animated: true, completion: nil)
                                        }else{
                                        self.navigationController?.popToRootViewController(animated: true)
                                        }
                                    })
                                    AC.addAction(okBtn)
                                    self.present(AC, animated: true, completion: nil)
                                }
                            }else{
                              
                            }

                        }
                    }else if success == 2{
                        NetworkManager.sharedInstance.dismissLoader()
                        self.callingHttppApi();
                    }
                }
            }else{
                self.view.isUserInteractionEnabled = false
                let sessionId = self.defaults.object(forKey:"wk_token");
                var requstParams = [String:Any]();
                requstParams["wk_token"] = sessionId;
                
                NetworkManager.sharedInstance.callingHttpRequest(params:requstParams, apiname:"customer/registerAccount", cuurentView: self){success,responseObject in
                    
                    
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

                            self.createAccountViewModel = CreateAccountViewModel(data: JSON(responseObject as! NSDictionary))
                            
                            self.doFurtherProcessingWithResult()
                        }
                        
                    }else if success == 2{
                        NetworkManager.sharedInstance.dismissLoader()
                        self.callingHttppApi();
                    }
                }
            }
        }
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func registerAccount(_ sender: Any) {
        
        firstName = firstNameTextField.text!
        lastName = lastNameTextField.text!
        emailId = emailTextField.text!
        password = passwordTextField.text!
        conPassword = confirmPasswordTextField.text!
        mobileNo = mobilrNumberTextField.text!
        var errorMessage:String = "pleasefill".localized+" "
        
        if !firstNameTextField.isValid(name:"firstname".localized){
            return
        }
        else if !lastNameTextField.isValid(name:"lastname".localized){
            return
        }
        else if !emailTextField.isValid(name:"email".localized){
            return
        }
        else if NetworkManager.sharedInstance.emailTest(emailText: emailTextField.text!){
            NetworkManager.sharedInstance.showErrorSnackBar(msg: "invalidemail".localized)
            return
        }
        else if !mobilrNumberTextField.isValid(name:"mobileno".localized){
            return
        }
        else if !address1TextField.isValid(name:"street1".localized){
            return
        }
        else if !cityTextField.isValid(name:"city".localized){
            return
        }
        else if !zipTextField.isValid(name:"zip".localized){
            return
        }
        else if !countryTextField.isValid(name:"country".localized){
            return
        }
        else if !stateTextField.isValid(name:"state".localized){
            return
        }
        else if passwordTextField.text == ""{
            errorMessage = errorMessage+NetworkManager.sharedInstance.language(key:"password")
            NetworkManager.sharedInstance.showErrorSnackBar(msg: errorMessage)
            return
        }else if (passwordTextField.text?.characters.count)! < 4{
            NetworkManager.sharedInstance.showErrorSnackBar(msg:"passwordmusthave4characters".localized)
            return
        }else if confirmPasswordTextField.text == ""{
            errorMessage = errorMessage+NetworkManager.sharedInstance.language(key:"conpassword")
            NetworkManager.sharedInstance.showErrorSnackBar(msg:errorMessage)
            return

        }else if (passwordTextField.text != confirmPasswordTextField.text){
            errorMessage = NetworkManager.sharedInstance.language(key:"passwordnotmatch")
            NetworkManager.sharedInstance.showErrorSnackBar(msg:errorMessage)
            return

        }else if !(agreeSwitch.isOn){
            errorMessage = NetworkManager.sharedInstance.language(key:"agreeprivacypolicy")
            NetworkManager.sharedInstance.showErrorSnackBar(msg:errorMessage)
            return
        }else if isMarketPlace{
            if isSeller{
                if !shopUrlField.isValid(name:"shopurl".localized){
                    return
                }
            }
        }
        
        
        whichApiToProcess = "addCustomer"
        callingHttppApi()
    }
    
    func doFurtherProcessingWithResult(){
         for i in 0..<createAccountViewModel.getCountryData.count{
            if createAccountViewModel.getCountryData[i].countryId == createAccountViewModel.createAccountModel.defaultCountryCode{
                countryTextField.text = createAccountViewModel.getCountryData[i].countryName
                countryId = createAccountViewModel.getCountryData[i].countryId
                stateArray = createAccountViewModel.getCountryData[i].zoneArr! as NSArray
                if stateArray.count>0{
                    let dict = stateArray.object(at: 0) as! NSDictionary;
                    stateTextField.text = dict.object(forKey: "name") as? String
                    zoneId = (dict.object(forKey: "zone_id") as? String)!
                }
                break
            }
         }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if(pickerView.tag == 1000){
            return self.createAccountViewModel.getCountryData.count;
        }
        if(pickerView.tag == 2000){
            return stateArray.count;
        }
        else{
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 1000{
            return createAccountViewModel.getCountryData[row].countryName
        }else if pickerView.tag == 2000{
            let dict = stateArray.object(at: row) as! NSDictionary;
            return dict.object(forKey: "name") as? String
        }
        else{
            return ""
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        if(pickerView.tag == 1000){
            countryTextField.text = createAccountViewModel.getCountryData[row].countryName
            countryId = createAccountViewModel.getCountryData[row].countryId
            stateArray = createAccountViewModel.getCountryData[row].zoneArr! as NSArray
            if stateArray.count>0{
                let dict = stateArray.object(at: 0) as! NSDictionary;
                stateTextField.text = dict.object(forKey: "name") as? String
                zoneId = (dict.object(forKey: "zone_id") as? String)!
            }
            
        }else if (pickerView.tag == 2000){
            if stateArray.count>0{
                let dict = stateArray.object(at: row) as! NSDictionary;
                stateTextField.text = dict.object(forKey: "name") as? String
                zoneId = (dict.object(forKey: "zone_id") as? String)!
            }
           
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier! == "privacypolicy") {
            let viewController:PrivacyPolicy = segue.destination as UIViewController as! PrivacyPolicy
            viewController.privacyMessage = self.createAccountViewModel.getAgreeDescription            
            
        }
       
        
    }
    
    
}































