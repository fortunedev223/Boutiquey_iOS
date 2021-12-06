//
//  OrderReview.swift
//  OpenCartMpV3
//
//  Created by kunal on 20/12/17.
//  Copyright © 2017 kunal. All rights reserved.
//

import UIKit

class OrderReview: UIViewController,UITableViewDelegate, UITableViewDataSource {
    
    
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
@IBOutlet weak var orderReviewTableView: UITableView!
var orderReviewViewModel:OrderReviewViewModel!
var dynamicCellHeight:CGFloat = 0
var dynamicSummaryHeight:CGFloat = 0
    
@IBOutlet weak var continueButton: UIButton!
let defaults = UserDefaults.standard;
var successMessage:String = ""
var isShipmentThere:Bool = true
var paymentCode:String = ""
var initialSetupViewController: PTFWInitialSetupViewController!
var payTabStatus:String = "0"
var isPayTabExecute:Bool = false
    
    
    
    

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
        paymentView.layer.backgroundColor = UIColor().HexToColor(hexString: BUTTON_COLOR).cgColor
        paymentView.layer.borderColor = UIColor().HexToColor(hexString: BUTTON_COLOR).cgColor
        
        reviewView.layer.cornerRadius = 10
        reviewView.layer.masksToBounds = true;
        reviewView.layer.borderWidth = 2.0
        reviewView.layer.backgroundColor = UIColor.white.cgColor
        reviewView.layer.borderColor = UIColor().HexToColor(hexString: BUTTON_COLOR).cgColor

        orderReviewTableView.register(UINib(nibName: "ItemListTableViewCell", bundle: nil), forCellReuseIdentifier: "ItemListTableViewCell")
        orderReviewTableView.register(UINib(nibName: "OrderSummaryCell", bundle: nil), forCellReuseIdentifier: "OrderSummaryCell")
        orderReviewTableView.register(UINib(nibName: "AddressesTableViewCell", bundle: nil), forCellReuseIdentifier: "AddressesTableViewCell")
        orderReviewTableView.register(UINib(nibName: "PriceCellTableViewCell", bundle: nil), forCellReuseIdentifier: "PriceCellTableViewCell")
        
        orderReviewTableView.rowHeight = UITableView.automaticDimension
        self.orderReviewTableView.estimatedRowHeight = 50
        orderReviewTableView.separatorColor = UIColor.clear
        
