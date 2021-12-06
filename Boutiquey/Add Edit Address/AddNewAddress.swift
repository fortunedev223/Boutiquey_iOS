//
//  AddNewAddress.swift
//  OpenCartApplication
//
//  Created by shobhit on 23/08/17.
//  Copyright © 2017 webkul. All rights reserved.
//

@objc protocol NewAddressAddHandlerDelegate: class {
    func newAddAddreressSuccess(data:Bool)
}

import UIKit
import CoreLocation

class AddNewAddress: UIViewController, CLLocationManagerDelegate, UIPickerViewDelegate,UIPickerViewDataSource {
    
    @IBOutlet weak var saveAddressBtn: UIButton!
    @IBOutlet weak var firstNameTextField: UIFloatLabelTextField!
    @IBOutlet weak var lastNameTextField: UIFloatLabelTextField!
    @IBOutlet weak var companyTextField: UIFloatLabelTextField!
    @IBOutlet weak var address1TextField: UIFloatLabelTextField!
    @IBOutlet weak var address2TextField: UIFloatLabelTextField!
    @IBOutlet weak var cityTextField: UIFloatLabelTextField!
    @IBOutlet weak var zipTextField: UIFloatLabelTextField!
    @IBOutlet weak var countryTextField: UIFloatLabelTextField!
    @IBOutlet weak var stateTextField: UIFloatLabelTextField!
    @IBOutlet weak var defaultAddressSwitch: UISwitch!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var mainViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var defaultAddress: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    var defaultAddressStr:String = ""
    var locationManager:CLLocationManager!
    var addNewAddressViewModel:AddNewAddressViewModel!
    var stateArray:NSArray = []
    var countryId:String = ""
    var zoneId:String = ""
    let defaults = UserDefaults.standard;
    var receivedStrFromAddressBook : String = ""
    var receivedAddressId : String = ""
    var addNewAddress:Bool = true
    var keyBoardFlag:Int = 1;
    var whichApiToProcess:String = "";
    var newAddressDelegate:NewAddressAddHandlerDelegate?
    var currentClass:String = ""
    var defaultCountryIndex:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = false
        
        if addNewAddress{
            self.title = NetworkManager.sharedInstance.language(key: "addnewaddress")
        }else{
            self.title = NetworkManager.sharedInstance.language(key: "editaddress")
        }
        saveAddressBtn.backgroundColor = UIColor().HexToColor(hexString: BUTTON_COLOR);
        defaultAddressStr = ""
        callingHttppApi()
        firstNameTextField.placeholder = NetworkManager.sharedInstance.language(key: "firstname")+" "+ASTERISK
        lastNameTextField.placeholder = NetworkManager.sharedInstance.language(key: "lastname")+" "+ASTERISK
        companyTextField.placeholder = NetworkManager.sharedInstance.language(key: "companyname")
        address1TextField.placeholder = NetworkManager.sharedInstance.language(key: "street1")+" "+ASTERISK
        address2TextField.placeholder = NetworkManager.sharedInstance.language(key: "street2")
        cityTextField.placeholder = NetworkManager.sharedInstance.language(key: "city")+" "+ASTERISK
        zipTextField.placeholder = NetworkManager.sharedInstance.language(key: "zip")+" "+ASTERISK
        countryTextField.placeholder = NetworkManager.sharedInstance.language(key: "country")+" "+ASTERISK
        stateTextField.placeholder = NetworkManager.sharedInstance.language(key: "state")+" "+ASTERISK
        
