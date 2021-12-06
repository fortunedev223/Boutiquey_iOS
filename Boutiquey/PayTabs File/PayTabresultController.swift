//
/**
GlobDeals
@Category Webkul
@author Webkul <support@webkul.com>
FileName: PayTabresultController.swift
Copyright (c) 2010-2018 Webkul Software Private Limited (https://webkul.com)
@license   https://store.webkul.com/license.html
*/

import UIKit

class PayTabresultController: UIViewController {

    
    
@IBOutlet var messageLabel: UILabel!
@IBOutlet var continueShoppingButton: UIButton!
var state:String = ""
var order_id:String = ""
let defaults = UserDefaults.standard;
    
    
    
    
    
    override func viewDidLoad() {
    super.viewDidLoad()
        continueShoppingButton.layer.cornerRadius = 5
        continueShoppingButton.layer.masksToBounds = true
        continueShoppingButton.setTitleColor(UIColor.white, for: .normal)
        continueShoppingButton.backgroundColor = UIColor().HexToColor(hexString: BUTTON_COLOR)
        continueShoppingButton.setTitle("continue".localized, for: .normal)
        self.messageLabel.text = ""
        self.callingHttppApi()
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
        requstParams["order_id"] = self.order_id
        requstParams["state"] = state
        
        NetworkManager.sharedInstance.callingHttpRequest(params:requstParams, apiname:"checkout/confirmOrder", cuurentView: self){success,responseObject in
            if success == 1 {
                let dict = JSON(responseObject as! NSDictionary)
                if dict["fault"].intValue == 1{
                        self.loginRequest()
                }else{
                    self.view.isUserInteractionEnabled = true
                    NetworkManager.sharedInstance.dismissLoader()
                    if dict["error"].intValue == 0{
                       self.messageLabel.text = dict["success"]["text_message"].stringValue
                    }else{
                        self.messageLabel.text = dict["message"].stringValue
                    }
                    
                }
            }else if success == 2{
                NetworkManager.sharedInstance.dismissLoader()
                self.callingHttppApi();
            }
        }
        
    }
    
    
    
    
    @IBAction func continueClick(_ sender: UIButton) {
        if state == "0"{
         GlobalVariables.proceedToCheckOut = false
        }else{
         GlobalVariables.proceedToCheckOut = true
        }
        self.dismiss(animated: true, completion: nil)
    }
    
   

}
