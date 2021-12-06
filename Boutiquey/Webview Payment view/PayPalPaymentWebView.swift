//
//  PayPalPaymentWebView.swift
//  Shop767
//
//  Created by kunal prasad on 07/04/17.
//  Copyright © 2017 Webkul. All rights reserved.
//

import UIKit

class PayPalPaymentWebView: UIViewController,UIWebViewDelegate {

@IBOutlet weak var paymentWebView: UIWebView!
    
public var paymentURL:String = ""
var state:String = ""
let defaults = UserDefaults.standard;
var successMessage:String = ""

    @IBOutlet weak var cancelBtnOutlet: UIBarButtonItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = NetworkManager.sharedInstance.language(key: "payment")
        self.tabBarController?.tabBar.isHidden = true
        self.navigationItem.setHidesBackButton(true, animated:true);
        paymentWebView.delegate = self
        let requestData = paymentURL
        let url = NSURL (string: requestData)
        let requestObj = URLRequest(url: url! as URL)
        paymentWebView.loadRequest(requestObj)
        self.cancelBtnOutlet.title = NetworkManager.sharedInstance.language(key: "cancel")
   
    }
    
    
    
    private func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebView.NavigationType) -> Bool {
        //CAPTURE USER LINK-CLICK.
        let url: URL? = request.url
        
        let requestURL = url?.absoluteString
        let finalURL:String = requestURL!.replacingOccurrences(of: "&amp;", with: "", options: .literal, range: nil)
        let queryItems = URLComponents(string: finalURL)?.queryItems
        let param1 = queryItems?.filter({$0.name == "status_id"}).first
    
        
        if param1?.value != nil{
            if param1?.value == "0"{
                state = "failure"
                paymentWebView.stopLoading()
                callingApi()
            }else if param1?.value == "1"{
                state = "approved"
                paymentWebView.stopLoading()
                callingApi()
            }
        }
       
        
 
        return true
    }

    
    func webViewDidStartLoad(_ webView: UIWebView) {
        NetworkManager.sharedInstance.showLoader()
        
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        NetworkManager.sharedInstance.dismissLoader()
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        print("Error for WEBVIEW:" ,error)
        NetworkManager.sharedInstance.dismissLoader()
        
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier! == "orderConfirmation") {
            let viewController:OrderConfirmation = segue.destination as UIViewController as! OrderConfirmation
            viewController.successMessage = successMessage
        }
    }
    
    
    
    
    @IBAction func cancelPayment(_ sender: Any) {
        let AC = UIAlertController(title: NetworkManager.sharedInstance.language(key: "warning") , message: NetworkManager.sharedInstance.language(key: "nopayment"), preferredStyle: .alert)
        let okBtn = UIAlertAction(title: NetworkManager.sharedInstance.language(key: "ok"), style: .default, handler: {(_ action: UIAlertAction) -> Void in
            self.state = "Failure";
            self.callingApi()
       
        })
        let noBtn = UIAlertAction(title: NetworkManager.sharedInstance.language(key: "cancel"), style: .destructive, handler: {(_ action: UIAlertAction) -> Void in
        })
        AC.addAction(okBtn)
        AC.addAction(noBtn)
        self.parent!.present(AC, animated: true, completion: nil)
    }

    override func viewWillDisappear(_ animated: Bool) {
        NetworkManager.sharedInstance.showLoader()
        
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
                self.callingApi()
            }else if val == 2{
                NetworkManager.sharedInstance.dismissLoader()
                self.loginRequest();
                
            }
        }
    }
    
    
    func callingApi(){
        self.view.isUserInteractionEnabled = false
        NetworkManager.sharedInstance.showLoader()
        let sessionId = self.defaults.object(forKey:"wk_token");
        var requstParams = [String:Any]();
        requstParams["wk_token"] = sessionId;
        requstParams["state"] = state;
        NetworkManager.sharedInstance.callingHttpRequest(params:requstParams, apiname:"checkout/confirmOrder", cuurentView: self){success,responseObject in
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
                    self.doFurtherProcessingWithresult(data:responseObject!)
                
                    
                }
            }else if success == 2{
                NetworkManager.sharedInstance.dismissLoader()
                self.callingApi();
            }
        }
        
    }
    
    
    
    
    
    func doFurtherProcessingWithresult(data:AnyObject){
        let dict = data as! NSDictionary
        self.view.isUserInteractionEnabled = true
        NetworkManager.sharedInstance.dismissLoader()
        
        if dict.object(forKey: "error") as! Int == 0{
            let subDict = dict.object(forKey: "success") as! NSDictionary
            successMessage = subDict.object(forKey: "text_message") as! String
            self.performSegue(withIdentifier: "orderConfirmation", sender: self)
        }else{
            successMessage = "Your Payment was Not Accepted and No approval from the Apgsenangpay"
            self.performSegue(withIdentifier: "orderConfirmation", sender: self)
            
        }

    }
    
    
    
    
    
   
}