        defaultAddress.text = NetworkManager.sharedInstance.language(key: "defaultaddress")
        addressLabel.text = NetworkManager.sharedInstance.language(key: "address")
        saveAddressBtn.setTitle(NetworkManager.sharedInstance.language(key: "save"), for: .normal)
        saveAddressBtn.layer.cornerRadius = 5
        saveAddressBtn.layer.masksToBounds = true
        
        
        firstNameTextField.applyAlingment()
        lastNameTextField.applyAlingment()
        companyTextField.applyAlingment()
        address1TextField.applyAlingment()
        address2TextField.applyAlingment()
        cityTextField.applyAlingment()
        zipTextField.applyAlingment()
        countryTextField.applyAlingment()
        stateTextField.applyAlingment()
        locationManager = CLLocationManager()
        locationManager.requestAlwaysAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        // Do any additional setup after loading the view.
    }
    

    
    
    
    @IBAction func gpsClick(_ sender: UIBarButtonItem) {
        var flag = 1;
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined:
                flag = 0
            case .restricted:
                flag = 0
            case .denied:
                flag = 0
            case .authorizedAlways:
                flag = 1
            case .authorizedWhenInUse:
                flag = 1
            }
        }
        
        
        if flag == 1{
       
        if (CLLocationManager.locationServicesEnabled()) {
            locationManager.startUpdatingLocation()
        }
        }else {
            NetworkManager.sharedInstance.dismissLoader()
            
            let AC = UIAlertController(title: NetworkManager.sharedInstance.language(key: "warning"), message: "locationpermission".localized, preferredStyle: .alert)
            let okBtn = UIAlertAction(title: NetworkManager.sharedInstance.language(key: "open"), style: .default, handler: {(_ action: UIAlertAction) -> Void in
                guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                    return
                }
                
                if UIApplication.shared.canOpenURL(settingsUrl) {
                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                            // Checking for setting is opened or not
                            print("Setting is opened: \(success)")
                        })
                    } else {
                        // Fallback on earlier versions
                    }
                }
            })
            let noBtn = UIAlertAction(title: NetworkManager.sharedInstance.language(key: "cancel"), style: .destructive, handler: {(_ action: UIAlertAction) -> Void in
            })
            AC.addAction(okBtn)
            AC.addAction(noBtn)
            self.present(AC, animated: true, completion: { })
        }
    }
    
    @IBAction func defaultAddressSwitchAction(_ sender: UISwitch) {
        let mySwitch = (sender)
        if mySwitch.isOn {
            defaultAddressStr = "1"
        }else{
            defaultAddressStr = "0"
        }
    }
    
    @IBAction func dismissKeyboard(_ sender: Any) {
        view.endEditing(true)
    }
    
    func loginRequest(){
        var loginRequest = [String:String]()
        loginRequest["apiKey"] = API_USER_NAME
        loginRequest["apiPassword"] = API_KEY.md5
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
                self.defaults.synchronize()
                self.callingHttppApi()
            }else if val == 2{
                NetworkManager.sharedInstance.dismissLoader()
                self.loginRequest()
            }
        }
    }
    
    func callingHttppApi(){
        self.view.isUserInteractionEnabled = false
        NetworkManager.sharedInstance.showLoader()
        let sessionId = self.defaults.object(forKey:"wk_token")
        var requstParams = [String:Any]()
        requstParams["wk_token"] = sessionId
        
        if  whichApiToProcess == "saveaddress"{
            
            if !addNewAddress{
                requstParams["address_id"] = receivedAddressId;
            }
            requstParams["customer_id"]  = defaults.object(forKey: "customer_id") as! String
            requstParams["firstname"] = firstNameTextField.text
            requstParams["lastname"] = lastNameTextField.text
            requstParams["company"] = companyTextField.text
            requstParams["address_1"] = address1TextField.text
            requstParams["address_2"] = address2TextField.text
            requstParams["city"] = cityTextField.text
            requstParams["zone_id"] = zoneId
            requstParams["postcode"] = zipTextField.text
            requstParams["country_id"] = countryId
            requstParams["default"] = defaultAddressStr
            NetworkManager.sharedInstance.callingHttpRequest(params:requstParams, apiname:"customer/addAddress", cuurentView: self){success,responseObject in
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
                        if dict.object(forKey: "error") as! Int == 0{
                            let AC = UIAlertController(title: "", message:dict.object(forKey: "message") as? String, preferredStyle: .alert)
                            let okBtn = UIAlertAction(title: "ok".localized, style: .default, handler: {(_ action: UIAlertAction) -> Void in
                                if let delegate = self.newAddressDelegate{
                                   delegate.newAddAddreressSuccess(data:true)
                                }
                                self.navigationController?.popViewController(animated: true)
                            })
                            AC.addAction(okBtn)
                            self.parent!.present(AC, animated: true, completion: nil)
                        }
                    }
                }else if success == 2{
                    NetworkManager.sharedInstance.dismissLoader()
                    self.callingHttppApi()
                }
            }
        }else{
            if !addNewAddress{
                requstParams["address_id"] = receivedAddressId
            }
            
            NetworkManager.sharedInstance.callingHttpRequest(params:requstParams, apiname:"customer/getAddress", cuurentView: self){success,responseObject in
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
                        self.addNewAddressViewModel = AddNewAddressViewModel(data: JSON(responseObject as! NSDictionary))
                        self.doFurtheProcessingWithResult()
                    }
                }else if success == 2{
                    NetworkManager.sharedInstance.dismissLoader()
                    self.callingHttppApi();
                }
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locationArray = locations as NSArray
        let locationObj = locationArray.lastObject as! CLLocation
        //var coordinator = locationObj.coordinate
        let geocoder = CLGeocoder()
        
        geocoder.reverseGeocodeLocation(locationObj, completionHandler: {(placemarks, error)->Void in
            var placemark:CLPlacemark!
            
            if error == nil && (placemarks?.count)! > 0 {
                placemark = placemarks?[0]
                self.cityTextField.text = placemark.locality
                self.address1TextField.text = placemark.subLocality
                self.stateTextField.text = placemark.administrativeArea
                self.zipTextField.text = placemark.postalCode
                self.countryTextField.text = placemark.country
                
                let countryName = placemark.country
                
                for i in 0..<self.addNewAddressViewModel.getCountryData.count{
                    if  countryName ==  self.addNewAddressViewModel.getCountryData[i].countryName{
                        self.countryId = self.addNewAddressViewModel.getCountryData[i].countryId
                        self.stateArray = self.addNewAddressViewModel.getCountryData[i].zoneArr! as NSArray
                        break;
                    }
                }
                
                for i in 0..<self.stateArray.count{
                    let dict = self.stateArray.object(at: i) as! NSDictionary;
                    if  self.stateTextField.text == dict.object(forKey: "name") as? String{
                        self.zoneId = (dict.object(forKey: "zone_id") as? String)!
                        break;
                    }else{
                        self.stateTextField.text = ""
                        self.zoneId = ""
                    }
                }
            }
        })
        
        locationManager.stopUpdatingLocation()
    }
    
    func doFurtheProcessingWithResult(){
        firstNameTextField.text = addNewAddressViewModel.getAddressReceiveModel.firstName
        lastNameTextField.text = addNewAddressViewModel.getAddressReceiveModel.lastName
        companyTextField.text = addNewAddressViewModel.getAddressReceiveModel.company
        address1TextField.text = addNewAddressViewModel.getAddressReceiveModel.address1
        address2TextField.text = addNewAddressViewModel.getAddressReceiveModel.address2
        cityTextField.text = addNewAddressViewModel.getAddressReceiveModel.city
        zipTextField.text = addNewAddressViewModel.getAddressReceiveModel.zip
        countryTextField.text = addNewAddressViewModel.getAddressReceiveModel.country
        stateTextField.text = addNewAddressViewModel.getAddressReceiveModel.zoneVal
        countryId = addNewAddressViewModel.getAddressReceiveModel.country_Id
        zoneId = addNewAddressViewModel.getAddressReceiveModel.zone_Id
        
        if !addNewAddress{
            for i in 0..<addNewAddressViewModel.getCountryData.count{
                let ID = addNewAddressViewModel.getCountryData[i].countryId
                if ID == countryId{
                    stateArray = addNewAddressViewModel.getCountryData[i].zoneArr! as NSArray
                    defaultCountryIndex = i
                    break
                }
            }
        }else{
            if addNewAddressViewModel.getCountryData.count > 0{
                countryId = addNewAddressViewModel.addrerssReceiveModel.defaultCountryCode
                
                for i in 0..<addNewAddressViewModel.getCountryData.count{
                    
                    if addNewAddressViewModel.getCountryData[i].countryId == countryId{
                        defaultCountryIndex = i
                        countryTextField.text = addNewAddressViewModel.getCountryData[i].countryName
                        countryId = addNewAddressViewModel.getCountryData[i].countryId
                        stateArray = addNewAddressViewModel.getCountryData[i].zoneArr! as NSArray
                        if stateArray.count>0{
                            let dict = stateArray.object(at: 0) as! NSDictionary;
                            stateTextField.text = dict.object(forKey: "name") as? String
                            zoneId = (dict.object(forKey: "zone_id") as? String)!
                        }
                    }
                }
            }
        }
        
        let defaultAddressValue = addNewAddressViewModel.getAddressReceiveModel.defaultAddString
        if defaultAddressValue == 1{
            defaultAddressStr = "1";
            defaultAddressSwitch.isOn = true
        }else{
            defaultAddressStr = "0"
            defaultAddressSwitch.isOn = false
        }
    }
    
    @IBAction func saveAddressAction(_ sender: UIButton) {
        
        if !firstNameTextField.isValid(name:"firstname".localized){
            return
        }else if !lastNameTextField.isValid(name:"lastname".localized){
            return
        }else if !address1TextField.isValid(name:"street1".localized){
            return
        }
        else if !cityTextField.isValid(name:"city".localized){
            return
        }else if !zipTextField.isValid(name:"zip".localized){
            return
        }else if !countryTextField.isValid(name:"country".localized){
            return
        }else if !stateTextField.isValid(name:"state".localized){
            return
        }
            
      
            whichApiToProcess = "saveaddress"
            callingHttppApi()
    }
    
    @IBAction func selectCountryClick(_ sender: UIFloatLabelTextField) {
        let thePicker = UIPickerView()
        thePicker.tag = 1000;
        countryTextField.inputView = thePicker
        thePicker.delegate = self
        
        if self.addNewAddressViewModel.getCountryData.count > 0{
           thePicker.selectRow(defaultCountryIndex, inComponent: 0, animated: false)
           self.pickerView(thePicker, didSelectRow: defaultCountryIndex, inComponent: 0)
        }
        
    }
    
    @IBAction func selectStateClick(_ sender: UIFloatLabelTextField) {
        let thePicker = UIPickerView()
        thePicker.tag = 2000;
        stateTextField.inputView = thePicker
        thePicker.delegate = self
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if(pickerView.tag == 1000){
            return self.addNewAddressViewModel.getCountryData.count;
        }
        if(pickerView.tag == 2000){
            return stateArray.count;
        }else{
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 1000{
            return addNewAddressViewModel.getCountryData[row].countryName
        }else if pickerView.tag == 2000{
            let dict = stateArray.object(at: row) as! NSDictionary;
            return dict.object(forKey: "name") as? String
        }else{
            return ""
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        if(pickerView.tag == 1000){
            countryTextField.text = addNewAddressViewModel.getCountryData[row].countryName
            countryId = addNewAddressViewModel.getCountryData[row].countryId
            stateArray = addNewAddressViewModel.getCountryData[row].zoneArr! as NSArray
            defaultCountryIndex = row
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
}

