//
//  AddressBook.swift
//  OpenCartApplication
//
//  Created by shobhit on 23/08/17.
//  Copyright © 2017 webkul. All rights reserved.
//

import UIKit

class AddressBook: UIViewController, UITableViewDelegate, UITableViewDataSource,NewAddressAddHandlerDelegate {
   
    @IBOutlet weak var addressTableView: UITableView!
    @IBOutlet weak var newAddressBtn: UIButton!
    
    let defaults = UserDefaults.standard
    var whichApiToProcess:String = ""
    var addressBookViewModel:AddressBookViewModel!
    var addressIdStr : String = ""
    var addNewAddress : Bool!
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        self.title = NetworkManager.sharedInstance.language(key: "addressbook")
        
        addressTableView.register(UINib(nibName: "AddressViewCell", bundle: nil), forCellReuseIdentifier: "AddressViewCell")
        addressTableView.rowHeight = UITableView.automaticDimension
        self.addressTableView.estimatedRowHeight = 100
        newAddressBtn.backgroundColor = UIColor().HexToColor(hexString: BUTTON_COLOR)
        newAddressBtn.layer.cornerRadius = 5
        newAddressBtn.layer.masksToBounds = true
        addressTableView.separatorColor = UIColor.clear
        addressIdStr = ""
        whichApiToProcess = ""
        newAddressBtn.setTitle(NetworkManager.sharedInstance.language(key: "addnewaddress"), for: .normal)
        callingHttppApi()
    }
    
    override func viewWillAppear(_ animated: Bool) {
       self.navigationController?.isNavigationBarHidden = false
    }
    
    func newAddAddreressSuccess(data:Bool){
        if data{
            addressIdStr = ""
            whichApiToProcess = ""
            callingHttppApi()
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
                self.loginRequest()
            }
        }
    }

    func callingHttppApi(){
            self.view.isUserInteractionEnabled = false
            NetworkManager.sharedInstance.showLoader()
            
                let sessionId = self.defaults.object(forKey:"wk_token");
                var requstParams = [String:Any]();
                requstParams["wk_token"] = sessionId;
        
              if  whichApiToProcess == "deleteaddress"{
                requstParams["address_id"] = addressIdStr
                NetworkManager.sharedInstance.callingHttpRequest(params:requstParams, apiname:"customer/deleteAddress", cuurentView: self){success,responseObject in
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
                            let dict = JSON(responseObject as! NSDictionary)
                            if dict["error"].intValue == 0{
                            let AC = UIAlertController(title: "", message: dict["message"].stringValue, preferredStyle: .alert)
                            let okBtn = UIAlertAction(title: NetworkManager.sharedInstance.language(key: "ok"), style: .default, handler: {(_ action: UIAlertAction) -> Void in
                                self.whichApiToProcess = ""
                                self.callingHttppApi();
                            })
                           
                            AC.addAction(okBtn)
                            self.present(AC, animated: true, completion: nil)
                            }else{
                                NetworkManager.sharedInstance.showWarningSnackBar(msg: dict["message"]["warning"].stringValue)
                            }
                        }
                    }else if success == 2{
                        NetworkManager.sharedInstance.dismissLoader()
                        self.callingHttppApi()
                    }
                }
              }else{
                NetworkManager.sharedInstance.callingHttpRequest(params:requstParams, apiname:"customer/getAddresses", cuurentView: self){success,responseObject in
                    if success == 1 {
                        let dict = responseObject as! NSDictionary;
                        if dict.object(forKey: "fault") != nil{
                            let fault = dict.object(forKey: "fault") as! Bool;
                            
                            if fault == true{
                                self.loginRequest()
                            }
                        }else{
                         
                            self.addressBookViewModel = AddressBookViewModel(data: JSON(responseObject as! NSDictionary))
                            self.doFurtherProcessingWithResult(data: responseObject!)
                        }
                    }else if success == 2{
                        NetworkManager.sharedInstance.dismissLoader()
                        self.callingHttppApi();
                    }
                }
        }
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func doFurtherProcessingWithResult(data:AnyObject){
        DispatchQueue.main.async {
            self.view.isUserInteractionEnabled = true
            NetworkManager.sharedInstance.dismissLoader()
            let resultDict = data as! NSDictionary
                if resultDict.object(forKey: "error") as! NSNumber == 1{
                    NetworkManager.sharedInstance.showWarningSnackBar(msg:resultDict.object(forKey: "message") as! String)
                }else{
                    self.addressTableView.delegate = self
                    self.addressTableView.dataSource = self
                    self.addressTableView.reloadData()
                }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier! == "addressBookToAddNewAddressPage") {
            let viewController:AddNewAddress = segue.destination as UIViewController as! AddNewAddress
            viewController.receivedAddressId = addressIdStr
            viewController.addNewAddress = addNewAddress
            viewController.currentClass = ""
            viewController.newAddressDelegate = self
        }
    }
    
    @IBAction func newAddressAction(_ sender: UIButton) {
        addNewAddress = true
        
        self.performSegue(withIdentifier: "addressBookToAddNewAddressPage", sender: self)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return self.addressBookViewModel.getAddressData.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddressViewCell", for: indexPath) as! AddressViewCell
        cell.addressValue.text = self.addressBookViewModel.getAddressData[indexPath.row].addressValue
        cell.editButton.tag = indexPath.row
        cell.editButton.addTarget(self, action: #selector(editAddressButtonTapped(sender:)), for: .touchUpInside)
        cell.deleteButton.tag = indexPath.row
        cell.deleteButton.addTarget(self, action: #selector(deleteAddressButtonTapped(sender:)), for: .touchUpInside)
        cell.addressLabel.text = NetworkManager.sharedInstance.language(key: "address")+" "+"\(indexPath.row + 1)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // cell selected code here
    }
    
    @objc func editAddressButtonTapped(sender: UIButton){
        addressIdStr = self.addressBookViewModel.getAddressData[sender.tag].addressId
        addNewAddress = false
        self.performSegue(withIdentifier: "addressBookToAddNewAddressPage", sender: self);
    }
    
    @objc func deleteAddressButtonTapped(sender: UIButton){
        addressIdStr = self.addressBookViewModel.getAddressData[sender.tag].addressId
        let AC = UIAlertController(title: NetworkManager.sharedInstance.language(key: "warning"), message: NetworkManager.sharedInstance.language(key: "cartemtyinfo"), preferredStyle: .alert)
        let okBtn = UIAlertAction(title: NetworkManager.sharedInstance.language(key: "ok"), style: .default, handler: {(_ action: UIAlertAction) -> Void in
            self.whichApiToProcess = "deleteaddress";
            self.callingHttppApi()
        })
        let noBtn = UIAlertAction(title: NetworkManager.sharedInstance.language(key: "cancel"), style: .destructive, handler: {(_ action: UIAlertAction) -> Void in
        })
        AC.addAction(okBtn)
        AC.addAction(noBtn)
        self.present(AC, animated: true, completion: nil)
    }
}
