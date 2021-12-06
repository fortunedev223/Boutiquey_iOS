//
//  subCategory.swift
//  DummySwift
//
//  Created by kunal prasad on 11/11/16.
//  Copyright © 2016 Webkul. All rights reserved.
//

import UIKit


class subCategory: UIViewController,UITableViewDelegate,UITableViewDataSource {
    public var categoryName = " "
    var categoryId:String = " ";
    var subId:String = ""
    var subName:String = ""
    var subcategoryViewModel:SubcategoryViewModel!
    @IBOutlet weak var subCategoryTable: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = subName
        self.callingHttppApi()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.subcategoryViewModel.cataegoriesCollectionModel.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.alingment()
        cell.textLabel?.font = UIFont.init(name: REGULARFONT, size: 14)
        
        if indexPath.row == 0{
            cell.textLabel?.text = "viewall".localized+" "+subName
            cell.textLabel?.textColor = UIColor().HexToColor(hexString: BUTTON_COLOR)
        }else{
            cell.textLabel?.text = self.subcategoryViewModel.cataegoriesCollectionModel[indexPath.row - 1].name
            cell.textLabel?.textColor = UIColor.black
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0{
            categoryName = subName
            categoryId = subId
            self.performSegue(withIdentifier: "productCategorySegue", sender: self)
        }else{
            if  self.subcategoryViewModel.cataegoriesCollectionModel[indexPath.row - 1].isChild{
                let sb = UIStoryboard(name: "Main", bundle: nil)
                let initViewController: subCategory? = (sb.instantiateViewController(withIdentifier: "subCategory") as? subCategory)
                initViewController?.subName = self.subcategoryViewModel.cataegoriesCollectionModel[indexPath.row - 1].name
                initViewController?.subId = self.subcategoryViewModel.cataegoriesCollectionModel[indexPath.row - 1].id
                initViewController?.modalTransitionStyle = .flipHorizontal
                self.navigationController?.pushViewController(initViewController!, animated: true)
            }else{
                categoryName = self.subcategoryViewModel.cataegoriesCollectionModel[indexPath.row - 1].name
                categoryId = self.subcategoryViewModel.cataegoriesCollectionModel[indexPath.row - 1].id
                self.performSegue(withIdentifier: "productCategorySegue", sender: self)
            }
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "productCategorySegue") {
            let viewController:Productcategory = segue.destination as UIViewController as! Productcategory
            viewController.categoryType = ""
            viewController.categoryName = self.categoryName
            viewController.categoryId = self.categoryId
        }
    }
    
    
    
    func loginRequest(){
        var loginRequest = [String:String]()
        loginRequest["apiKey"] = API_USER_NAME
        loginRequest["apiPassword"] = API_KEY.md5
        if sharedPrefrence.object(forKey: "language") != nil{
            loginRequest["language"] = sharedPrefrence.object(forKey: "language") as? String;
        }
        if sharedPrefrence.object(forKey: "currency") != nil{
            loginRequest["currency"] = sharedPrefrence.object(forKey: "currency") as? String;
        }
        if sharedPrefrence.object(forKey: "customer_id") != nil{
            loginRequest["customer_id"] = sharedPrefrence.object(forKey: "customer_id") as? String;
        }
        NetworkManager.sharedInstance.callingHttpRequest(params:loginRequest, apiname:"common/apiLogin", cuurentView: self){val,responseObject in
            if val == 1{
                let dict = JSON(responseObject as! NSDictionary)
                if dict["error"].intValue == 0{
                    sharedPrefrence.set(dict["wk_token"].stringValue, forKey: "wk_token")
                    sharedPrefrence.set(dict["language"].stringValue, forKey: "language")
                    sharedPrefrence.set(dict["currency"].stringValue, forKey: "currency")
                    sharedPrefrence.synchronize()
                    self.callingHttppApi()
                }
            }else if val == 2{
                NetworkManager.sharedInstance.dismissLoader()
                self.loginRequest()
            }
        }
    }
    
    
    
    func callingHttppApi(){
        DispatchQueue.main.async{
            self.view.isUserInteractionEnabled = false
            let sessionId = sharedPrefrence.object(forKey:"wk_token");
            var requstParams = [String:Any]()
            requstParams["wk_token"] = sessionId
            requstParams["category_id"] = self.subId
            NetworkManager.sharedInstance.showLoader()
            
            NetworkManager.sharedInstance.callingHttpRequest(params:requstParams, apiname:"common/getSubCategory", cuurentView: self){val,responseObject in
                if val == 1 {
                    self.view.isUserInteractionEnabled = true
                    let dict = JSON(responseObject as! NSDictionary)
                    if dict["fault"].intValue == 1{
                        self.loginRequest()
                    }else{
                        NetworkManager.sharedInstance.dismissLoader()
                        self.subcategoryViewModel = SubcategoryViewModel(data: dict)
                        self.subCategoryTable.delegate = self
                        self.subCategoryTable.dataSource = self
                        self.subCategoryTable.reloadData()
                        
                    }
                    
                }else if val == 2{
                    NetworkManager.sharedInstance.dismissLoader()
                    self.callingHttppApi()
                    
                }
            }
        }
    }
    
    
    
    
    
    
    
    
    
    
    
}


