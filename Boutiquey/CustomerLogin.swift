//
//  CustomerLogin.swift
//  OpenCartMpV3
//
//  Created by kunal on 13/12/17.
//  Copyright © 2017 kunal. All rights reserved.
//

import UIKit
import TransitionButton
import MaterialComponents

class CustomerLogin: UIViewController   {
    
    @IBOutlet var ParentView: UIView!
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var emailAddressandpasswordLabel: UILabel!
    
    @IBOutlet var emailTextField: MDCTextField!
    @IBOutlet var passwordTextField: MDCTextField!
    
    @IBOutlet var loginButton: TransitionButton!
    @IBOutlet weak var forgotpasswordButton: UIButton!
    @IBOutlet weak var signupbutton: UIButton!
    
    var whichApiToProcess:String = ""
    public var moveToSignal:String = ""
    var userEmail:String = ""
    let defaults = UserDefaults.standard
    var touchID:TouchID!
    var NotAgainCallTouchId :Bool = false
    
    var emailTextFieldController: MDCTextInputControllerOutlined!
    var passwordTextFieldController: MDCTextInputControllerOutlined!
    
    @IBOutlet var crossButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        headerLabel.text = NetworkManager.sharedInstance.language(key: "applicationname")
        emailAddressandpasswordLabel.text = NetworkManager.sharedInstance.language(key: "signinwithemail")
        
        loginButton.setTitle(NetworkManager.sharedInstance.language(key: "login"), for: .normal)
        loginButton.setTitleColor(UIColor.white, for: .normal)
        forgotpasswordButton.setTitle(NetworkManager.sharedInstance.language(key:"forgotpassword"), for: .normal)
        signupbutton.setTitle(NetworkManager.sharedInstance.language(key:"iwanttosignup"), for: .normal)
        
        loginButton.spinnerColor = UIColor.white
        touchID = TouchID(view:self)
        
        
        emailTextField.textAlignment = UITextField().isLanguageLayoutDirectionRightToLeft() ? .right : .left;
        passwordTextField.textAlignment = UITextField().isLanguageLayoutDirectionRightToLeft() ? .right : .left;
        emailTextField.textColor = UIColor.black
        passwordTextField.textColor = UIColor.black
        
        emailTextFieldController = MDCTextInputControllerOutlined(textInput: emailTextField)
        passwordTextFieldController = MDCTextInputControllerOutlined(textInput: passwordTextField)
        emailTextFieldController.floatingPlaceholderActiveColor = UIColor().HexToColor(hexString: BUTTON_COLOR)
        emailTextFieldController.activeColor = UIColor().HexToColor(hexString: BUTTON_COLOR)
        passwordTextFieldController.floatingPlaceholderActiveColor = UIColor.black
        passwordTextFieldController.activeColor = UIColor().HexToColor(hexString: BUTTON_COLOR)
        emailTextFieldController.placeholderText = "email".localized
        passwordTextFieldController.placeholderText = "password".localized
        emailAddressandpasswordLabel.applyDarkGrey()
        crossButton.applyRoundCorner()
        forgotpasswordButton.setTitleColor(UIColor().HexToColor(hexString: DARKGREY), for: .normal)
        loginButton.backgroundColor = UIColor().HexToColor(hexString: BUTTON_COLOR)
        
        
        signupbutton.layer.borderColor = UIColor().HexToColor(hexString: BUTTON_COLOR).cgColor
        signupbutton.layer.borderWidth = 1.0
        signupbutton.backgroundColor = UIColor.white
        signupbutton.setTitleColor(UIColor().HexToColor(hexString: BUTTON_COLOR), for: .normal)
        
        headerLabel.textColor = UIColor().HexToColor(hexString: BUTTON_COLOR)
        crossButton.backgroundColor = UIColor().HexToColor(hexString: BUTTON_COLOR)
        loginButton.layer.cornerRadius = 5;
        loginButton.layer.masksToBounds = true
        signupbutton.layer.cornerRadius = 5;
        signupbutton.layer.masksToBounds = true
    
