//
//  PaymentController.swift
//  OpenCartMpV3
//
//  Created by kunal on 20/12/17.
//  Copyright © 2017 kunal. All rights reserved.
//

import UIKit

class PaymentController: UIViewController,UITableViewDelegate, UITableViewDataSource {
    
@IBOutlet weak var ParentView: UIView!
@IBOutlet weak var billingView: UIView!
@IBOutlet weak var line1: UILabel!

@IBOutlet weak var shippingView: UIView!
@IBOutlet weak var line2: UILabel!
@IBOutlet weak var line3: UILabel!
@IBOutlet weak var shipmentView: UIView!
@IBOutlet weak var line4: UILabel!
@IBOutlet weak var line5: UILabel!
@IBOutlet weak var paymentView: UIView!
@IBOutlet weak var line6: UILabel!
@IBOutlet weak var line7: UILabel!
@IBOutlet weak var reviewView: UIView!
@IBOutlet weak var line8: UILabel!

@IBOutlet weak var billingLabel: UILabel!
@IBOutlet weak var shippingLabel: UILabel!
@IBOutlet weak var shipmentLabel: UILabel!
@IBOutlet weak var paymentLabel: UILabel!
@IBOutlet weak var reviewLabel: UILabel!


@IBOutlet weak var view1: UIView!
@IBOutlet weak var view2: UIView!
@IBOutlet weak var view3: UIView!
@IBOutlet weak var view4: UIView!
@IBOutlet weak var view5: UIView!
@IBOutlet weak var paymentTableView: UITableView!
@IBOutlet weak var continueButton: UIButton!
var paymentMethodViewModel :PaymentMethodViewModel!
var orderReviewViewModel:OrderReviewViewModel!
var paymentId:String = ""
let defaults = UserDefaults.standard;
var isShippingRequired:Bool = false
var isAgree:Bool = false
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        ParentView.backgroundColor = UIColor().HexToColor(hexString: EXTRALIGHTGREY)
        billingView.backgroundColor = UIColor().HexToColor(hexString: LIGHTGREY)
        shippingView.backgroundColor = UIColor().HexToColor(hexString: LIGHTGREY)
        shipmentView.backgroundColor = UIColor().HexToColor(hexString: LIGHTGREY)
        paymentView.backgroundColor = UIColor().HexToColor(hexString: LIGHTGREY)
        reviewView.backgroundColor = UIColor().HexToColor(hexString: LIGHTGREY)
        view1.backgroundColor = UIColor().HexToColor(hexString: EXTRALIGHTGREY)
        view2.backgroundColor = UIColor().HexToColor(hexString: EXTRALIGHTGREY)
        view3.backgroundColor = UIColor().HexToColor(hexString: EXTRALIGHTGREY)
        view4.backgroundColor = UIColor().HexToColor(hexString: EXTRALIGHTGREY)
        view5.backgroundColor = UIColor().HexToColor(hexString: EXTRALIGHTGREY)
        
        line1.backgroundColor = UIColor().HexToColor(hexString: LIGHTGREY)
        line2.backgroundColor = UIColor().HexToColor(hexString: LIGHTGREY)
        line3.backgroundColor = UIColor().HexToColor(hexString: LIGHTGREY)
        line4.backgroundColor = UIColor().HexToColor(hexString: LIGHTGREY)
        line5.backgroundColor = UIColor().HexToColor(hexString: LIGHTGREY)
        line6.backgroundColor = UIColor().HexToColor(hexString: LIGHTGREY)
        line7.backgroundColor = UIColor().HexToColor(hexString: LIGHTGREY)
        line8.backgroundColor = UIColor().HexToColor(hexString: LIGHTGREY)
        
        billingView.layer.cornerRadius = 10
        billingView.layer.masksToBounds = true;
        billingView.layer.borderWidth = 2.0
        billingView.layer.backgroundColor = UIColor().HexToColor(hexString: BUTTON_COLOR).cgColor
        billingView.layer.borderColor = UIColor().HexToColor(hexString: BUTTON_COLOR).cgColor
        
        shippingView.layer.cornerRadius = 10
        shippingView.layer.masksToBounds = true;
        shippingView.layer.backgroundColor = UIColor().HexToColor(hexString: BUTTON_COLOR).cgColor
        
