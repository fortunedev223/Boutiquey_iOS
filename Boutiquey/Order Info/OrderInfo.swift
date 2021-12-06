//
//  OrderInfo.swift
//  OpenCartApplication
//
//  Created by shobhit on 24/08/17.
//  Copyright © 2017 webkul. All rights reserved.
//

import UIKit
import Alamofire

class OrderInfo: UIViewController,UITableViewDelegate, UITableViewDataSource {
    var orderInfoViewModel : OrderInfoViewModel!
    let defaults = UserDefaults.standard;
    var orderId : String = ""
    var orderDateAdded : String = ""
    var checkTypeUser : Bool!
    var dynamicCellHeight:CGFloat = 0
    var dynamicSummaryHeight:CGFloat = 0
    var productId:String = ""
    var order_productId:String = ""
    var whichApiToProcess:String = ""
    
    @IBOutlet weak var orderInfoTableView: UITableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        self.title = NetworkManager.sharedInstance.language(key: "myorderinformation");
        orderInfoTableView.register(UINib(nibName: "OrderInfoItemList", bundle: nil), forCellReuseIdentifier: "OrderInfoItemList")
        orderInfoTableView.register(UINib(nibName: "OrderSummaryCell", bundle: nil), forCellReuseIdentifier: "OrderSummaryCell")
        orderInfoTableView.register(UINib(nibName: "AddressesTableViewCell", bundle: nil), forCellReuseIdentifier: "AddressesTableViewCell")
        orderInfoTableView.register(UINib(nibName: "PriceCellTableViewCell", bundle: nil), forCellReuseIdentifier: "PriceCellTableViewCell")
        
        orderInfoTableView.rowHeight = UITableView.automaticDimension
        self.orderInfoTableView.estimatedRowHeight = 50
        orderInfoTableView.separatorColor = UIColor.clear
        
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
        requstParams["order_id"] = orderId
        
