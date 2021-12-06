//
//  ProductReviews.swift
//  Opencart
//
//  Created by Kunal Parsad on 07/09/17.
//  Copyright © 2017 Kunal Parsad. All rights reserved.
//

import UIKit

class ProductReviews: UIViewController,UITableViewDelegate, UITableViewDataSource {
    
var emptyView:EmptyNewAddressView!
@IBOutlet weak var productReviews: UITableView!
var productId:String = ""
var productName:String = ""
let defaults = UserDefaults.standard;
var pageNumber:Int = 1
var loadPageRequestFlag:Bool = true;
var indexPathValue:IndexPath!
var productReviewViewModel:ProductReviewViewModel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        productReviews.register(UINib(nibName: "ProductReviewsTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        self.productReviews.rowHeight = UITableView.automaticDimension
        self.productReviews.estimatedRowHeight = 20
        self.navigationItem.title = "reviews".localized
        emptyView = EmptyNewAddressView(frame: self.view.frame);
        self.view.addSubview(emptyView)
        emptyView.isHidden = true;
        emptyView.emptyImages.image = UIImage(named: "empty_review")!
        emptyView.addressButton.setTitle(NetworkManager.sharedInstance.language(key: "addreview"), for: .normal)
        emptyView.labelMessage.text = NetworkManager.sharedInstance.language(key: "noreviews")
        emptyView.addressButton.addTarget(self, action: #selector(browseCategory(sender:)), for: .touchUpInside)
        self.callingHttppApi()
    
    }
    
    
    @objc func browseCategory(sender: UIButton){
        self.performSegue(withIdentifier: "writereview", sender: self)
    }
    
    

    
    public func numberOfSections(in tableView: UITableView) -> Int{
        return 1;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return self.productReviewViewModel.reviewsData.count
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let CellIdentifier: String = "cell"
        let cell:ProductReviewsTableViewCell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier) as! ProductReviewsTableViewCell
        cell.name.text = self.productReviewViewModel.reviewsData[indexPath.row].name
        cell.descriptiontext.text = self.productReviewViewModel.reviewsData[indexPath.row].text
        cell.dateValue.text = self.productReviewViewModel.reviewsData[indexPath.row].date_added
        cell.ratingValue.value = self.productReviewViewModel.reviewsData[indexPath.row].rating
        return cell
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       if (segue.identifier! == "writereview") {
            let viewController:WriteReview = segue.destination as UIViewController as! WriteReview
            viewController.productID = self.productId
            viewController.productNameValue = self.productName
            
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
        DispatchQueue.main.async{
            
            if self.pageNumber == 1{
                self.view.isUserInteractionEnabled = false
                NetworkManager.sharedInstance.showLoader()
            }
            let sessionId = self.defaults.object(forKey:"wk_token");
            var requstParams = [String:Any]();
            requstParams["wk_token"] = sessionId;
            requstParams["page"] = "\(self.pageNumber)"
            requstParams["product_id"] = self.productId
            requstParams["limit"] = "10"
            
            
            NetworkManager.sharedInstance.callingHttpRequest(params:requstParams, apiname:"catalog/getReviews", cuurentView: self){success,responseObject in
                
                if success == 1 {
                    let dict = JSON(responseObject as! NSDictionary)
                    if dict["fault"].intValue == 1{
                        self.loginRequest()
                    }else{
                        self.view.isUserInteractionEnabled = true
                        NetworkManager.sharedInstance.dismissLoader()
                        
                        if dict["error"].intValue == 0{
                            if self.pageNumber == 1{
                                self.productReviewViewModel = ProductReviewViewModel(data:dict)
                                self.productReviews.delegate = self
                                self.productReviews.dataSource = self
                            }else{
                                self.productReviewViewModel.setProductreviewData(data: dict)
                            }
                            self.doFurther()
                        }else{
                            NetworkManager.sharedInstance.showWarningSnackBar(msg: dict["message"].stringValue)
                            self.navigationController?.popViewController(animated: true)
                        }
                        
                    }
                    
                }else if success == 2{
                    NetworkManager.sharedInstance.dismissLoader()
                    self.callingHttppApi();
                }
            }
            
            
        }
    }
    
    
    
    
    
    
    func doFurther(){
        if self.productReviewViewModel.reviewsData.count > 0{
            productReviews.isHidden = false
            self.loadPageRequestFlag = true
            emptyView.isHidden = true
            self.productReviews.reloadData()
        }else{
            productReviews.isHidden = true;
            emptyView.isHidden = false
        }
        
      
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentCellCount = self.productReviews.numberOfRows(inSection: 0)
        for cell: UITableViewCell in self.productReviews.visibleCells {
            indexPathValue = self.productReviews.indexPath(for: cell)!
            if indexPathValue.row == self.productReviews.numberOfRows(inSection: 0) - 1 {
                if (productReviewViewModel.total > currentCellCount) && loadPageRequestFlag{
                    pageNumber += 1
                    loadPageRequestFlag = false
                    callingHttppApi()
                }
            }
        }
    }
    
    
    
    
}
