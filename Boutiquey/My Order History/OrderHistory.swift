//
//  OrderHistory.swift
//  OpenCartApplication
//
//  Created by shobhit on 24/08/17.
//  Copyright © 2017 webkul. All rights reserved.
//

import UIKit
import Alamofire

class OrderHistory: UIViewController, UITableViewDelegate, UITableViewDataSource {
  
    @IBOutlet weak var ordersTableView: UITableView!
    
    var orderHistoryViewModel:OrderHistoryViewModel!
    let defaults = UserDefaults.standard;
    var orderId : String = ""
    var orderDateAdded : String = ""
    var refreshControl:UIRefreshControl!
    var pageNumber:Int = 1
    var loadPageRequestFlag:Bool = true;
    var totalCount:Int = 0
    var indexPathValue:IndexPath!
    var emptyView:EmptyNewAddressView!
    var whichApiToProcess:String = ""
    var order_productId:String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = false
        self.title = NetworkManager.sharedInstance.language(key: "myorder")
        
        ordersTableView.register(UINib(nibName: "MyOrderTableViewCell", bundle: nil), forCellReuseIdentifier: "MyOrderTableViewCell")
        ordersTableView.register(UINib(nibName: "FooterCell", bundle: nil), forCellReuseIdentifier: "FooterCell")
        