        shipmentView.layer.cornerRadius = 10
        shipmentView.layer.masksToBounds = true;
        shipmentView.layer.borderWidth = 2.0
        shipmentView.layer.backgroundColor = UIColor().HexToColor(hexString: BUTTON_COLOR).cgColor
        shipmentView.layer.borderColor = UIColor().HexToColor(hexString: BUTTON_COLOR).cgColor
        
        paymentView.layer.cornerRadius = 10
        paymentView.layer.masksToBounds = true;
        paymentView.layer.borderWidth = 2.0
        paymentView.layer.backgroundColor = UIColor.white.cgColor
        paymentView.layer.borderColor = UIColor().HexToColor(hexString: BUTTON_COLOR).cgColor
        
        reviewView.layer.cornerRadius = 10
        reviewView.layer.masksToBounds = true;
        
        
        paymentTableView.register(UINib(nibName: "PaymentTableViewCell", bundle: nil), forCellReuseIdentifier: "PaymentTableViewCell")
        paymentTableView.register(UINib(nibName: "CommentCell", bundle: nil), forCellReuseIdentifier: "CommentCell")
        paymentTableView.register(UINib(nibName: "PrivacyTableViewCell", bundle: nil), forCellReuseIdentifier: "PrivacyTableViewCell")
        
        
        paymentTableView.rowHeight = UITableView.automaticDimension
        self.paymentTableView.estimatedRowHeight = 50
        paymentTableView.separatorColor = UIColor.clear
        
