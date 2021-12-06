//
//  ChangePassword.swift
//  OpenCartApplication
//
//  Created by shobhit on 24/08/17.
//  Copyright © 2017 webkul. All rights reserved.
//

import UIKit

class ChangePassword: UIViewController,UITableViewDelegate,UITableViewDataSource,FormFieldTextValueHandler {
let defaults = UserDefaults.standard;
@IBOutlet var tableView: UITableView!
var formTypeData = [FormFielderType]()
var accesibleType = [String]()
    
    
@IBOutlet var continueButton: UIButton!
var passwordData:String = ""
var conPasswordData:String = ""
    
    
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }

    override func viewDidLoad() {
        super.viewDidLoad()
  
        self.navigationController?.isNavigationBarHidden = false
        
        self.title = NetworkManager.sharedInstance.language(key: "changepassword")
        formTypeData = [.passwordTextField,.passwordTextField]
        accesibleType = ["password","conpassword"]
        tableView.register(UINib(nibName: "PasswordTextFieldCell", bundle: nil), forCellReuseIdentifier: "PasswordTextFieldCell")
        tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 20
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.reloadData()
        continueButton.setTitle("save".localized, for: .normal)
        continueButton.applyCorner()
        
        
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
        requstParams["password"] = passwordData
        
        NetworkManager.sharedInstance.callingHttpRequest(params:requstParams, apiname:"customer/editPassword", cuurentView: self){success,responseObject in
            if success == 1 {
                
                let dict = responseObject as! NSDictionary;
                if dict.object(forKey: "fault") != nil{
                    let fault = dict.object(forKey: "fault") as! Bool;
                    
                    if fault == true{
                        self.loginRequest()
                    }
                }else{
                    let resultDict : JSON = JSON(responseObject!)
                    if resultDict["error"].number == 1{
                        NetworkManager.sharedInstance.dismissLoader()
                        NetworkManager.sharedInstance.showWarningSnackBar(msg:resultDict["message"].stringValue)
                    }else{
                        NetworkManager.sharedInstance.dismissLoader()
                        self.navigationController?.popViewController(animated: true)
                        NetworkManager.sharedInstance.showSuccessSnackBar(msg:resultDict["message"].stringValue)
                    }

                }
            }else if success == 2{
                NetworkManager.sharedInstance.dismissLoader()
                self.callingHttppApi()
            }
        }
        
    }
    
    @IBAction func continueAction(_ sender: UIButton) {
        var msg : String = ""

        if passwordData == ""{
            msg = NetworkManager.sharedInstance.language(key: "pleasefillpassword");
        }
        else if (passwordData.count) < 4{
            msg = NetworkManager.sharedInstance.languageBundle.localizedString(forKey: "passwordmusthave4characters", value: "", table: nil);
        }
        else if conPasswordData == ""{
            msg = NetworkManager.sharedInstance.language(key: "pleasefillconfirmnewpassword");
        }
        else if (passwordData != conPasswordData){
            msg = NetworkManager.sharedInstance.language(key:  "passwordnotmatch");
        }

        if msg != ""{
            NetworkManager.sharedInstance.showErrorSnackBar(msg:msg)

        }else{
            callingHttppApi();
        }
        
        
    }
    

   
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return formTypeData.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let formType = formTypeData[indexPath.row]
        switch  formType{
        case .passwordTextField:
            let cell:PasswordTextFieldCell = tableView.dequeueReusableCell(withIdentifier: "PasswordTextFieldCell") as! PasswordTextFieldCell
            cell.delegate = self
            if accesibleType[indexPath.row] == "password"{
                cell.usernameTextFieldController.placeholderText = "password".localized
                cell.textFieldNormal.accessibilityLabel = accesibleType[indexPath.row]
            }else if accesibleType[indexPath.row] == "conpassword"{
                cell.usernameTextFieldController.placeholderText = "conpassword".localized
                cell.textFieldNormal.accessibilityLabel = accesibleType[indexPath.row]
            }
            return cell
            
        default:
            return UITableViewCell()
        }
    
    }
    
    
    
        func getFormFieldValue(val:String,type:String){
            switch  type {
            case "password":
                passwordData = val
                break
            case "conpassword":
                conPasswordData = val
                break
            default:
                break
            }
    }
    
    
    
    
    
    
    
    
    
}