        emptyView = EmptyNewAddressView(frame: self.view.frame);
        self.view.addSubview(emptyView)
        emptyView.isHidden = true;
        emptyView.emptyImages.image = UIImage(named: "empty_order")!
        emptyView.addressButton.setTitle(NetworkManager.sharedInstance.language(key: "browsecategory"), for: .normal)
        emptyView.labelMessage.text = NetworkManager.sharedInstance.language(key: "orderempty")
        emptyView.addressButton.addTarget(self, action: #selector(browseCategory(sender:)), for: .touchUpInside)
        
        ordersTableView.rowHeight = UITableView.automaticDimension
        self.ordersTableView.estimatedRowHeight = 50
        ordersTableView.separatorColor = UIColor.clear
        
        callingHttppApi()
        
        //pull to refresh
        refreshControl = UIRefreshControl()
        let attributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        let attributedTitle = NSAttributedString(string: NetworkManager.sharedInstance.language(key: "pulltorefresh"), attributes: attributes)
        refreshControl.attributedTitle = attributedTitle
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        if #available(iOS 10.0, *) {
            ordersTableView.refreshControl = refreshControl
        } else {
            ordersTableView.backgroundView = refreshControl
        }
    }
    
    
    @objc func browseCategory(sender: UIButton){
        self.tabBarController!.selectedIndex = 2
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    
    //MARK:- Pull to refresh
    @objc func refresh(_ refreshControl: UIRefreshControl) {
        self.refreshControl.endRefreshing()
        callingHttppApi()
    }
    
    //MARK:- API Call
    
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
        if self.pageNumber == 1{
          self.view.isUserInteractionEnabled = false
          NetworkManager.sharedInstance.showLoader()
        }
        let sessionId = self.defaults.object(forKey:"wk_token");
        var requstParams = [String:Any]();
        requstParams["wk_token"] = sessionId;
        requstParams["page"] = "\(self.pageNumber)"
        NetworkManager.sharedInstance.callingHttpRequest(params:requstParams, apiname:"customer/getOrders", cuurentView: self){success,responseObject in
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
                        if self.pageNumber == 1{
                            self.orderHistoryViewModel = OrderHistoryViewModel(data: JSON(responseObject as! NSDictionary))
                        }else{
                            self.orderHistoryViewModel.setOrderCollectionData(data: JSON(responseObject as! NSDictionary))
                        }
                        self.loadPageRequestFlag = true
                        self.doFurtherProcessingWithResult()
                    }
                }
            }else if success == 2{
                NetworkManager.sharedInstance.dismissLoader()
                self.callingHttppApi();
            }
        }
    }
    
    func doFurtherProcessingWithResult(){
        DispatchQueue.main.async {
            if self.orderHistoryViewModel.getOrdersData.count > 0{
             self.ordersTableView.delegate = self
             self.ordersTableView.dataSource = self
             self.ordersTableView.reloadData()
             self.emptyView.isHidden = true
            }else{
                self.ordersTableView.isHidden = true
                self.emptyView.isHidden = false
            }
        }
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    
    //MARK:- UITableViewDelegate and UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return self.orderHistoryViewModel.getOrdersData.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyOrderTableViewCell", for: indexPath) as! MyOrderTableViewCell
        cell.orderId.text =  self.orderHistoryViewModel.getOrdersData[indexPath.row].orderId
        cell.statusMessage.text = self.orderHistoryViewModel.getOrdersData[indexPath.row].status
        cell.placedOnDate.text = self.orderHistoryViewModel.getOrdersData[indexPath.row].date
        cell.orderDetails.text = self.orderHistoryViewModel.getOrdersData[indexPath.row].total
        cell.shipToValue.text = self.orderHistoryViewModel.getOrdersData[indexPath.row].customer
        cell.statusMessage.text = self.orderHistoryViewModel.getOrdersData[indexPath.row].status
        cell.viewOrderButton.tag = indexPath.row
        cell.viewOrderButton.addTarget(self, action: #selector(viewOrdersButtonTapped(sender:)), for: .touchUpInside)
        
        
        if self.orderHistoryViewModel.getOrdersData[indexPath.row].status.lowercased() == "pending"{
            cell.imageData.image = UIImage(named: "order_pending")!
        }else if self.orderHistoryViewModel.getOrdersData[indexPath.row].status.lowercased() == "complete"{
            cell.imageData.image = UIImage(named: "order_complete")!
        }else if self.orderHistoryViewModel.getOrdersData[indexPath.row].status.lowercased() == "cancelled"{
            cell.imageData.image = UIImage(named: "order_cancel")!
        }else if self.orderHistoryViewModel.getOrdersData[indexPath.row].status.lowercased() == "processing"{
            cell.imageData.image = UIImage(named: "order_processing")!
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // cell selected code here
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastSectionIndex = tableView.numberOfSections - 1
        let lastRowIndex = tableView.numberOfRows(inSection: lastSectionIndex) - 1
        if indexPath.section ==  lastSectionIndex && indexPath.row == lastRowIndex && orderHistoryViewModel.totalCount > lastRowIndex + 1{
             let cell = tableView.dequeueReusableCell(withIdentifier: "FooterCell") as! FooterCell
            self.ordersTableView.tableFooterView = cell
            self.ordersTableView.tableFooterView?.isHidden = false
        }else{
            self.ordersTableView.tableFooterView = nil
            self.ordersTableView.tableFooterView?.isHidden = true
        }
    }
    
 
    
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentCellCount = self.ordersTableView.numberOfRows(inSection: 0)
        for cell: UITableViewCell in self.ordersTableView.visibleCells {
            indexPathValue = self.ordersTableView.indexPath(for: cell)!
            if indexPathValue.row == self.ordersTableView.numberOfRows(inSection: 0) - 1 {
                if (orderHistoryViewModel.totalCount > currentCellCount) && loadPageRequestFlag{
                    pageNumber += 1
                    whichApiToProcess = ""
                    loadPageRequestFlag = false
                    callingHttppApi()
                }
            }
        }
    }
    
    
    //MARK:- @IBAction
    
    @objc func viewOrdersButtonTapped(sender: UIButton){
        orderId = self.orderHistoryViewModel.getOrdersData[sender.tag].orderId
        orderDateAdded = self.orderHistoryViewModel.getOrdersData[sender.tag].date
        self.performSegue(withIdentifier: "myOrdersToOrderInfo", sender: self);
    }
    
    
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier! == "myOrdersToOrderInfo") {
            let viewController:OrderInfo = segue.destination as UIViewController as! OrderInfo
            viewController.orderId = orderId
            viewController.orderDateAdded = orderDateAdded
        }
    }
}
