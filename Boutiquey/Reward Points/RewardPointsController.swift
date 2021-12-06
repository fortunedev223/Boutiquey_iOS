//
//  RewardPointsController.swift
//  BroPhone
//
//  Created by kunal on 15/01/18.
//  Copyright © 2018 kunal. All rights reserved.
//

import UIKit

class RewardPointsController: UIViewController,UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var rewardTableView: UITableView!
    
    let defaults = UserDefaults.standard
    var totalCount:Int = 0
    var pageNumber:Int = 1
    var rewardPointViewModel:RewardPointViewModel!
    var indexPathValue:IndexPath!
    var loadPageRequestFlag:Bool = true
    var refreshControl:UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        
        self.title = NetworkManager.sharedInstance.languageBundle.localizedString(forKey: "rewardpoints", value: "", table: nil);
        headerLabel.isHidden = true
        rewardTableView.register(UINib(nibName: "RewardTableViewCell", bundle: nil), forCellReuseIdentifier: "RewardTableViewCell")
        rewardTableView.rowHeight = UITableView.automaticDimension
        self.rewardTableView.estimatedRowHeight = 50
        rewardTableView.separatorColor = UIColor.clear
        
        //pull to refresh
        refreshControl = UIRefreshControl()
        let attributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        let attributedTitle = NSAttributedString(string: NetworkManager.sharedInstance.language(key: "pulltorefresh"), attributes: attributes)
        refreshControl.attributedTitle = attributedTitle
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        if #available(iOS 10.0, *) {
            rewardTableView.refreshControl = refreshControl
        } else {
            rewardTableView.backgroundView = refreshControl
        }
        
        //Call API
        self.callingHttppApi()
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
        DispatchQueue.main.async{
            self.view.isUserInteractionEnabled = false
            NetworkManager.sharedInstance.showLoader()
            let sessionId = self.defaults.object(forKey:"wk_token");
            var requstParams = [String:Any]();
            requstParams["wk_token"] = sessionId;
            requstParams["page"] = "\(self.pageNumber)"
            NetworkManager.sharedInstance.callingHttpRequest(params:requstParams, apiname:"customer/getRewardInfo", cuurentView: self){success,responseObject in
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
                        if self.pageNumber == 1{
                            self.rewardPointViewModel = RewardPointViewModel(data:JSON(responseObject as! NSDictionary))
                            
                        }else{
                            self.rewardPointViewModel.setRewardCollectionData(data:JSON(responseObject as! NSDictionary))
                        }
                        self.doFurtherData()
                    }
                    
                }else if success == 2{
                    NetworkManager.sharedInstance.dismissLoader()
                    self.callingHttppApi();
                }
            }
        }
    }
    
    func doFurtherData(){
        totalCount = self.rewardPointViewModel.totalCount
        headerLabel.isHidden = false
        if self.rewardPointViewModel.rewardCollectionModel.count > 0{
            headerLabel.text = rewardPointViewModel.headerMessage.html2String
            loadPageRequestFlag = true
            self.rewardTableView.delegate = self
            self.rewardTableView.dataSource = self
            self.rewardTableView.reloadData()
        }
        else{
            headerLabel.text = NetworkManager.sharedInstance.language(key: "noreward")
        }
    }
    
    //MARK:- UITableView
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return self.rewardPointViewModel.rewardCollectionModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:RewardTableViewCell = tableView.dequeueReusableCell(withIdentifier: "RewardTableViewCell", for: indexPath) as! RewardTableViewCell
        cell.dateValue.text = self.rewardPointViewModel.rewardCollectionModel[indexPath.row].date_added
        cell.descriptionValue.text = self.rewardPointViewModel.rewardCollectionModel[indexPath.row].descriptionValue
        cell.pointsValue.text = self.rewardPointViewModel.rewardCollectionModel[indexPath.row].points
        cell.pointsLabel.text = NetworkManager.sharedInstance.language(key: "points")
        return cell
    }
    
    //MARK:- UIScrollViewDelegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentCellCount = self.rewardTableView.numberOfRows(inSection: 0)
        for cell: UITableViewCell in self.rewardTableView.visibleCells {
            indexPathValue = self.rewardTableView.indexPath(for: cell)!
            if indexPathValue.row == self.rewardTableView.numberOfRows(inSection: 0) - 1 {
                if (totalCount > currentCellCount) && loadPageRequestFlag{
                    loadPageRequestFlag = false
                    pageNumber += 1;
                    callingHttppApi()
                }
            }
        }
    }
}
