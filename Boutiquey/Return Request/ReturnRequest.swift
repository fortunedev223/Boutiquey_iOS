//
//  ReturnRequest.swift
//  OpenCartApplication
//
//  Created by Kunal Parsad on 05/09/17.
//  Copyright © 2017 webkul. All rights reserved.
//

import UIKit

class ReturnRequest: UIViewController,UITableViewDelegate, UITableViewDataSource  {
    
@IBOutlet weak var emptyLabel: UILabel!
@IBOutlet weak var returnRequestTableView: UITableView!
var pageNumber:Int = 1
let defaults = UserDefaults.standard;
var returnRequestViewModel:ReturnRequestViewModel!
var returnId:String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        self.returnRequestTableView.separatorStyle = .none
        self.returnRequestTableView.backgroundColor = UIColor.clear
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.title = NetworkManager.sharedInstance.language(key: "returnrequest");
        returnRequestTableView.register(UINib(nibName: "ReturnRequestTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        returnRequestTableView.rowHeight = UITableView.automaticDimension
        self.returnRequestTableView.estimatedRowHeight = 50
        returnRequestTableView.separatorColor = UIColor.clear
        
        
        let sessionId = defaults.object(forKey:"wk_token")
        emptyLabel.isHidden = true;
        if(sessionId == nil){
            loginRequest();
        }
        else{
            callingHttppApi();
            
        }

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
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
        requstParams["page"] = "\(pageNumber)";
        NetworkManager.sharedInstance.callingHttpRequest(params:requstParams, apiname:"customer/getReturns", cuurentView: self){success,responseObject in
         if success == 1 {
                NetworkManager.sharedInstance.dismissLoader()
                let dict = JSON(responseObject as! NSDictionary)
                if dict["fault"].intValue == 1{
                        self.loginRequest()
                }else{
                 
                    if dict["error"].intValue == 1{
                        let AC = UIAlertController(title: nil, message: dict["message"].stringValue , preferredStyle: .alert)
                        let okBtn = UIAlertAction(title: NetworkManager.sharedInstance.language(key: "ok"), style: .default, handler: {(_ action: UIAlertAction) -> Void in
                            self.navigationController?.popViewController(animated: true)
                        })
                        AC.addAction(okBtn)
                        self.present(AC, animated: true, completion: nil)
                    }else{
                     self.view.isUserInteractionEnabled = true
                     self.returnRequestViewModel = ReturnRequestViewModel(data:dict)
                     self.doFurtherProcessingWithResult()
                    }
                }
                
            }else if success == 2{
                NetworkManager.sharedInstance.dismissLoader()
                self.callingHttppApi()
            }
        }
    }
    
    
    
    
    
    func doFurtherProcessingWithResult(){
        
        returnRequestTableView.delegate  = self
        returnRequestTableView.dataSource = self
        returnRequestTableView.reloadData()

        
    }


    
    public func numberOfSections(in tableView: UITableView) -> Int{
        return 1;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return returnRequestViewModel.getMyReturnRequestData.count
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let CellIdentifier: String = "cell"
        let cell:ReturnRequestTableViewCell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier) as! ReturnRequestTableViewCell
        cell.statusLabelValue.text = returnRequestViewModel.getMyReturnRequestData[indexPath.row].status
        cell.dateAddedLabelValue.text = returnRequestViewModel.getMyReturnRequestData[indexPath.row].date
        cell.orderIdLabelValue.text = returnRequestViewModel.getMyReturnRequestData[indexPath.row].orderId
        cell.customerLabelValue.text = returnRequestViewModel.getMyReturnRequestData[indexPath.row].name
        cell.viewButton.addTarget(self, action: #selector(viewOrdersButtonTapped(sender:)), for: .touchUpInside)
        cell.returnIdLabel.text = " "+"returnid".localized+" #"+returnRequestViewModel.getMyReturnRequestData[indexPath.row].returnId+" "
        
        cell.viewButton.tag = indexPath.row
        cell.cellView.myBorder()
        return cell
    }
    

    
    @objc func viewOrdersButtonTapped(sender: UIButton){
        self.returnId = returnRequestViewModel.getMyReturnRequestData[sender.tag].returnId
        self.performSegue(withIdentifier: "viewreturnrequest", sender: self)
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier! == "viewreturnrequest") {
            let viewController:ViewReturnRequestDataController = segue.destination as UIViewController as! ViewReturnRequestDataController
            viewController.returnId = returnId
           
            
        }
        
    }
    
    
    
    

   }