        passwordTextField.clearButtonMode = .never
        
    
        let button = UIButton(type: .custom)
        button.setImage( UIImage(named: "ic_eye_closed"), for: .normal)
        button.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(50), height: CGFloat(50))
        passwordTextField.rightView = button
        passwordTextField.rightViewMode = .always
        button.addTarget(self, action: #selector(hideunHidePassword(sender:)), for: .touchUpInside)
        
    }
    
    @objc func hideunHidePassword(sender: UIButton){
        if passwordTextField.isSecureTextEntry{
            passwordTextField.isSecureTextEntry = false
            sender.setImage(UIImage(named: "ic_eye_open")!, for: .normal)
        }else{
            passwordTextField.isSecureTextEntry = true
            sender.setImage(UIImage(named: "ic_eye_closed")!, for: .normal)
        }
    
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
        self.tabBarController?.tabBar.isHidden = false
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        if defaults.object(forKey: "touchIdFlag") as! String == "1"{
            let  AC = UIAlertController(title: NetworkManager.sharedInstance.language(key: "alert"), message: NetworkManager.sharedInstance.language(key: "loginbytouchid"), preferredStyle: .alert)
            let okBtn = UIAlertAction(title: NetworkManager.sharedInstance.language(key: "yes"), style:.default, handler: {(_ action: UIAlertAction) -> Void in
                self.touchID.checkUserAuthentication(taskCallback: { (sucess) in
                    if sucess{
                        self.emailTextField.text = self.defaults.object(forKey: "TouchEmailId") as? String
                        self.passwordTextField.text = self.defaults.object(forKey: "TouchPasswordValue") as? String
                        self.NotAgainCallTouchId = true
                        self.loginButton.startAnimation()
                        self.whichApiToProcess = ""
                        self.callingHttppApi()
                    }
                })
            })
            let cancelBtn = UIAlertAction(title: NetworkManager.sharedInstance.language(key: "no"), style:.destructive, handler: {(_ action: UIAlertAction) -> Void in
                
            })
            AC.addAction(okBtn)
            AC.addAction(cancelBtn)
            self.parent!.present(AC, animated: true, completion: {  })
        }
    }
    
    
    func loginRequest(){
        var loginRequest = [String:String]();
        loginRequest["apiKey"] = API_USER_NAME;
        loginRequest["apiPassword"] = API_KEY.md5;
        NetworkManager.sharedInstance.callingHttpRequest(params:loginRequest, apiname:"common/apiLogin", cuurentView: self){val,responseObject in
            if val == 1{
                let dict = responseObject as! NSDictionary
                sharedPrefrence.set(dict.object(forKey: "wk_token") as! String, forKey: "wk_token")
                sharedPrefrence.set(dict.object(forKey: "language") as! String, forKey: "language")
                sharedPrefrence.set(dict.object(forKey: "currency") as! String, forKey: "currency")
                sharedPrefrence.synchronize();
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
            let sessionId = sharedPrefrence.object(forKey:"wk_token");
            var requstParams = [String:Any]();
            requstParams["wk_token"] = sessionId;
            if self.whichApiToProcess == "forgotpassword"{
                NetworkManager.sharedInstance.showLoader()
                requstParams["email"] = self.userEmail;
                NetworkManager.sharedInstance.callingHttpRequest(params:requstParams, apiname:"customer/forgotPassword", cuurentView: self){success,responseObject in
                    if success == 1 {
                        self.view.isUserInteractionEnabled = true
                        NetworkManager.sharedInstance.dismissLoader()
                        let dict = JSON(responseObject as! NSDictionary)
                  
                        
                        if dict["fault"].intValue == 1{
                            self.loginRequest()
                        }else{
                            if dict["error"].intValue == 0{
                                NetworkManager.sharedInstance.showSuccessSnackBar(msg: dict["message"].stringValue)
                            }else{
                                NetworkManager.sharedInstance.showInfoSnackBar(msg: dict["message"].stringValue)
                            }
                        }
                        
                    }else if success == 2{
                        NetworkManager.sharedInstance.dismissLoader()
                        self.callingHttppApi()
                    }
                }
            }
            else{
                requstParams["username"] = self.emailTextField.text
                requstParams["password"] = self.passwordTextField.text
                NetworkManager.sharedInstance.callingHttpRequest(params:requstParams, apiname:"customer/customerLogin", cuurentView: self){success,responseObject in
                    if success == 1 {
                        NetworkManager.sharedInstance.dismissLoader()
                        let dict = responseObject as! NSDictionary;
                        if dict.object(forKey: "fault") != nil{
                            let fault = dict.object(forKey: "fault") as! Bool;
                            if fault == true{
                                self.loginRequest()
                            }
                        }else{
                          
                            self.doFurtherProcessingWithResult(data:responseObject!)
                        }
                        
                    }else if success == 2{
                        NetworkManager.sharedInstance.dismissLoader()
                        self.callingHttppApi();
                    }
                }
            }
        }
    }
    
    func doFurtherProcessingWithResult(data:AnyObject){
        self.view.isUserInteractionEnabled = true
        let resultDict = data as! NSDictionary
        let resultJson : JSON = JSON(resultDict)
        if resultJson["error"].number == 1{
            let AC = UIAlertController(title: NetworkManager.sharedInstance.language(key: "warning"), message: resultJson["message"].stringValue, preferredStyle: .alert)
            let okBtn = UIAlertAction(title: NetworkManager.sharedInstance.language(key: "ok"), style: .default, handler: {(_ action: UIAlertAction) -> Void in
                self.loginButton.stopAnimation(animationStyle: .shake, completion:nil)
            })
            AC.addAction(okBtn)
            self.present(AC, animated: true, completion: nil)
        }else{
            NetworkManager.sharedInstance.dismissLoader()
            defaults.set(resultJson["customer_id"].stringValue, forKey: "customer_id")
            defaults.set(resultJson["email"].stringValue, forKey: "email")
            defaults.set(resultJson["firstname"].stringValue, forKey: "firstname")
            defaults.set(resultJson["image"].stringValue, forKey: "image")
            defaults.set(resultJson["lastname"].stringValue, forKey: "lastname")
            defaults.set(resultJson["phone"].stringValue, forKey: "phone")
            defaults.set(resultJson["wallet_balance"].stringValue, forKey: "wallet_balance")
            defaults.set(resultJson["image"].stringValue, forKey: "profileImage")
            defaults.synchronize()
            let welcomMsg = NetworkManager.sharedInstance.language(key: "welcome")+"  "+(resultJson["firstname"].stringValue)+" "+(resultJson["lastname"].stringValue)
            NetworkManager.sharedInstance.showSuccessSnackBar(msg:welcomMsg)
            
            if resultJson["partner"].intValue  == 1{
                    defaults.set("true", forKey: "partner")
                }else{
                    defaults.set("false", forKey: "partner")
            }
            
            if resultJson["cart_total"].intValue > 0{
                //self.tabBarController!.tabBar.items?[2].badgeValue = resultJson["cart_total"].stringValue
            }
            
            if defaults.object(forKey: "touchIdFlag") != nil && self.NotAgainCallTouchId == false{
                if defaults.object(forKey: "touchIdFlag") as! String == "0"{
                    let  AC = UIAlertController(title: NetworkManager.sharedInstance.language(key: "alert"), message: NetworkManager.sharedInstance.language(key: "wouldyouliketoconnectappwithtouchid"), preferredStyle: .alert)
                    let okBtn = UIAlertAction(title: NetworkManager.sharedInstance.language(key: "yes"), style:.default, handler: {(_ action: UIAlertAction) -> Void in
                        self.touchID.checkUserAuthentication(taskCallback: { (sucess) in
                            if sucess{
                                self.defaults.set("1", forKey: "touchIdFlag");
                                self.defaults.set(self.emailTextField.text!, forKey: "TouchEmailId")
                                self.defaults.set(self.passwordTextField.text!, forKey: "TouchPasswordValue")
                                self.defaults.synchronize()
                                self.loginButton.stopAnimation(animationStyle: .expand, completion: {
                                    self.navigationController?.popViewController(animated: true)
                                })
                                
                            }else{
                                self.defaults.set("0", forKey: "touchIdFlag");
                                self.loginButton.stopAnimation(animationStyle: .expand, completion: {
                                    self.navigationController?.popViewController(animated: true)
                                })
                            }
                        })
                        
                        
                    })
                    let cancelBtn = UIAlertAction(title: NetworkManager.sharedInstance.language(key: "no"), style: .destructive, handler: {(_ action: UIAlertAction) -> Void in
                        self.defaults.set("0", forKey: "touchIdFlag")
                        self.defaults.synchronize()
                        self.loginButton.stopAnimation(animationStyle: .expand, completion: {
                            self.navigationController?.popViewController(animated: true)
                        })
                    })
                    AC.addAction(okBtn)
                    AC.addAction(cancelBtn)
                    self.parent!.present(AC, animated: true, completion: {  })
                    
                }else if defaults.object(forKey: "touchIdFlag") as! String == "1" {
                    let  AC = UIAlertController(title: NetworkManager.sharedInstance.language(key: "alert"), message: NetworkManager.sharedInstance.language(key: "wouldyouliketoreset"), preferredStyle: .alert)
                    let okBtn = UIAlertAction(title: NetworkManager.sharedInstance.language(key: "yes"), style:.default, handler: {(_ action: UIAlertAction) -> Void in
                        self.touchID.checkUserAuthentication(taskCallback: { (sucess) in
                            if sucess{
                                self.defaults.set("1", forKey: "touchIdFlag");
                                self.defaults.set(self.emailTextField.text!, forKey: "TouchEmailId")
                                self.defaults.set(self.passwordTextField.text!, forKey: "TouchPasswordValue")
                                self.defaults.synchronize()
                                self.loginButton.stopAnimation(animationStyle: .expand, completion: {
                                    self.navigationController?.popViewController(animated: true)
                                })
                            }else{
                                self.defaults.set("0", forKey: "touchIdFlag");
                                self.loginButton.stopAnimation(animationStyle: .expand, completion: {
                                    self.navigationController?.popViewController(animated: true)
                                })
                            }
                        })
                    })
                    let cancelBtn = UIAlertAction(title: NetworkManager.sharedInstance.language(key: "no"), style: .destructive, handler: {(_ action: UIAlertAction) -> Void in
                        self.defaults.set("1", forKey: "touchIdFlag");
                        self.defaults.synchronize()
                        self.loginButton.stopAnimation(animationStyle: .expand, completion: {
                            self.navigationController?.popViewController(animated: true)
                        })
                    })
                    AC.addAction(okBtn)
                    AC.addAction(cancelBtn)
                    self.parent!.present(AC, animated: true, completion: {  })
                }
                else{
                    
                    self.loginButton.stopAnimation(animationStyle: .expand, completion: {
                        self.navigationController?.popViewController(animated: true)
                    })
                }
            }else{
                self.loginButton.stopAnimation(animationStyle: .expand, completion: {
                    self.navigationController?.popViewController(animated: true)
                })
            }
            }
            
        
        
        
    }
    
    
    
    
    
    
    
    @IBAction func dismissController(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
    @IBAction func loginClick(_ sender: TransitionButton) {
        var errorMessage :String = NetworkManager.sharedInstance.language(key: "pleasefill")+" ";
        var isValid:Int = 0;
        if emailTextField.text == ""{
            isValid = 1;
            errorMessage = errorMessage+NetworkManager.sharedInstance.language(key:"email");
        }
        else if NetworkManager.sharedInstance.emailTest(emailText: emailTextField.text!){
            isValid = 1;
            errorMessage = NetworkManager.sharedInstance.language(key:"invalidemail");
        }
        else if passwordTextField.text == ""{
            isValid = 1;
            errorMessage = errorMessage+NetworkManager.sharedInstance.language(key:"password")
        }
        else if (passwordTextField.text?.count)! < 4{
            isValid = 1;
            errorMessage = NetworkManager.sharedInstance.language(key:"passwordmusthave4characters")
        }
        
        if isValid == 1{
            NetworkManager.sharedInstance.showErrorSnackBar(msg: errorMessage)
        }else{
            sender.startAnimation()
            whichApiToProcess = ""
            callingHttppApi()
        }
        
    }
    
    
    @IBAction func forgotPasswordClick(_ sender: Any) {
        let AC = UIAlertController(title:NetworkManager.sharedInstance.language(key:"enteremail"), message: "", preferredStyle: .alert)
        AC.addTextField { (textField) in
            textField.placeholder = NetworkManager.sharedInstance.language(key:"email");
            textField.applyTextFieldAlingment()
        }
        let okBtn = UIAlertAction(title: NetworkManager.sharedInstance.language(key:"ok"), style: .default, handler: {(_ action: UIAlertAction) -> Void in
            let textField = AC.textFields![0]
            if((textField.text?.count)! < 2){
                NetworkManager.sharedInstance.showErrorSnackBar(msg: NetworkManager.sharedInstance.language(key:"invalidemail"))
            }
            else{
                if NetworkManager.sharedInstance.emailTest(emailText: textField.text!){
                    NetworkManager.sharedInstance.showWarningSnackBar(msg: NetworkManager.sharedInstance.language(key:"invalidemail"));
                }else{
                self.userEmail = textField.text!;
                self.whichApiToProcess = "forgotpassword"
                self.callingHttppApi();
                }
            }
        })
        let noBtn = UIAlertAction(title: NetworkManager.sharedInstance.language(key: "cancel"), style:.destructive, handler: {(_ action: UIAlertAction) -> Void in
        })
        AC.addAction(okBtn)
        AC.addAction(noBtn)
        self.parent!.present(AC, animated: true, completion: nil)
    }
    
    
    @IBAction func signupClick(_ sender: Any) {
        self.performSegue(withIdentifier: "createaccount", sender: self)
    }
    
    
    
    @IBAction func faceBookclick(_ sender: UIButton) {
        //        let loginView : FBSDKLoginManager = FBSDKLoginManager()
        //        loginView.loginBehavior = FBSDKLoginBehavior.web
        //
        //        loginView.logIn(withReadPermissions:["public_profile","user_friends","email"], from: self) {
        //            loginResult,error in
        //            if(error != nil){
        //                print("success")
        //            }
        //            else{
        //                self.loginManagerDidComplete()
        //            }
        //        }
    }
    
    
    
    func loginManagerDidComplete()   {
        
        //        if((FBSDKAccessToken.current()) != nil){
        //            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email"]).start(completionHandler: { (connection, result, error) -> Void in
        //                if (error == nil){
        //                    NetworkManager.sharedInstance.showLoader()
        //                    let dict = result as! [String : AnyObject]
        //                    //        print(dict)
        //                    var dict2 =  [String : Any]()
        //                    let sessionId = sharedPrefrence.object(forKey:"wk_token");
        //                    dict2["wk_token"] = sessionId;
        //                    dict2["firstname"] = dict["first_name"]
        //                    dict2["lastname"] = dict["last_name"]
        //                    dict2["email"] = dict["email"]
        //                    dict2["personId"] = dict["id"]
        //
        //                    print("Facebook Details: ", dict2)
        //                    //                   call api
        //                    self.SocialLoginAPICall(dict: dict2)
        //
        //                }
        //            })
        //        }
        
    }
    
    
    
    
    //    @IBAction func googleClick(_ sender: UIButton) {
    //        GIDSignIn.sharedInstance().delegate = self
    //        GIDSignIn.sharedInstance().signOut()
    //        GIDSignIn.sharedInstance().signIn()
    //
    //    }
    
    //    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
    //        if error == nil {
    //            var dict2 =  [String : Any]()
    //            let sessionId = sharedPrefrence.object(forKey:"wk_token");
    //            dict2["wk_token"] = sessionId;
    //            dict2["firstname"] = user.profile.givenName
    //            dict2["lastname"] = user.profile.familyName
    //            dict2["email"] = user.profile.email
    //            dict2["personId"] = user.userID!
    //
    //            self.SocialLoginAPICall(dict: dict2)
    //
    //        } else {
    //            print("\(error.localizedDescription)")
    //        }
    //    }
    //
    
    func SocialLoginAPICall(dict: [String : Any]){
        NetworkManager.sharedInstance.showLoader()
        self.view.isUserInteractionEnabled = false
        NetworkManager.sharedInstance.callingHttpRequest(params:dict, apiname:"customer/addSocialCustomer", cuurentView: self){success,responseObject in
            
            if success == 1{
                NetworkManager.sharedInstance.dismissLoader()
                self.view.isUserInteractionEnabled = true
                let resultDict = responseObject as! NSDictionary
                self.defaults.set(resultDict.object(forKey: "customer_id") ?? "", forKey: "customer_id")
                self.defaults.set(resultDict.object(forKey: "email") ?? "", forKey: "email")
                self.defaults.set(resultDict.object(forKey: "firstname") ?? "", forKey: "firstname")
                self.defaults.set(resultDict.object(forKey: "image") ?? "", forKey: "image")
                self.defaults.set(resultDict.object(forKey: "lastname") ?? "", forKey: "lastname")
                self.defaults.set(resultDict.object(forKey: "phone") ?? "", forKey: "phone")
                self.defaults.set(resultDict.object(forKey: "wallet_balance") ?? "", forKey: "wallet_balance")
                self.defaults.set(resultDict.object(forKey: "image") ?? "", forKey: "profileImage")
                self.defaults.synchronize()
                let welcomMsg = NetworkManager.sharedInstance.language(key: "welcome")+"  " + (resultDict.object(forKey: "firstname") as! String) + (resultDict.object(forKey: "lastname") as! String)
                NetworkManager.sharedInstance.showSuccessSnackBar(msg:welcomMsg)
                NetworkManager.sharedInstance.dismissLoader()
                let cartTotalDict = JSON(resultDict);
                if resultDict.object(forKey: "partner") != nil{
                    let partnerValue = cartTotalDict["partner"].intValue
                    if partnerValue == 1{
                        self.defaults.set("true", forKey: "partner")
                    }else{
                        self.defaults.set("false", forKey: "partner")
                    }
                }
                
                if self.moveToSignal == "firstlaunch"{
                    self.dismiss(animated: true, completion: nil)
                }else{
                    if resultDict.object(forKey: "cart_total") != nil{
                        let cartCount  = cartTotalDict["cart_total"].stringValue
                        if cartCount != ""{
                            
                           // self.tabBarController!.tabBar.items?[2].badgeValue
                            ViewController.selfVC.notificationButton.badge = cartCount
                            ViewController.selfVC.countofcart = cartCount
                        }
                        
                    }
                    self.navigationController?.popViewController(animated: true)
                }
                
                
            }else if success == 2{
                NetworkManager.sharedInstance.dismissLoader()
                self.callingHttppApi();
            }
            
            
            
        }
    }
    
    
    
    
}
