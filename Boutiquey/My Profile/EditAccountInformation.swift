//
//  EditAccountInformation.swift
//  OpenCartApplication
//
//  Created by shobhit on 24/08/17.
//  Copyright © 2017 webkul. All rights reserved.
//

import UIKit





class EditAccountInformation: UIViewController,UITableViewDelegate ,UITableViewDataSource,FormFieldTextValueHandler{
var editAccountInformationViewModel:EditAccountInformationViewModel!
let defaults = UserDefaults.standard;
var whichApiToProcess:String  = ""
@IBOutlet var tableView: UITableView!
var formTypeData = [FormFielderType]()
var accesibleType = [String]()
@IBOutlet var continueButton: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        self.title = NetworkManager.sharedInstance.language(key: "accountinformation")
        whichApiToProcess = ""
        formTypeData = [.normalTextField,.normalTextField,.emailTextField,.phonetextField]
        accesibleType = ["firstname","lastname","email","phone"]
        tableView.register(UINib(nibName: "NormalTextField", bundle: nil), forCellReuseIdentifier: "NormalTextField")
        tableView.register(UINib(nibName: "EmailTextFieldCell", bundle: nil), forCellReuseIdentifier: "EmailTextFieldCell")
        tableView.register(UINib(nibName: "PhoneTextFieldCell", bundle: nil), forCellReuseIdentifier: "PhoneTextFieldCell")
        tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 20
        continueButton.setTitle("continue".localized, for: .normal)
        continueButton.isHidden = true
        continueButton.applyCorner()
        callingHttppApi();
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

        let sessionId = self.defaults.object(forKey:"wk_token");
        var requstParams = [String:Any]();
        requstParams["wk_token"] = sessionId;

        if whichApiToProcess == "editCustomer" {
            requstParams["firstname"] = self.editAccountInformationViewModel.addrerssReceivedModel.firstName
            requstParams["lastname"] = self.editAccountInformationViewModel.addrerssReceivedModel.lastName
            requstParams["email"] = self.editAccountInformationViewModel.addrerssReceivedModel.emailAddress
            requstParams["telephone"] = self.editAccountInformationViewModel.addrerssReceivedModel.telephone
            requstParams["fax"] = ""

            NetworkManager.sharedInstance.callingHttpRequest(params:requstParams, apiname:"customer/editCustomer", cuurentView: self){success,responseObject in

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
                        let resultDict : JSON = JSON(responseObject!)
                        if resultDict["error"].number == 1{
                            let AC = UIAlertController(title: "warning".localized, message: resultDict["message"].stringValue, preferredStyle: .alert)
                            let okBtn = UIAlertAction(title: "ok".localized, style: .default, handler: {(_ action: UIAlertAction) -> Void in

                            })
                            AC.addAction(okBtn)
                            self.present(AC, animated: true, completion:nil)
                        }else{
                            self.defaults.set(self.editAccountInformationViewModel.addrerssReceivedModel.emailAddress, forKey: "email")
                             self.defaults.synchronize()
                            self.navigationController?.popViewController(animated: true)
                            NetworkManager.sharedInstance.showSuccessSnackBar(msg:resultDict["message"].stringValue)
                        }
                    }
                }else if success == 2{
                    NetworkManager.sharedInstance.dismissLoader()
                    self.callingHttppApi()
                }
            }
        }else{
            NetworkManager.sharedInstance.callingHttpRequest(params:requstParams, apiname:"customer/myAccount", cuurentView: self){success,responseObject in

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
                        self.editAccountInformationViewModel = EditAccountInformationViewModel(data: JSON(responseObject as! NSDictionary))
                        self.doFurtheProcessingWithResult()


                    }
                }else if success == 2{
                    NetworkManager.sharedInstance.dismissLoader()
                    self.callingHttppApi()
                }
            }
        }
    }

    
    
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return formTypeData.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let formType = formTypeData[indexPath.row]
        
        switch  formType{
        case .emailTextField:
            let cell:EmailTextFieldCell = tableView.dequeueReusableCell(withIdentifier: "EmailTextFieldCell") as! EmailTextFieldCell
            cell.delegate = self
            if accesibleType[indexPath.row] == "email"{
                cell.usernameTextFieldController.placeholderText = "email".localized
                cell.textFieldNormal.accessibilityLabel = accesibleType[indexPath.row]
                cell.textFieldNormal.text = self.editAccountInformationViewModel.addrerssReceivedModel.emailAddress
            }
            return cell
        case .normalTextField:
            let cell:NormalTextField = tableView.dequeueReusableCell(withIdentifier: "NormalTextField") as! NormalTextField
            cell.delegate = self
            if accesibleType[indexPath.row] == "firstname"{
                cell.usernameTextFieldController.placeholderText = "firstname".localized
                cell.textFieldNormal.accessibilityLabel = accesibleType[indexPath.row]
                cell.textFieldNormal.text = self.editAccountInformationViewModel.addrerssReceivedModel.firstName
            }else if accesibleType[indexPath.row] == "lastname"{
                cell.usernameTextFieldController.placeholderText = "lastname".localized
                cell.textFieldNormal.accessibilityLabel = accesibleType[indexPath.row]
                cell.textFieldNormal.text = self.editAccountInformationViewModel.addrerssReceivedModel.lastName
            }
            return cell
        case .phonetextField:
            let cell:PhoneTextFieldCell = tableView.dequeueReusableCell(withIdentifier: "PhoneTextFieldCell") as! PhoneTextFieldCell
            cell.delegate = self
            if accesibleType[indexPath.row] == "phone"{
                cell.usernameTextFieldController.placeholderText = "telephoneno".localized
                cell.textFieldNormal.accessibilityLabel = accesibleType[indexPath.row]
                cell.textFieldNormal.text = self.editAccountInformationViewModel.addrerssReceivedModel.telephone
            }
            return cell
            
        default:
            return UITableViewCell()
        }
    
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    
    func doFurtheProcessingWithResult(){
         continueButton.isHidden = false
         self.tableView.delegate  = self
         self.tableView.dataSource = self
         self.tableView.reloadData()
    }

    
    @IBAction func continueAction(_ sender: UIButton) {
        whichApiToProcess = "editCustomer"
        
        if !self.editAccountInformationViewModel.addrerssReceivedModel.firstName.isValid(name:"firstname".localized ){
            return
        }
        else if !self.editAccountInformationViewModel.addrerssReceivedModel.lastName.isValid(name:"lastname".localized ){
            return
        }
        else if !self.editAccountInformationViewModel.addrerssReceivedModel.emailAddress.isValid(name:"email".localized ){
            return
        }
        else if NetworkManager.sharedInstance.emailTest(emailText: self.editAccountInformationViewModel.addrerssReceivedModel.emailAddress){
            NetworkManager.sharedInstance.showErrorSnackBar(msg: "invalidemail".localized)
            return
        }
            
        else if !self.editAccountInformationViewModel.addrerssReceivedModel.telephone.isValid(name:"mobileno".localized ){
            return
        }
        
       
        callingHttppApi();

    }
   
    
    
}



extension EditAccountInformation{
    
    
      func getFormFieldValue(val:String,type:String){
        switch  type {
        case "firstname":
            self.editAccountInformationViewModel.addrerssReceivedModel.firstName = val
            break
        case "lastname":
            self.editAccountInformationViewModel.addrerssReceivedModel.lastName = val
            break
        case "email":
            self.editAccountInformationViewModel.addrerssReceivedModel.emailAddress = val
            break
        case "phone":
            self.editAccountInformationViewModel.addrerssReceivedModel.telephone = val
            break
        default:
            break
        }
    }
}
