//
//  MyCart.swift
//  Magento2MobikulNew
//
//  Created by Kunal Parsad on 29/08/17.
//  Copyright © 2017 Kunal Parsad. All rights reserved.
//

import UIKit

class MyCart: UIViewController,UITableViewDelegate, UITableViewDataSource ,UpdateCartHandlerDelegate{
    let defaults = UserDefaults.standard;
    @IBOutlet weak var cartTableView: UITableView!
    var extraHeight:CGFloat = 0
    var extraAmountHeight:CGFloat = 0
    var whichApiToProcess:String = ""
    var quantityDict = [String:String]();
    
    @IBOutlet weak var checkoutButton: UIButton!
    var productId:String!
    var voucharCode:String!
    var couponCode:String!
    var productName:String!
    var productPrice:String!
    var imageUrl:String!
    var emptyView:EmptyNewAddressView!
    
    @IBOutlet var trashButton: UIBarButtonItem!
    
    var myCartViewModel:CartViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = NetworkManager.sharedInstance.language(key: "mycart")
        self.navigationController?.isNavigationBarHidden = false
        
        whichApiToProcess = "";
        
        cartTableView.separatorColor = UIColor.clear
        emptyView = EmptyNewAddressView(frame: self.view.frame);
        self.view.addSubview(emptyView)
        emptyView.isHidden = true;
        emptyView.emptyImages.image = UIImage(named: "empty_cart")!
        emptyView.addressButton.setTitle(NetworkManager.sharedInstance.language(key: "browsecategory"), for: .normal)
        emptyView.labelMessage.text = NetworkManager.sharedInstance.language(key: "cartempty")
        emptyView.addressButton.addTarget(self, action: #selector(browseCategory(sender:)), for: .touchUpInside)
        
        cartTableView.register(UINib(nibName: "PriceCellTableViewCell", bundle: nil), forCellReuseIdentifier: "PriceCellTableViewCell")
        cartTableView.register(UINib(nibName: "CartTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        cartTableView.register(UINib(nibName: "ExtraCartTableViewCell", bundle: nil), forCellReuseIdentifier: "extracell")
        
        cartTableView.rowHeight = UITableView.automaticDimension
        self.cartTableView.estimatedRowHeight = 50
        cartTableView.separatorColor = UIColor.clear
        checkoutButton.setTitle(NetworkManager.sharedInstance.language(key: "continue"), for: .normal)
        checkoutButton.backgroundColor = UIColor().HexToColor(hexString: BUTTON_COLOR)
        checkoutButton.setTitleColor(UIColor.white, for: .normal)
        checkoutButton.isHidden = true;
        checkoutButton.applyCorner()
        
        trashButton.isEnabled = false
        NotificationCenter.default.addObserver(self, selector: #selector(self.clearCartData), name: NSNotification.Name(rawValue: "cartclearnotification"), object: nil)
        
    }
    
    @objc func clearCartData(_ note: Notification) {
        whichApiToProcess = "";
        self.callingHttppApi()
    }
    
    @objc func browseCategory(sender: UIButton){
        self.tabBarController!.selectedIndex = 2
    }
    
    
    @IBAction func trashClick(_ sender: UIBarButtonItem) {
        let AC = UIAlertController(title: NetworkManager.sharedInstance.language(key: "pleaseconfirm"), message: NetworkManager.sharedInstance.language(key: "carttotalempty"), preferredStyle: .alert)
        let okBtn = UIAlertAction(title:NetworkManager.sharedInstance.language(key: "remove"), style: .default, handler: {(_ action: UIAlertAction) -> Void in
            self.whichApiToProcess = "delete"
            self.callingHttppApi();
            
            
        })
        let noBtn = UIAlertAction(title:NetworkManager.sharedInstance.language(key: "cancel"), style: .destructive, handler: {(_ action: UIAlertAction) -> Void in
        })
        AC.addAction(okBtn)
        AC.addAction(noBtn)
        self.parent!.present(AC, animated: true, completion: nil)
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
        self.view.isUserInteractionEnabled = true
        if GlobalVariables.proceedToCheckOut == true{
            self.tabBarController!.tabBar.items?[2].badgeValue = nil
            self.tabBarController!.selectedIndex = 0
            GlobalVariables.proceedToCheckOut = false
        }else{
            whichApiToProcess = ""
            extraHeight = 0
            callingHttppApi()
        }
    }
    
    
    @IBAction func dismissKeyboard(_ sender: Any) {
        view.endEditing(true)
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
        DispatchQueue.main.async{
            self.view.isUserInteractionEnabled = false
            let sessionId = self.defaults.object(forKey:"wk_token");
            var requstParams =  [String:Any]()
            requstParams["wk_token"] = sessionId;
            
            if self.whichApiToProcess == "updateCart"{
                
                do {
                    let jsonSortData =  try JSONSerialization.data(withJSONObject: self.quantityDict, options: .prettyPrinted)
                    let jsonSortString:String = NSString(data: jsonSortData, encoding: String.Encoding.utf8.rawValue)! as String
                    requstParams["quantity"] = jsonSortString
                    
                }
                catch {
                    print(error.localizedDescription)
                }
                NetworkManager.sharedInstance.callingHttpRequest(params:requstParams, apiname:"cart/updateCart", cuurentView: self){success,responseObject in
                    if success == 1 {
                        let dict = responseObject as! NSDictionary;
                        if dict.object(forKey: "fault") != nil{
                            let fault = dict.object(forKey: "fault") as! Bool;
                            if fault == true{
                                self.loginRequest()
                            }
                        }else{
                            NetworkManager.sharedInstance.dismissLoader()
                            let dict = (responseObject as! NSDictionary)
                           
                            if dict.object(forKey: "error") as! Int == 0{
                                NetworkManager.sharedInstance.showSuccessSnackBar(msg: dict.object(forKey: "message") as! String)
                                self.doFurtherProcessingWithResult()
                            }
                        }
                    }else if success == 2{
                        NetworkManager.sharedInstance.dismissLoader()
                        self.callingHttppApi();
                    }
                }
                
            }else if self.whichApiToProcess == "delete"{
                NetworkManager.sharedInstance.showLoader()
                NetworkManager.sharedInstance.callingHttpRequest(params:requstParams, apiname:"cart/clearCart", cuurentView: self){success,responseObject in
                    if success == 1 {
                        let dict = responseObject as! NSDictionary;
                        if dict.object(forKey: "fault") != nil{
                            let fault = dict.object(forKey: "fault") as! Bool;
                            if fault == true{
                                self.loginRequest()
                            }
                        }else{
                            NetworkManager.sharedInstance.dismissLoader()
                            self.view.isUserInteractionEnabled = true;
                            let dict = (responseObject as! NSDictionary)
                         
                            if dict.object(forKey: "error") as! Int == 0{
                                NetworkManager.sharedInstance.showSuccessSnackBar(msg: dict.object(forKey: "message") as! String)
                                self.whichApiToProcess = ""
                                self.callingHttppApi()
                            }
                        }
                    }else if success == 2{
                        NetworkManager.sharedInstance.dismissLoader()
                        self.callingHttppApi();
                    }
                }
                
            }
            
            else if self.whichApiToProcess == "removeitem"{
                NetworkManager.sharedInstance.showLoader()
                requstParams["key"] = self.productId;
                NetworkManager.sharedInstance.callingHttpRequest(params:requstParams, apiname:"cart/removeFromCart", cuurentView: self){success,responseObject in
                    if success == 1 {
                        let dict = responseObject as! NSDictionary;
                        if dict.object(forKey: "fault") != nil{
                            let fault = dict.object(forKey: "fault") as! Bool;
                            if fault == true{
                                self.loginRequest()
                            }
                        }else{
                            NetworkManager.sharedInstance.dismissLoader()
                            let dict = (responseObject as! NSDictionary)
                           
                            if dict.object(forKey: "error") as! Int == 0{
                                NetworkManager.sharedInstance.showSuccessSnackBar(msg: dict.object(forKey: "message") as! String)
                                self.doFurtherProcessingWithResult()
                            }else{
                                self.view.isUserInteractionEnabled = true;
                            }
                        }
                    }else if success == 2{
                        NetworkManager.sharedInstance.dismissLoader()
                        self.callingHttppApi();
                    }
                }
                
            }
            else if self.whichApiToProcess == "voucharcode"{
                NetworkManager.sharedInstance.showLoader()
                requstParams["voucher"] = self.voucharCode;
                NetworkManager.sharedInstance.callingHttpRequest(params:requstParams, apiname:"cart/applyVoucher", cuurentView: self){success,responseObject in
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
                           
                            if dict["error"].intValue == 1 {
                                NetworkManager.sharedInstance.showWarningSnackBar(msg: dict["message"].stringValue)
                            }else{
                                NetworkManager.sharedInstance.showSuccessSnackBar(msg: dict["message"].stringValue)
                                self.whichApiToProcess = ""
                                self.callingHttppApi()
                                
                            }
                        }
                    }else if success == 2{
                        NetworkManager.sharedInstance.dismissLoader()
                        self.callingHttppApi();
                    }
                }
                
            }
            else if self.whichApiToProcess == "couponcode"{
                NetworkManager.sharedInstance.showLoader()
                requstParams["coupon"] = self.couponCode;
                NetworkManager.sharedInstance.callingHttpRequest(params:requstParams, apiname:"cart/applyCoupon", cuurentView: self){success,responseObject in
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
                                NetworkManager.sharedInstance.showSuccessSnackBar(msg: dict["message"].stringValue)
                                self.doFurtherProcessingWithResult()
                            }else{
                                NetworkManager.sharedInstance.showWarningSnackBar(msg: dict["message"].stringValue)
                            }
                        }
                    }else if success == 2{
                        NetworkManager.sharedInstance.dismissLoader()
                        self.callingHttppApi()
                    }
                }
                
                
            }
            else{
                NetworkManager.sharedInstance.showLoader()
                let width = String(format:"%f", SCREEN_WIDTH * UIScreen.main.scale)
                requstParams["width"] = width
                NetworkManager.sharedInstance.callingHttpRequest(params:requstParams, apiname:"cart/viewCart", cuurentView: self){success,responseObject in
                    if success == 1 {
                        let dict = responseObject as! NSDictionary;
                        if dict.object(forKey: "fault") != nil{
                            let fault = dict.object(forKey: "fault") as! Bool;
                            if fault == true{
                                self.loginRequest()
                            }
                        }else{
                            self.view.isUserInteractionEnabled = true
                           
                           
                            self.myCartViewModel = CartViewModel(data: JSON(responseObject as! NSDictionary))
                            self.doFurtherProcessingWithResult()
                             NetworkManager.sharedInstance.dismissLoader()
                        }
                    }else if success == 2{
                        NetworkManager.sharedInstance.dismissLoader()
                        self.callingHttppApi();
                    }
                }
                
            }
        }
        
        
    }
    
    
    
    
    
    
    func doFurtherProcessingWithResult(){
        DispatchQueue.main.async {
            self.view.isUserInteractionEnabled = true
            NetworkManager.sharedInstance.dismissLoader()
            if self.whichApiToProcess == "updateCart"{
                self.whichApiToProcess = ""
                self.callingHttppApi()
            }
            else if self.whichApiToProcess == "removeitem" || self.whichApiToProcess == "clearitem"{
                self.whichApiToProcess = ""
                self.callingHttppApi()
            }
            else if self.whichApiToProcess == "couponcode"{
                self.whichApiToProcess = ""
                self.callingHttppApi()
            }
            else{
                
                if self.myCartViewModel.getProductData.count > 0{
                  //  self.tabBarController!.tabBar.items?[2].badgeValue = self.myCartViewModel.getTotalProducts
                    ViewController.selfVC.notificationButton.badge = self.myCartViewModel.getTotalProducts
                    ViewController.selfVC.countofcart = self.myCartViewModel.getTotalProducts
                    self.checkoutButton.isHidden = false;
                    self.cartTableView.delegate = self
                    self.cartTableView.dataSource = self
                    self.cartTableView.reloadData()
                    self.cartTableView.isHidden = false
                    self.emptyView.isHidden = true
                    self.trashButton.isEnabled = true
                    NetworkManager.sharedInstance.updateCartShortCut(count:self.myCartViewModel.getTotalProducts,succ:true)
                }else{
//                    self.tabBarController!.tabBar.items?[2].badgeValue = nil
                    ViewController.selfVC.notificationButton.badge = nil
                    ViewController.selfVC.countofcart = ""
                    self.checkoutButton.isHidden = true;
                    self.cartTableView.isHidden = true;
                    self.emptyView.isHidden = false
                    self.trashButton.isEnabled = false
                    NetworkManager.sharedInstance.updateCartShortCut(count:self.myCartViewModel.getTotalProducts,succ:false)
                    UIView.animate(withDuration: 1, animations: {() -> Void in
                        self.emptyView.emptyImages.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
                    }, completion: {(_ finished: Bool) -> Void in
                        UIView.animate(withDuration: 1, animations: {() -> Void in
                            self.emptyView.emptyImages.transform = CGAffineTransform(scaleX: 1, y: 1)
                        })
                    })
                }
            }
        }
    }
    
    
    public func numberOfSections(in tableView: UITableView) -> Int{
        return 3;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if section == 0{
            return myCartViewModel.getProductData.count
        }else if section == 1{
            return 1;
        }else{
            return myCartViewModel.getTotalAmount.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            let cell:CartTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell") as! CartTableViewCell
            cell.productName.text = myCartViewModel.getProductData[indexPath.row].productName
            cell.priceValue.text = myCartViewModel.getProductData[indexPath.row].price
            cell.subTotalValue.text = myCartViewModel.getProductData[indexPath.row].subTotal
            cell.productImageView.loadImageFrom(url:myCartViewModel.getProductData[indexPath.row].productImgUrl , dominantColor: "ffffff")
            
            var optionArray = myCartViewModel.getProductData[indexPath.row].optionData
            cell.qtyTextField.text = myCartViewModel.getProductData[indexPath.row].quantity
            cell.qtyStepper.tag = indexPath.row
            cell.myCartViewModel = myCartViewModel
            cell.qtyStepper.value = Double(myCartViewModel.getProductData[indexPath.row].quantity)!
            
            cell.removeButton.tag = indexPath.row
            cell.removeButton.addTarget(self, action: #selector(removeFromToCart(sender:)), for: .touchUpInside)
            
            let Gesture1 = UITapGestureRecognizer(target: self, action: #selector(self.viewProduct))
            Gesture1.numberOfTapsRequired = 1
            cell.productImageView.isUserInteractionEnabled = true
            cell.productImageView.addGestureRecognizer(Gesture1)
            cell.productImageView.tag = indexPath.row
            cell.extraLabel.text = ""
            
            var optionData:String = ""

            for i in 0..<optionArray.count{
                var dict = optionArray[i] ;
                optionData += dict["name"].stringValue+" : "+dict["value"].stringValue + "\n"
            }
            cell.extraLabel.text = optionData
            
            if !myCartViewModel.getProductData[indexPath.row].isAnimate{
                cell.productImageView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
                UIView.animate(withDuration: 0.5, animations: {() -> Void in
                    cell.productImageView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
                }, completion: {(_ finished: Bool) -> Void in
                    UIView.animate(withDuration: 0.5, animations: {() -> Void in
                        cell.productImageView.transform = CGAffineTransform(scaleX: 1, y: 1)
                        self.myCartViewModel.getProductData[indexPath.row].isAnimate = true
                    })
                })
            }
            
            if myCartViewModel.cartproductDataModel[indexPath.row].stock == 0{
                cell.stockMessageLabel.text  = "outofstock".localized
            }else{
                cell.stockMessageLabel.text = ""
            }
            
            cell.delegate = self
            cell.updateIndicator.stopAnimating()
            return cell
        }else if indexPath.section == 1{
            let cell:ExtraCartTableViewCell = tableView.dequeueReusableCell(withIdentifier: "extracell") as! ExtraCartTableViewCell
            
            
            cell.applyVoucharCode.addTarget(self, action: #selector(applyVoucharCode(sender:)), for: .touchUpInside)
            
            cell.updateCartButton.tag = indexPath.row
            cell.updateCartButton.addTarget(self, action: #selector(updateCart(sender:)), for: .touchUpInside)
            
            cell.applyCoupanCodeButton.tag = indexPath.row
            cell.applyCoupanCodeButton.addTarget(self, action: #selector(applyCoupanCode(sender:)), for: .touchUpInside)
            
            if !self.myCartViewModel.coupon_status{
                cell.view1.isHidden = true
            }
            if !self.myCartViewModel.voucher_status{
                cell.view3.isHidden = true
            }
            
            
            return cell
        }else{
            let cell:PriceCellTableViewCell = tableView.dequeueReusableCell(withIdentifier: "PriceCellTableViewCell") as! PriceCellTableViewCell
            cell.title.text = myCartViewModel.getTotalAmount[indexPath.row].title
            cell.value.text = myCartViewModel.getTotalAmount[indexPath.row].text
            return cell;
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 || indexPath.section == 1{
            return UITableView.automaticDimension
        }else{
            return 40
        }
    }
    
    
    
    @objc func viewProduct(_ recognizer: UITapGestureRecognizer) {
        productId = myCartViewModel.getProductData[(recognizer.view?.tag)!].priductId
        productName = myCartViewModel.getProductData[(recognizer.view?.tag)!].productName
        productPrice = myCartViewModel.getProductData[(recognizer.view?.tag)!].price
        imageUrl = myCartViewModel.getProductData[(recognizer.view?.tag)!].productImgUrl
        self.performSegue(withIdentifier: "myproduct", sender: self);
    }
    
    
    @objc func updateCart(sender: UIButton){
        whichApiToProcess = "updateCart";
        quantityDict = [String:String]()
        
        for i in 0..<myCartViewModel.getProductData.count{
            quantityDict[myCartViewModel.getProductData[i].key] = myCartViewModel.getProductData[i].quantity
            
        }
        callingHttppApi()
    }
    
    func updateAPICall(){
        whichApiToProcess = "updateCart";
        quantityDict = [String:String]()
        
        for i in 0..<myCartViewModel.getProductData.count{
            quantityDict[myCartViewModel.getProductData[i].key] = myCartViewModel.getProductData[i].quantity
            
        }
        callingHttppApi()
        
    }
    
    
    
    
    
    
    
    
    @objc func removeFromToCart(sender: UIButton){
        
        let AC = UIAlertController(title: NetworkManager.sharedInstance.language(key: "pleaseconfirm"), message: NetworkManager.sharedInstance.language(key: "cartemtyinfo"), preferredStyle: .alert)
        let okBtn = UIAlertAction(title:NetworkManager.sharedInstance.language(key: "remove"), style: .default, handler: {(_ action: UIAlertAction) -> Void in
            self.whichApiToProcess = "removeitem"
            self.productId = self.myCartViewModel.getProductData[sender.tag].key
            self.callingHttppApi();
            
            
        })
        let noBtn = UIAlertAction(title:NetworkManager.sharedInstance.language(key: "cancel"), style: .destructive, handler: {(_ action: UIAlertAction) -> Void in
        })
        AC.addAction(okBtn)
        AC.addAction(noBtn)
        self.parent!.present(AC, animated: true, completion: nil)
        
    }
    
    @objc func applyVoucharCode(sender: UIButton){
        let AC = UIAlertController(title:NetworkManager.sharedInstance.language(key: "entervouchar"), message: "", preferredStyle: .alert)
        AC.addTextField { (textField) in
            textField.placeholder = "";
        }
        let okBtn = UIAlertAction(title: NetworkManager.sharedInstance.language(key: "ok"), style: .default, handler: {(_ action: UIAlertAction) -> Void in
            let textField = AC.textFields![0]
            if((textField.text?.count)! == 0){
                NetworkManager.sharedInstance.showErrorSnackBar(msg: NetworkManager.sharedInstance.language(key: "fillvoucharcode"))
                
            }
            else{
                self.voucharCode = textField.text!;
                self.whichApiToProcess = "voucharcode"
                self.callingHttppApi();
            }
        })
        let noBtn = UIAlertAction(title: NetworkManager.sharedInstance.language(key: "cancel"), style:.destructive, handler: {(_ action: UIAlertAction) -> Void in
        })
        AC.addAction(okBtn)
        AC.addAction(noBtn)
        self.parent!.present(AC, animated: true, completion: nil)
    }
    
    @objc func applyCoupanCode(sender: UIButton){
            let AC = UIAlertController(title:NetworkManager.sharedInstance.language(key: "entercoupan"), message: "", preferredStyle: .alert)
            AC.addTextField { (textField) in
                textField.placeholder = "";
            }
            let okBtn = UIAlertAction(title: NetworkManager.sharedInstance.language(key: "ok"), style: .default, handler: {(_ action: UIAlertAction) -> Void in
                let textField = AC.textFields![0]
                if((textField.text?.count)! == 0){
                    NetworkManager.sharedInstance.showErrorSnackBar(msg:NetworkManager.sharedInstance.language(key: "fillcouponcode"))
                    
                }
                else{
                    self.couponCode = textField.text!;
                    self.whichApiToProcess = "couponcode"
                    self.callingHttppApi();
                }
            })
            let noBtn = UIAlertAction(title: NetworkManager.sharedInstance.language(key: "cancel"), style:.destructive, handler: {(_ action: UIAlertAction) -> Void in
            })
            AC.addAction(okBtn)
            AC.addAction(noBtn)
            self.parent!.present(AC, animated: true, completion: nil)
    }
    
    @IBAction func proceedToCheckoutClick(_ sender: UIButton) {
        
        if myCartViewModel.checkout == 1{
        
        let customer_id = defaults.object(forKey: "customer_id")
        if customer_id != nil{
                 self.performSegue(withIdentifier: "proceddToCheckout", sender: self)
        }else{
            let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            
            let Create = UIAlertAction(title: NetworkManager.sharedInstance.language(key: "checkoutasguest"), style: .default, handler: checkOutAsGuest)
            let guest = UIAlertAction(title: NetworkManager.sharedInstance.language(key: "registerandcheckout"), style: .default, handler: registerAndCheckOut)
            let Existing = UIAlertAction(title: NetworkManager.sharedInstance.language(key: "checkoutasexistingcustomer"), style: .default, handler: existingUser)
            let cancel = UIAlertAction(title: NetworkManager.sharedInstance.language(key: "cancel"), style: .cancel, handler: cancelDeletePlanet)
            if defaults.object(forKey: "guest") != nil{
                if defaults.object(forKey: "guest") as! String == "true"{
                    alert.addAction(Create)
                }
            }
            alert.addAction(guest)
            alert.addAction(Existing)
            alert.addAction(cancel)
            
            // Support display in iPad
            alert.popoverPresentationController?.sourceView = self.view
            alert.popoverPresentationController?.sourceRect = CGRect(x:self.view.bounds.size.width / 2.0, y: self.view.bounds.size.height / 2.0, width : 1.0, height : 1.0)
            self.present(alert, animated: true, completion: nil)
        }
        }else{
            NetworkManager.sharedInstance.showWarningSnackBar(msg: self.myCartViewModel.errorMessage)
        }
    }
    
    func checkOutAsGuest(alertAction: UIAlertAction!) {
        self.performSegue(withIdentifier: "proceddToCheckout", sender: self)
    }
    
    func registerAndCheckOut(alertAction: UIAlertAction!) {
        self.performSegue(withIdentifier: "cartToCreateAccount", sender: self)
    }
    
    func existingUser(alertAction: UIAlertAction!) {
        self.performSegue(withIdentifier: "cartToCustomerLogin", sender: self)
    }
    
    func cancelDeletePlanet(alertAction: UIAlertAction!) {
    }
    
    func openProduct(_sender : UITapGestureRecognizer){
        productName = myCartViewModel.getProductData[(_sender.view?.tag)!].productName
        productId = myCartViewModel.getProductData[(_sender.view?.tag)!].priductId
        imageUrl = myCartViewModel.getProductData[(_sender.view?.tag)!].productImgUrl
        productPrice = myCartViewModel.getProductData[(_sender.view?.tag)!].price
        self.performSegue(withIdentifier: "myproduct", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier! == "myproduct") {
            let viewController:CatalogProduct = segue.destination as UIViewController as! CatalogProduct
            viewController.productImageUrl = self.imageUrl
            viewController.productId = self.productId
            viewController.productName = self.productName
            viewController.productPrice = self.productPrice
            viewController.isCart = true
        }
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        view.endEditing(true)
    }
}
