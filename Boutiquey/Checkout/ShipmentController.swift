//
//  ShipmentController.swift
//  OpenCartMpV3
//
//  Created by kunal on 20/12/17.
//  Copyright © 2017 kunal. All rights reserved.
//

import UIKit

class ShipmentController: UIViewController,UITableViewDelegate, UITableViewDataSource {
    
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
var shipmentMethodViewModel:ShipmentMethodViewModel!
@IBOutlet weak var shippingTableView: UITableView!
var shipmentMethod:String = ""
let defaults = UserDefaults.standard;
@IBOutlet weak var continueButton: UIButton!
var paymentMethodViewModel :PaymentMethodViewModel!
    
    
    
    
    
    
    
    
  
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
        shipmentView.layer.backgroundColor = UIColor.white.cgColor
        shipmentView.layer.borderColor = UIColor().HexToColor(hexString: BUTTON_COLOR).cgColor
        
        paymentView.layer.cornerRadius = 10
        paymentView.layer.masksToBounds = true;
        
        reviewView.layer.cornerRadius = 10
        reviewView.layer.masksToBounds = true;
        
        
        shippingTableView.register(UINib(nibName: "PaymentTableViewCell", bundle: nil), forCellReuseIdentifier: "PaymentTableViewCell")
        shippingTableView.register(UINib(nibName: "CommentCell", bundle: nil), forCellReuseIdentifier: "CommentCell")
        shippingTableView.rowHeight = UITableView.automaticDimension
        self.shippingTableView.estimatedRowHeight = 50
        shippingTableView.separatorColor = UIColor.clear
        self.navigationItem.title = "shipment".localized
        continueButton.backgroundColor = UIColor().HexToColor(hexString: BUTTON_COLOR)
        continueButton.setTitleColor(UIColor.white, for: .normal)
        continueButton.layer.cornerRadius = 5;
        continueButton.layer.masksToBounds = true
        continueButton.setTitle(NetworkManager.sharedInstance.language(key: "continue"), for: .normal)
        
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
        self.tabBarController!.selectedIndex = 1
    }
    
    
    
    
    

   
    override func viewWillAppear(_ animated: Bool) {
        if GlobalVariables.CurrentIndex > 3{
            // nothing
        }else{
            if sharedPrefrence.object(forKey: "customer_id") != nil{
                let shippingNavigationController = self.tabBarController?.viewControllers?[1]
                let nav = shippingNavigationController as! UINavigationController;
                let shippingViewController = nav.viewControllers[0] as! ShippingInformation
                shipmentMethodViewModel = shippingViewController.shipmentMethodViewModel;
                shipmentMethod = ""
                self.doFurtherWork()
            }
            else{
                let billingNavigationController = self.tabBarController?.viewControllers?[0]
                let navBilling = billingNavigationController as! UINavigationController;
                let billingViewController = navBilling.viewControllers[0] as! BillingInformation
                if billingViewController.billingShippingSameFlag == "1"{
                    shipmentMethodViewModel = billingViewController.shipmentMethodViewModel;
                    shipmentMethod = ""
                    self.doFurtherWork()
                }
                else{
                    let shippingNavigationController = self.tabBarController?.viewControllers?[1]
                    let nav = shippingNavigationController as! UINavigationController;
                    let shippingViewController = nav.viewControllers[0] as! ShippingInformation
                    shipmentMethodViewModel = shippingViewController.shipmentMethodViewModel;
                    shipmentMethod = ""
                    self.doFurtherWork()
                }
            }
            
        }
    }
    
    
    
    func doFurtherWork(){
        if self.shipmentMethodViewModel.getShipmentMethod.count > 0{
          shippingTableView.dataSource = self
          shippingTableView.delegate = self
          shippingTableView.reloadData()
        }else{
            let AC = UIAlertController(title: NetworkManager.sharedInstance.language(key: "warning"), message: NetworkManager.sharedInstance.language(key: "noshipment"), preferredStyle: .alert)
            let okBtn = UIAlertAction(title: NetworkManager.sharedInstance.language(key: "ok"), style: .default, handler: {(_ action: UIAlertAction) -> Void in
                self.tabBarController!.selectedIndex = 1
                
            })
            AC.addAction(okBtn)
            self.present(AC, animated: true, completion:nil)
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if section == 0{
            return shipmentMethodViewModel.getShipmentMethod.count
        }else{
            return 1
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0{
        
        let cell:PaymentTableViewCell = tableView.dequeueReusableCell(withIdentifier: "PaymentTableViewCell") as! PaymentTableViewCell
        cell.methodDescription.text = shipmentMethodViewModel.getShipmentMethod[indexPath.row].shipmentTitle+" "+shipmentMethodViewModel.getShipmentMethod[indexPath.row].shipmentCost
        
        if shipmentMethod == shipmentMethodViewModel.getShipmentMethod[indexPath.row].shipmentCode{
            cell.roundImageView.backgroundColor = UIColor().HexToColor(hexString: BUTTON_COLOR)
        }else{
            cell.roundImageView.backgroundColor = UIColor.white
        }
        
        return cell;
        }else{
            let cell:CommentCell = tableView.dequeueReusableCell(withIdentifier: "CommentCell") as! CommentCell
            cell.commentField.addTarget(self, action: #selector(self.writeComment), for: UIControl.Event.editingChanged)
            cell.commentField.text = self.shipmentMethodViewModel.commentMessage
            return cell
        }
    }
    
    @objc func writeComment(textField: UITextField) {
        shipmentMethodViewModel.commentMessage = textField.text!
    
    }
    
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
     shipmentMethod = shipmentMethodViewModel.getShipmentMethod[indexPath.row].shipmentCode
     self.shippingTableView.reloadData()
    
    }
    
    
    
    @IBAction func continueClick(_ sender: UIButton) {
        if shipmentMethod  == ""{
            NetworkManager.sharedInstance.showErrorSnackBar(msg: "pleaseselectshipment".localized)
        }else{
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
        let customerId = self.defaults.object(forKey:"customer_id");
        let sessionId = self.defaults.object(forKey:"wk_token");
        var requstParams = [String:Any]();
        requstParams["wk_token"] = sessionId;
        requstParams["function"] = "paymentMethod"
        requstParams["shipping_method"] = self.shipmentMethod
        requstParams["comment"] = self.shipmentMethodViewModel.commentMessage
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
                    self.paymentMethodViewModel = PaymentMethodViewModel(data:JSON(responseObject as! NSDictionary))
                    self.tabBarController?.tabBar.items?[3].isEnabled = true
                    GlobalVariables.CurrentIndex = 4;
                    self.tabBarController!.selectedIndex = 3
                      
                }
            }else if success == 2{
                NetworkManager.sharedInstance.dismissLoader()
                self.callingHttppApi();
            }
        }

    } 
    
    
   
   
    
    
    
    
    
    
    
    
    
    
    

}
