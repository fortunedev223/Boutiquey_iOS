//
//  ViewReturnRequestDataController.swift
//  Boutiquey
//
//  Created by kunal on 02/06/18.
//  Copyright © 2018 yogesh. All rights reserved.
//

import UIKit

class ViewReturnRequestDataController: UIViewController,UITableViewDelegate,UITableViewDataSource{
var returnId:String = ""
let defaults = UserDefaults.standard;
var viewReturnRequestViewModel:ViewReturnRequestViewModel!
    
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = NetworkManager.sharedInstance.language(key: "viewreturnrequest");
        let sessionId = defaults.object(forKey:"wk_token")
        tableView.register(UINib(nibName: "ViewOrderInfoCell", bundle: nil), forCellReuseIdentifier: "ViewOrderInfoCell")
        tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 50
        tableView.separatorColor = UIColor.clear
        if(sessionId == nil){
            loginRequest();
        }
        else{
            callingHttppApi();
            
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
                self.loginRequest()
            }
        }
    }
    
    func callingHttppApi(){
        self.view.isUserInteractionEnabled = false
        NetworkManager.sharedInstance.showLoader()
        let sessionId = self.defaults.object(forKey:"wk_token");
        var requstParams = [String:Any]();
        requstParams["wk_token"] = sessionId;
        requstParams["return_id"] = self.returnId;
        
        NetworkManager.sharedInstance.callingHttpRequest(params:requstParams, apiname:"customer/getReturnInfo", cuurentView: self){success,responseObject in
            if success == 1 {
                NetworkManager.sharedInstance.dismissLoader()
                let dict = responseObject as! NSDictionary;
                if dict.object(forKey: "fault") != nil{
                    let fault = dict.object(forKey: "fault") as! Bool;
                    if fault == true{
                        self.loginRequest()
                    }
                }else{
                    self.viewReturnRequestViewModel = ViewReturnRequestViewModel(data:JSON(responseObject as! NSDictionary))
                    self.tableView.delegate  = self
                    self.tableView.dataSource = self
                    self.tableView.reloadData()
             
                }
                
            }else if success == 2{
                NetworkManager.sharedInstance.dismissLoader()
                self.callingHttppApi()
            }
        }
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 1
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ViewOrderInfoCell", for: indexPath) as! ViewOrderInfoCell
        cell.orderIdLabel.text = NetworkManager.sharedInstance.language(key: "orderid")+" :"+viewReturnRequestViewModel.viewReturnRequestModel.order_id
        cell.retiurnIdLabel.text = NetworkManager.sharedInstance.language(key: "returnid")+" :"+viewReturnRequestViewModel.viewReturnRequestModel.return_id
        cell.dateAddedLabel.text = NetworkManager.sharedInstance.language(key: "dateadded")+" :"+viewReturnRequestViewModel.viewReturnRequestModel.date_added
        cell.orderDateLabel.text = NetworkManager.sharedInstance.language(key: "orderdate")+" :"+viewReturnRequestViewModel.viewReturnRequestModel.date_ordered
    
        cell.productNameLabelValue.text = viewReturnRequestViewModel.viewReturnRequestModel.product
        cell.modelLabelValue.text = viewReturnRequestViewModel.viewReturnRequestModel.model
        cell.qtyLabelValue.text = viewReturnRequestViewModel.viewReturnRequestModel.quantity
        
        
        cell.reasonLabelValue.text = viewReturnRequestViewModel.viewReturnRequestModel.reason
        cell.openedLabelValue.text = viewReturnRequestViewModel.viewReturnRequestModel.opened
        cell.actionLabelValue .text = viewReturnRequestViewModel.viewReturnRequestModel.action
        
        
        
        
        return cell
    
    }
    
    
    
    
    
    
    
    
    
    
    

}
