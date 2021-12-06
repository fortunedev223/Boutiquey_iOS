//
//  ProductReturnController.swift
//  Boutiquey
//
//  Created by kunal on 08/06/18.
//  Copyright © 2018 yogesh. All rights reserved.
//

import UIKit

class ProductReturnController: UIViewController,UITableViewDelegate, UITableViewDataSource {
    
let defaults = UserDefaults.standard;
var orderId:String = ""
var productId:String = ""
var resonID:String = ""
    
@IBOutlet var tableView: UITableView!
var productReturnViewModel:ProductReturnViewModel!
@IBOutlet var returnButton: UIButton!
var whichApiToProcess:String = ""
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        self.title = NetworkManager.sharedInstance.language(key: "productreturn")
        tableView.register(UINib(nibName: "CustomerInfoCell", bundle: nil), forCellReuseIdentifier: "CustomerInfoCell")
        tableView.register(UINib(nibName: "ProductInfoCell", bundle: nil), forCellReuseIdentifier: "ProductInfoCell")
        tableView.register(UINib(nibName: "PaymentTableViewCell", bundle: nil), forCellReuseIdentifier: "PaymentTableViewCell")
        
        
        tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 50
        tableView.separatorColor = UIColor.clear
        
        
        returnButton.setTitleColor(UIColor.white, for: .normal)
        returnButton.setTitle(NetworkManager.sharedInstance.language(key: "return"), for: .normal)
        returnButton.layer.cornerRadius = 5;
        returnButton.layer.masksToBounds = true
        returnButton.backgroundColor = UIColor().HexToColor(hexString: BUTTON_COLOR)
        
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
        
        let sessionId = self.defaults.object(forKey:"wk_token");
        var requstParams = [String:Any]();
        requstParams["wk_token"] = sessionId;
        requstParams["order_id"] = self.orderId;
        requstParams["product_id"] = self.productId;
        