        if whichApiToProcess == "reorder"{
            requstParams["order_product_id"] = self.order_productId
            NetworkManager.sharedInstance.callingHttpRequest(params:requstParams, apiname:"customer/reorder", cuurentView: self){success,responseObject in
                if success == 1 {
                    let dict = JSON(responseObject as! NSDictionary)
                    if dict["fault"].intValue == 1{
                            self.loginRequest()
                    }else{
                        self.view.isUserInteractionEnabled = true
                        NetworkManager.sharedInstance.dismissLoader()
                        if dict["error"].number == 1{
                            NetworkManager.sharedInstance.showWarningSnackBar(msg:dict["message"].stringValue)
                        }else{
                           NetworkManager.sharedInstance.showSuccessSnackBar(msg:dict["message"].stringValue)
                           self.tabBarController?.selectedIndex = 3
                        }
                        
                       
                        
                    }
                }else if success == 2{
                    NetworkManager.sharedInstance.dismissLoader()
                    self.callingHttppApi();
                }
            }
            
            
        }else{
        NetworkManager.sharedInstance.callingHttpRequest(params:requstParams, apiname:"customer/getOrderInfo", cuurentView: self){success,responseObject in
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
                        self.orderInfoViewModel = OrderInfoViewModel(data: JSON(responseObject as! NSDictionary))
                        self.doFurtherWork()
                    }
                    
                  
                    
                }
            }else if success == 2{
                NetworkManager.sharedInstance.dismissLoader()
                self.callingHttppApi();
            }
        }
        }
        
        
        
    }
    
    
    
    func doFurtherWork(){
        orderInfoTableView.dataSource = self
        orderInfoTableView.delegate = self
        orderInfoTableView.reloadData()
        
        
        
    }
    
    
    
    public func numberOfSections(in tableView: UITableView) -> Int{
        return 6;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if section == 0{
            return orderInfoViewModel.getProductsInfoData.count
        }else if section == 1{
            return orderInfoViewModel.totalsDataModel.count;
        }else{
            return 1
        }
        
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            let cell:OrderInfoItemList = tableView.dequeueReusableCell(withIdentifier: "OrderInfoItemList") as! OrderInfoItemList
            cell.productName.text = orderInfoViewModel.getProductsInfoData[indexPath.row].name
            cell.qtyValue.text = orderInfoViewModel.getProductsInfoData[indexPath.row].quantity
            cell.priceValue.text = orderInfoViewModel.getProductsInfoData[indexPath.row].price
            cell.subtotalValue.text = orderInfoViewModel.getProductsInfoData[indexPath.row].subTotal
            cell.returnButton.tag = indexPath.row
            cell.returnButton.addTarget(self, action: #selector(returnOrdersButtonTapped(sender:)), for: .touchUpInside)
            cell.cartButton.addTarget(self, action: #selector(addToCartTapped(sender:)), for: .touchUpInside)
            cell.returnButton.tag = indexPath.row
            cell.cartButton.tag = indexPath.row
            cell.cartButton.isHidden = false
            var optionData:String = ""
            
            for data in orderInfoViewModel.getProductsInfoData[indexPath.row].option{
                optionData += data.name+" : "+data.value + "\n"
            }
            cell.optionLabel.text = optionData
           
            return cell
        }else if indexPath.section == 1{
            let cell:PriceCellTableViewCell = tableView.dequeueReusableCell(withIdentifier: "PriceCellTableViewCell") as! PriceCellTableViewCell
            cell.title.text = orderInfoViewModel.totalsDataModel[indexPath.row].title
            cell.value.text = orderInfoViewModel.totalsDataModel[indexPath.row].text
            return cell
            
        }
        else if indexPath.section == 2{
            let cell:AddressesTableViewCell = tableView.dequeueReusableCell(withIdentifier: "AddressesTableViewCell") as! AddressesTableViewCell
            cell.addressLabel.text = orderInfoViewModel.orderInfoDataModel.paymentAddress
            return cell
            
            
        }else if indexPath.section == 3 {
            let cell:AddressesTableViewCell = tableView.dequeueReusableCell(withIdentifier: "AddressesTableViewCell") as! AddressesTableViewCell
            cell.addressLabel.text = orderInfoViewModel.orderInfoDataModel.shippingAddress
            return cell
            
        }else if indexPath.section == 4 {
            let cell:AddressesTableViewCell = tableView.dequeueReusableCell(withIdentifier: "AddressesTableViewCell") as! AddressesTableViewCell
            cell.addressLabel.text = orderInfoViewModel.orderInfoDataModel.paymentMethod
            return cell
            
        }else {
            let cell:AddressesTableViewCell = tableView.dequeueReusableCell(withIdentifier: "AddressesTableViewCell") as! AddressesTableViewCell
            cell.addressLabel.text = orderInfoViewModel.orderInfoDataModel.shippingMethod
            return cell
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0{
            return NetworkManager.sharedInstance.language(key: "itemlist")+" #"+orderId
        }else if section == 1{
            return NetworkManager.sharedInstance.language(key: "ordersummary")
        }else if section == 2{
            return NetworkManager.sharedInstance.language(key: "billingaddress")
        }else if section == 3 {
            return NetworkManager.sharedInstance.language(key: "shippingaddress")
        }else if section == 4 {
            return NetworkManager.sharedInstance.language(key: "payment")
        }else {
            return NetworkManager.sharedInstance.language(key: "shipment")
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat{
        return 40
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 1{
            return 40
        }
        else{
            return UITableView.automaticDimension
        }
        
    }
    
    @objc func returnOrdersButtonTapped(sender: UIButton){
        productId = orderInfoViewModel.getProductsInfoData[sender.tag].productId
        let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "ProductReturnController") as! ProductReturnController
        secondViewController.productId = self.productId
        secondViewController.orderId = self.orderId
        self.navigationController?.pushViewController(secondViewController, animated: true)
    }
    
    @objc func addToCartTapped(sender: UIButton){
        order_productId = orderInfoViewModel.getProductsInfoData[sender.tag].order_productID
        whichApiToProcess = "reorder";
        callingHttppApi()
        
     }
    
    
    
    
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    
    
    
}