        billingLabel.text = NetworkManager.sharedInstance.language(key: "billingadd")
        shippingLabel.text = NetworkManager.sharedInstance.language(key: "shippingadd")
        paymentLabel.text = NetworkManager.sharedInstance.language(key: "payment")
        shipmentLabel.text = NetworkManager.sharedInstance.language(key: "shipment")
        reviewLabel.text = NetworkManager.sharedInstance.language(key: "reviews")
        self.navigationItem.title = "ordersummary".localized
        continueButton.backgroundColor = UIColor().HexToColor(hexString: BUTTON_COLOR)
        continueButton.setTitleColor(UIColor.white, for: .normal)
        continueButton.layer.cornerRadius = 5;
        continueButton.layer.masksToBounds = true
        continueButton.setTitle(NetworkManager.sharedInstance.language(key: "continue"), for: .normal)

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
    
    
    @IBAction func shipmentClick(_ sender: UITapGestureRecognizer) {
        self.tabBarController!.selectedIndex = 2
    }
    
    
    @IBAction func paymentClick(_ sender: UITapGestureRecognizer) {
        self.tabBarController!.selectedIndex = 3
    }
    
    
    @IBAction func continueClick(_ sender: UIButton) {
        if paymentCode == "paytabs"{
            self.initiatePaytabs()
        }else{
            callingHttppApi()
        }
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        
        let billingNavigationController = self.tabBarController?.viewControllers?[0]
        let navigation = billingNavigationController as! UINavigationController;
        let billingController = navigation.viewControllers[0] as! BillingInformation
        if billingController.billingAddressViewModel.isShippingRequired == 1{
            self.isShipmentThere = true
        }else{
            self.isShipmentThere = false
        }
        
        let paymentNavigationController = self.tabBarController?.viewControllers?[3]
        let nav = paymentNavigationController as! UINavigationController;
        let paymentViewController = nav.viewControllers[0] as! PaymentController
        orderReviewViewModel = paymentViewController.orderReviewViewModel;
        paymentCode = paymentViewController.paymentId
        self.doSetup()
    }
    
    
    
    
    func doSetup(){
        orderReviewTableView.dataSource = self
        orderReviewTableView.delegate = self
        orderReviewTableView.reloadData()
        
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int{
        return 6;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if section == 0{
            return orderReviewViewModel.getTotalProducts.count
        }else if section == 1{
            return orderReviewViewModel.getTotalAmount.count
        }else if section == 3 || section == 5{
            if isShipmentThere{
                return 1
            }else{
                return 0
            }
        }
        else{
            return 1;
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    if indexPath.section == 0{
    let cell:ItemListTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ItemListTableViewCell") as! ItemListTableViewCell
    cell.name.text = orderReviewViewModel.getTotalProducts[indexPath.row].productName
    cell.priceValue.text = orderReviewViewModel.getTotalProducts[indexPath.row].price
    cell.qtyValue.text  = orderReviewViewModel.getTotalProducts[indexPath.row].quantity
    cell.subTotalValue.text = orderReviewViewModel.getTotalProducts[indexPath.row].subTotal
    
    var Y:CGFloat = 0;
    var optionDict = orderReviewViewModel.getTotalProducts[indexPath.row].option
    
    if (optionDict?.count)! > 0 {
        let productOption = UILabel(frame: CGRect(x: CGFloat(5), y: CGFloat(Y), width: CGFloat(cell.dynamicView.frame.size.width - 10), height: CGFloat(20)))
        productOption.textColor = UIColor().HexToColor(hexString: LIGHTGREY)
        productOption.font = UIFont(name: BOLDFONT, size: CGFloat(13))!
        productOption.text = NetworkManager.sharedInstance.language(key: "options")
        cell.dynamicView.addSubview(productOption)
        
        Y += 20
        
        for j in 0..<(optionDict?.count)!{
            var dict = optionDict?[j];
            let productPrice = UILabel(frame: CGRect(x: CGFloat(5), y: CGFloat(Y), width: CGFloat(cell.dynamicView.frame.size.width - 10), height: CGFloat(20)))
            productPrice.textColor = UIColor().HexToColor(hexString: LIGHTGREY)
            productPrice.font = UIFont(name: REGULARFONT, size: CGFloat(12))!
            productPrice.text = (dict?["name"].stringValue)!+" "+(dict?["value"].stringValue)!
            cell.dynamicView.addSubview(productPrice)
            Y += 20
        }
        
    }
    dynamicCellHeight = Y;
    cell.dynamicViewHeightConstarints.constant = Y
    cell.productImage.loadImageFrom(url:orderReviewViewModel.getTotalProducts[indexPath.row].image , dominantColor: "fffff")
    return cell
    }
    else if indexPath.section == 1{
        let cell:PriceCellTableViewCell = tableView.dequeueReusableCell(withIdentifier: "PriceCellTableViewCell") as! PriceCellTableViewCell
        cell.title.text = orderReviewViewModel.getTotalAmount[indexPath.row].title
        cell.value.text = orderReviewViewModel.getTotalAmount[indexPath.row].text
        return cell;
        
    }else if indexPath.section == 2{
        let cell:AddressesTableViewCell = tableView.dequeueReusableCell(withIdentifier: "AddressesTableViewCell") as! AddressesTableViewCell
        cell.addressLabel.text = orderReviewViewModel.getBillingAddress
        return cell
        
        
    }else if indexPath.section == 3 {
        let cell:AddressesTableViewCell = tableView.dequeueReusableCell(withIdentifier: "AddressesTableViewCell") as! AddressesTableViewCell
        cell.addressLabel.text = orderReviewViewModel.getShippingAdress
        return cell
        
    }else if indexPath.section == 4 {
        let cell:AddressesTableViewCell = tableView.dequeueReusableCell(withIdentifier: "AddressesTableViewCell") as! AddressesTableViewCell
        cell.addressLabel.text = orderReviewViewModel.getPaymentMethodData
        return cell
        
    }else {
        let cell:AddressesTableViewCell = tableView.dequeueReusableCell(withIdentifier: "AddressesTableViewCell") as! AddressesTableViewCell
        cell.addressLabel.text = orderReviewViewModel.getShipmentMethodData
        return cell
        
    }
   
    }
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0{
            return NetworkManager.sharedInstance.language(key: "itemlist")
        }else if section == 1{
            return NetworkManager.sharedInstance.language(key: "ordersummary")
        }else if section == 2{
            return NetworkManager.sharedInstance.language(key: "billingaddress")
        }else if section == 3 {
            if isShipmentThere{
                return NetworkManager.sharedInstance.language(key: "shippingaddress")
            }else{
                return ""
            }
        }else if section == 4 {
            return NetworkManager.sharedInstance.language(key: "payment")
        }else {
            if isShipmentThere{
                return NetworkManager.sharedInstance.language(key: "shipment")
            }else{
                return ""
            }
        }
    }
    
    
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat{
        if section == 3 || section == 5 {
            if isShipmentThere{
                return 40
            }else{
                return CGFloat.leastNonzeroMagnitude
            }
        }else{
            return 40.00
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNonzeroMagnitude
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0{
            return 160 + dynamicCellHeight
        }else if indexPath.section == 1{
            return 40
        }
        else{
            return UITableView.automaticDimension
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
                self.callingHttppApi();
            }
        }
        
    }
    
    
    
    func doFurtherProcessingWithresult(data:AnyObject){
        let dict = JSON(data as! NSDictionary)
        self.view.isUserInteractionEnabled = true
        if dict["error"].intValue == 0{
            let subDict = dict["success"]
            NotificationCenter.default.post(name: Notification.Name(rawValue: "cartclearnotification"), object: self)
            successMessage = subDict["text_message"].stringValue
            self.performSegue(withIdentifier: "orderConfirmation", sender: self)
        }else{
            NetworkManager.sharedInstance.showErrorMessage(view: self, message:dict["message"].stringValue)
            
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier! == "orderConfirmation") {
            let viewController:OrderConfirmation = segue.destination as UIViewController as! OrderConfirmation
            viewController.successMessage = successMessage
        }else if (segue.identifier! == "webviewpayment") {
            let viewController:PayPalPaymentWebView = segue.destination as UIViewController as! PayPalPaymentWebView
            viewController.paymentURL = orderReviewViewModel.paymentURL
        }else if (segue.identifier! == "paytabsresult") {
            let viewController:PayTabresultController = segue.destination as UIViewController as! PayTabresultController
            viewController.state = self.payTabStatus
            viewController.order_id = self.orderReviewViewModel.order_id
        }
        
        
    }
    
    
    
    func initiatePaytabs(){
        self.setUpPayTabs()
        let bundle = Bundle(url: Bundle.main.url(forResource: ApplicationResources.kFrameworkResourcesBundle, withExtension: "bundle")!)
        
        if bundle?.path(forResource: ApplicationXIBs.kPTFWInitialSetupView, ofType: "nib") != nil {
            print("exists")
        } else {
            print("not exist")
        }
        self.addChild(initialSetupViewController)
        self.view.addSubview(initialSetupViewController.view)
        initialSetupViewController.didMove(toParent: self)
        
    }
    
    
    
    
    func setUpPayTabs(){
        
        let bundle = Bundle(url: Bundle.main.url(forResource: ApplicationResources.kFrameworkResourcesBundle, withExtension: "bundle")!)
        
        self.initialSetupViewController = PTFWInitialSetupViewController.init(
            nibName: ApplicationXIBs.kPTFWInitialSetupView,
            bundle: bundle,
            andWithViewFrame: self.view.frame,
            andWithAmount: self.orderReviewViewModel.pt_amount,
            andWithCustomerTitle: "Boutiquey",
            andWithCurrencyCode: self.orderReviewViewModel.pt_currency_code.uppercased(),
            andWithTaxAmount: 0.0,
            andWithSDKLanguage: "ar",
            andWithShippingAddress: self.orderReviewViewModel.pt_address_shipping,
            andWithShippingCity: self.orderReviewViewModel.pt_city_shipping,
            andWithShippingCountry: self.orderReviewViewModel.pt_shipping_iso_code_3,
            andWithShippingState: self.orderReviewViewModel.pt_state_shipping,
            andWithShippingZIPCode: self.orderReviewViewModel.pt_postal_code_shipping,
            andWithBillingAddress: self.orderReviewViewModel.pt_address_billing,
            andWithBillingCity: self.orderReviewViewModel.pt_city_billing,
            andWithBillingCountry: self.orderReviewViewModel.pt_payment_iso_code_3,
            andWithBillingState: self.orderReviewViewModel.pt_state_billing,
            andWithBillingZIPCode: self.orderReviewViewModel.pt_postal_code_billing,
            andWithOrderID: self.orderReviewViewModel.pt_order_id,
            andWithPhoneNumber: self.orderReviewViewModel.pt_customer_phone_number,
            andWithCustomerEmail: self.orderReviewViewModel.pt_customer_email,
            andIsTokenization: true,
            andWithMerchantEmail: self.orderReviewViewModel.pt_merchant_email,
            andWithMerchantSecretKey: self.orderReviewViewModel.pt_secret_key,
            andWithAssigneeCode: "SDK",
            andWithThemeColor: UIColor.blue,
            andIsThemeColorLight: false)
        
        weak var weakSelf = self
        self.initialSetupViewController.didReceiveBackButtonCallback = {
            weakSelf?.handleBackButtonTapEvent()
        }
        
        self.initialSetupViewController.didReceiveFinishTransactionCallback = {(responseCode, result, transactionID, tokenizedCustomerEmail, tokenizedCustomerPassword, token, transactionState) in
            
            
            if responseCode == 100{
                self.payTabStatus = "1";
            }else{
                self.payTabStatus = "0";
            }
            self.isPayTabExecute = true
            self.performSegue(withIdentifier: "paytabsresult", sender: self)
            weakSelf?.handleBackButtonTapEvent()
            
        }
    }
    
    
    // MARK: Close SDK Event
    private func handleBackButtonTapEvent() {
        self.initialSetupViewController.willMove(toParent: nil)
        self.initialSetupViewController.view.removeFromSuperview()
        self.initialSetupViewController.removeFromParent()
        if !isPayTabExecute{
            self.dismiss(animated: true, completion: nil)
        }
        
    }
    
    // MARK: Close Response window Event
    private func handleCloseResponseViewTapEvent() {
        
    }
    
    
    
    
    
    
    
    
    
    

}