        if whichApiToProcess == "return"{
          requstParams["firstname"] = self.productReturnViewModel.productReturnModel.firstname
          requstParams["lastname"] = self.productReturnViewModel.productReturnModel.lastname
          requstParams["email"] = self.productReturnViewModel.productReturnModel.email
          requstParams["telephone"] = self.productReturnViewModel.productReturnModel.telephone
          requstParams["order_id"] = self.productReturnViewModel.productReturnModel.order_id
          requstParams["date_ordered"] = self.productReturnViewModel.productReturnModel.date_ordered
          requstParams["product"] = self.productReturnViewModel.productReturnModel.product
            requstParams["model"] = self.productReturnViewModel.productReturnModel.model
            requstParams["quantity"] = self.productReturnViewModel.productReturnModel.qty
            requstParams["return_reason_id"] = self.resonID
            if self.productReturnViewModel.productReturnModel.isOpened{
              requstParams["opened"] = "1"
            }else{
              requstParams["opened"] = "0"
            }
            requstParams["comment"] = self.productReturnViewModel.productReturnModel.faultMessage
            NetworkManager.sharedInstance.callingHttpRequest(params:requstParams, apiname:"customer/addReturn", cuurentView: self){success,responseObject in
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
                            NetworkManager.sharedInstance.showWarningSnackBar(msg:resultDict["message"].stringValue)
                        }else{
                            NetworkManager.sharedInstance.showSuccessSnackBar(msg:resultDict["message"].stringValue)
                            self.navigationController?.popViewController(animated: true)
                        }
                        
                    }
                }else if success == 2{
                    NetworkManager.sharedInstance.dismissLoader()
                    self.callingHttppApi();
                }
            }
            
            
        }else{
        NetworkManager.sharedInstance.callingHttpRequest(params:requstParams, apiname:"customer/addReturnData", cuurentView: self){success,responseObject in
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
                        NetworkManager.sharedInstance.showWarningSnackBar(msg:resultDict["message"].stringValue)
                    }else{
                       self.productReturnViewModel = ProductReturnViewModel(data:resultDict)
                       self.tableView.delegate = self
                       self.tableView.dataSource = self
                       self.tableView.reloadData()
                        
                    }
                    
                }
            }else if success == 2{
                NetworkManager.sharedInstance.dismissLoader()
                self.callingHttppApi();
            }
        }
        }
        
    }
    
    
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if section == 2{
          return  self.productReturnViewModel.return_reasons.count
        }else{
           return 1
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0{
          return NetworkManager.sharedInstance.language(key: "customerinfo")
        }else if section == 1{
          return NetworkManager.sharedInstance.language(key: "productinfo")
        }else{
          return NetworkManager.sharedInstance.language(key: "reasonforreturn")
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
          let cell = tableView.dequeueReusableCell(withIdentifier: "CustomerInfoCell", for: indexPath) as! CustomerInfoCell
          cell.firstNameField.text = self.productReturnViewModel.productReturnModel.firstname
            cell.lastNameField.text = self.productReturnViewModel.productReturnModel.lastname
            cell.emailField.text = self.productReturnViewModel.productReturnModel.email
            cell.telephoneField.text = self.productReturnViewModel.productReturnModel.telephone
            cell.orderIdField.text = self.productReturnViewModel.productReturnModel.order_id
            cell.dateField.text = self.productReturnViewModel.productReturnModel.date_ordered
           cell.productReturnViewModel = self.productReturnViewModel
          return cell
        }else if indexPath.section == 1{
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProductInfoCell", for: indexPath) as! ProductInfoCell
            cell.productReturnViewModel = self.productReturnViewModel
            cell.productNameField.text = self.productReturnViewModel.productReturnModel.product
            cell.productCodeField.text = self.productReturnViewModel.productReturnModel.model
            cell.quantityField.text = self.productReturnViewModel.productReturnModel.qty
            cell.faultField.text = self.productReturnViewModel.productReturnModel.faultMessage
            cell.switchButton.isOn = self.productReturnViewModel.productReturnModel.isOpened
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "PaymentTableViewCell", for: indexPath) as! PaymentTableViewCell
            cell.methodDescription.text = self.productReturnViewModel.return_reasons[indexPath.row].name
            if self.productReturnViewModel.return_reasons[indexPath.row].isCheck{
                cell.roundImageView.backgroundColor = UIColor().HexToColor(hexString: BUTTON_COLOR)
            }else{
                cell.roundImageView.backgroundColor = UIColor.clear
            }
            
            return cell

        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 2{
            for i in 0..<self.productReturnViewModel.return_reasons.count{
                self.productReturnViewModel.return_reasons[i].isCheck = false
            }
            self.productReturnViewModel.return_reasons[indexPath.row].isCheck = true
            self.tableView.reloadData()
            
        }
    }
    
    
    
    
    
    @IBAction func returnClick(_ sender: UIButton) {
        var isValid:Int = 1;
        var errorMessage = NetworkManager.sharedInstance.language(key: "pleasefill")+" "
        var returnReasonCheck:Bool = false;
        
        for data in self.productReturnViewModel.return_reasons{
            if data.isCheck{
                returnReasonCheck = true
                resonID = data.return_reason_id
                break;
            }
        }
        
        
        
        if self.productReturnViewModel.productReturnModel.firstname == ""{
            isValid  = 0
            errorMessage+=NetworkManager.sharedInstance.language(key: "firstname")
        }else if self.productReturnViewModel.productReturnModel.lastname == ""{
            isValid  = 0
            errorMessage+=NetworkManager.sharedInstance.language(key: "lastname")
        }
        else if self.productReturnViewModel.productReturnModel.email == ""{
            isValid  = 0
            errorMessage+=NetworkManager.sharedInstance.language(key: "email")
        }else if self.productReturnViewModel.productReturnModel.telephone == ""{
            isValid  = 0
            errorMessage+=NetworkManager.sharedInstance.language(key: "telephoneno")
        }else if self.productReturnViewModel.productReturnModel.order_id == ""{
            isValid  = 0
            errorMessage+=NetworkManager.sharedInstance.language(key: "orderid")
        }else if self.productReturnViewModel.productReturnModel.date_ordered == ""{
            isValid  = 0
            errorMessage+=NetworkManager.sharedInstance.language(key: "date")
        }else if self.productReturnViewModel.productReturnModel.product == ""{
            isValid  = 0
            errorMessage+=NetworkManager.sharedInstance.language(key: "productname")
        }else if self.productReturnViewModel.productReturnModel.model == ""{
            isValid  = 0
            errorMessage+=NetworkManager.sharedInstance.language(key: "productcode")
        }else if self.productReturnViewModel.productReturnModel.qty == ""{
            isValid  = 0
            errorMessage+=NetworkManager.sharedInstance.language(key: "qty")
        }else if !returnReasonCheck{
            isValid  = 0
            errorMessage = NetworkManager.sharedInstance.language(key: "selectreason")
        }
        
        if isValid == 0{
            NetworkManager.sharedInstance.showWarningSnackBar(msg: errorMessage)
        }else{
            whichApiToProcess = "return"
            self.callingHttppApi()
            
        }
        
        
        
        
        
        
        
        
        
    }
    
    
    
    
    
    
    
    

}