        continueButton.backgroundColor = UIColor().HexToColor(hexString: BUTTON_COLOR)
        continueButton.setTitleColor(UIColor.white, for: .normal)
        continueButton.layer.cornerRadius = 5;
        continueButton.layer.masksToBounds = true
        continueButton.setTitle(NetworkManager.sharedInstance.language(key: "continue"), for: .normal)
        self.navigationItem.title = "payment".localized
        billingLabel.text = NetworkManager.sharedInstance.language(key: "billingadd")
        shippingLabel.text = NetworkManager.sharedInstance.language(key: "shippingadd")
        paymentLabel.text = NetworkManager.sharedInstance.language(key: "payment")
        shipmentLabel.text = NetworkManager.sharedInstance.language(key: "shipment")
        reviewLabel.text = NetworkManager.sharedInstance.language(key: "reviews")
    }
    
    
    @IBAction func closeController(_ sender: UIBarButtonItem) {
        GlobalVariables.proceedToCheckOut = false
        self.dismiss(animated: true)
    }
    
    @IBAction func billingClick(_ sender: UITapGestureRecognizer) {
        self.tabBarController!.selectedIndex = 0
    }
    
    
    @IBAction func shippingClick(_ sender: UITapGestureRecognizer) {
         if isShippingRequired{
            self.tabBarController!.selectedIndex = 1
        }
    }
    
    @IBAction func shipmentClick(_ sender: UITapGestureRecognizer) {
         if isShippingRequired{
            self.tabBarController!.selectedIndex = 2
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.items?[4].isEnabled = false
        
        if 4 < GlobalVariables.CurrentIndex{
            GlobalVariables.CurrentIndex = 4;
            self.view.isUserInteractionEnabled = true
        }
        else{
            let billingNavigationController = self.tabBarController?.viewControllers?[0]
            let nav = billingNavigationController as! UINavigationController;
            let billingViewController = nav.viewControllers[0] as! BillingInformation
            
            if billingViewController.billingAddressViewModel.isShippingRequired == 1{
                let shipmentNavigationController = self.tabBarController?.viewControllers?[2]
                let nav = shipmentNavigationController as! UINavigationController;
                let shipmentViewController = nav.viewControllers[0] as! ShipmentController
                paymentMethodViewModel = shipmentViewController.paymentMethodViewModel;
                isShippingRequired = true
            }else{
                paymentMethodViewModel = billingViewController.paymentMethodViewModel;
                isShippingRequired = false
            }
            self.doFurtherWork()
        }
    }
    
    func doFurtherWork(){
        
        if paymentMethodViewModel.getPaymentMethod.count > 0{
          paymentTableView.dataSource = self
          paymentTableView.delegate = self
          paymentTableView.reloadData()
        }else{
          let AC = UIAlertController(title: NetworkManager.sharedInstance.language(key: "message"), message: NetworkManager.sharedInstance.language(key: "nopayment"), preferredStyle: .alert)
          let okBtn = UIAlertAction(title: NetworkManager.sharedInstance.language(key: "ok"), style: .default, handler: {(_ action: UIAlertAction) -> Void in
            self.tabBarController!.selectedIndex = 0
            
          })
          AC.addAction(okBtn)
         self.present(AC, animated: true, completion: nil)
        }
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if section == 0{
          return paymentMethodViewModel.getPaymentMethod.count
        }else{
            return 1
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
        let cell:PaymentTableViewCell = tableView.dequeueReusableCell(withIdentifier: "PaymentTableViewCell") as! PaymentTableViewCell
        cell.methodDescription.text = paymentMethodViewModel.getPaymentMethod[indexPath.row].paymentTitle
        if paymentId == paymentMethodViewModel.getPaymentMethod[indexPath.row].paymentCode{
            cell.roundImageView.backgroundColor = UIColor().HexToColor(hexString: BUTTON_COLOR)
        }else{
            cell.roundImageView.backgroundColor = UIColor.white
         }
          return cell;
        }else if indexPath.section == 1{
            let cell:CommentCell = tableView.dequeueReusableCell(withIdentifier: "CommentCell") as! CommentCell
            cell.commentField.addTarget(self, action: #selector(self.writeComment), for: UIControl.Event.editingChanged)
            cell.commentField.text = self.paymentMethodViewModel.commentMessage
            return cell
        }else{
            let cell:PrivacyTableViewCell = tableView.dequeueReusableCell(withIdentifier: "PrivacyTableViewCell") as! PrivacyTableViewCell
            cell.privacyMessage.addTarget(self, action: #selector(showPrivacyMessage(sender:)), for: .touchUpInside)
            cell.switchButton.addTarget(self, action: #selector(switchClick(sender:)), for: .valueChanged)
            return cell
        }
        
       
    }
    
    
    
    
    
    @objc func showPrivacyMessage(sender: UIButton){
        self.performSegue(withIdentifier: "privacy", sender: self)
    }
    
    @objc func switchClick(sender: UISwitch){
        if sender.isOn{
            isAgree = true
        }else{
            isAgree = false
        }
    }
    
    @objc func writeComment(textField: UITextField) {
        paymentMethodViewModel.commentMessage = textField.text!
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        paymentId = paymentMethodViewModel.getPaymentMethod[indexPath.row].paymentCode
        self.paymentTableView.reloadData()
        
    }
    
    
    
    
    
    @IBAction func continueClick(_ sender: UIButton) {
        if paymentId  == ""{
            NetworkManager.sharedInstance.showErrorSnackBar(msg: "selectpaymentmethod".localized)
        }else if isAgree == false{
            NetworkManager.sharedInstance.showWarningSnackBar(msg: NetworkManager.sharedInstance.language(key: "pleasecheckprivacypolicy"))
        } else{
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
        requstParams["function"] = "confirm"
        requstParams["payment_method"] = self.paymentId
        requstParams["comment"] = self.paymentMethodViewModel.commentMessage
        requstParams["wallet"] = false
        requstParams["agree"] = "1"
        NetworkManager.sharedInstance.callingHttpRequest(params:requstParams, apiname:"checkout/checkout", cuurentView: self){success,responseObject in
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
                    self.orderReviewViewModel = OrderReviewViewModel(data:JSON(responseObject as! NSDictionary))
                    self.tabBarController?.tabBar.items?[4].isEnabled = true
                    GlobalVariables.CurrentIndex = 5;
                    self.tabBarController!.selectedIndex = 4
                    
                    
                }
            }else if success == 2{
                NetworkManager.sharedInstance.dismissLoader()
                self.callingHttppApi();
            }
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier! == "privacy") {
            let viewController:PrivacyPolicy = segue.destination as UIViewController as! PrivacyPolicy
            viewController.privacyMessage = paymentMethodViewModel.getTermandCondition
        }
        
    }
   

}
