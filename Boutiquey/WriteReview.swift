//
//  WriteReview.swift
//  Sa-atar
//
//  Created by Kunal Parsad on 04/10/17.
//  Copyright © 2017 Kunal Parsad. All rights reserved.
//

import UIKit

class WriteReview: UIViewController {
    
    
@IBOutlet weak var nameTextField: UIFloatLabelTextField!
@IBOutlet weak var commentLabel: UILabel!
@IBOutlet weak var commentBox: UITextView!
@IBOutlet weak var ratingsLabel: UILabel!
@IBOutlet weak var submitButton: UIButton!
var ratingValue:CGFloat = 0;
let defaults = UserDefaults.standard;
var productID:String = ""
@IBOutlet weak var reviewheader: UILabel!
@IBOutlet weak var productName: UILabel!
var productNameValue:String = ""
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = NetworkManager.sharedInstance.language(key: "writereview")
        
        
        nameTextField.placeholder = NetworkManager.sharedInstance.language(key: "name")
        commentLabel.text = NetworkManager.sharedInstance.language(key: "comment")
        ratingsLabel.text = NetworkManager.sharedInstance.language(key: "rating")
        submitButton.setTitle(NetworkManager.sharedInstance.language(key: "submit"), for: .normal)
        submitButton.backgroundColor = UIColor().HexToColor(hexString: BUTTON_COLOR)
        productName.text = productNameValue
        reviewheader.text = NetworkManager.sharedInstance.language(key: "reviewing")
        reviewheader.textColor = UIColor().HexToColor(hexString: LIGHTGREY)
        commentLabel.textColor = UIColor().HexToColor(hexString: LIGHTGREY)
        ratingsLabel.textColor = UIColor().HexToColor(hexString: LIGHTGREY)
        nameTextField.applyAlingment()
        submitButton.layer.cornerRadius = 5;
        submitButton.layer.masksToBounds = true
      
    }
    
    @IBAction func dismissKeyBoard(_ sender: Any) {
        view.endEditing(true)
    }
    
    @IBAction func submitClick(_ sender: Any) {
        var errorMessage = NetworkManager.sharedInstance.language(key: "pleasefill")+" ";
        var isValid = 1;
   
        if nameTextField.text == ""{
            isValid = 0
            errorMessage = errorMessage+NetworkManager.sharedInstance.language(key: "name");
        }
        else if commentBox.text == ""{
            isValid = 0
            errorMessage = errorMessage+NetworkManager.sharedInstance.language(key: "comment");
        }else if ratingValue == 0{
            isValid  = 0;
            errorMessage = errorMessage+NetworkManager.sharedInstance.language(key: "rating")
        }
    
        if isValid == 0{
            NetworkManager.sharedInstance.showErrorSnackBar(msg: errorMessage)
        }else{
            callingHttppApi()
        }
        
        
    }
    
    
    @IBAction func ratingsValue(_ sender: HCSStarRatingView) {
        ratingValue = sender.value
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
        requstParams["name"] = nameTextField.text
        requstParams["text"] = commentBox.text
        requstParams["rating"] = ratingValue
        requstParams["product_id"] = productID
        
  
        NetworkManager.sharedInstance.callingHttpRequest(params:requstParams, apiname:"catalog/writeProductReview", cuurentView: self){success,responseObject in
            if success == 1 {
                self.view.isUserInteractionEnabled = true
                NetworkManager.sharedInstance.dismissLoader()
                let dict = JSON(responseObject as! NSDictionary)
                if dict["fault"].intValue == 1{
                        self.loginRequest()
                }else{
                    if dict["error"].intValue == 0{
                    
                    NetworkManager.sharedInstance.showSuccessSnackBar(msg: dict["message"].stringValue)
                    self.navigationController?.popViewController(animated: true)
                    }else{
                         NetworkManager.sharedInstance.showWarningSnackBar(msg:dict["message"].stringValue)
                    }
                    
                }
            }else if success == 2{
                NetworkManager.sharedInstance.dismissLoader()
                self.callingHttppApi()
            }
        }
    }
    
    
    
    
    
    
    
    
    
    
}
