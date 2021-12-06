//
//  SearchSuggestion.swift
//  Magento2MobikulNew
//
//  Created by Kunal Parsad on 08/08/17.
//  Copyright © 2017 Kunal Parsad. All rights reserved.
//

import UIKit

class SearchSuggestion: UIViewController,UISearchDisplayDelegate,UISearchBarDelegate ,UITableViewDelegate, UITableViewDataSource,CategoryViewControllerHandlerDelegate,SuggestionProductClickHandlerDelegate,BrandViewControllerHandlerDelegate,RecentSearchDataDelegate {

var searchActive:Bool = false
var searchtext:String = ""
    
let defaults = UserDefaults.standard;
@IBOutlet weak var bottomTableView: UITableView!
var searchSuggestionViewModel:SearchSuggestionViewModel!
var productName = ""
var recentSearchData:NSArray = []
var searchQuery:String = ""
var isHome:Bool = false
var cataegoriesCollectionModel = [Categories]()
var productCollectionModel = [Products]()
 var brandProduct = [BrandProducts]()
var categoryId:String = ""
var categoryName:String = ""
var categoryType:String = ""
lazy   var searchBars:UISearchBar = UISearchBar(frame: CGRect(x: CGFloat(15), y: CGFloat(5), width: CGFloat(200), height: CGFloat(20)))
var subCategory:NSArray = []
var imageUrl:String = ""
var productId:String = ""
    
@IBOutlet var suggestionTableView: UITableView!
@IBOutlet var suggestionTableViewHeight: NSLayoutConstraint!
@IBOutlet var cancelButton: UIBarButtonItem!
    
    

    
    override func viewDidLoad() {
     super.viewDidLoad()
       self.navigationItem.setHidesBackButton(true, animated: false)
       searchBars.delegate = self
       searchBars.placeholder = NetworkManager.sharedInstance.language(key: "searchentirestore")
       searchBars.tintColor = UIColor.black
       searchBars.searchBarStyle = .minimal
       self.navigationItem.titleView = searchBars
       bottomTableView.keyboardDismissMode = .onDrag
       suggestionTableView.keyboardDismissMode = .onDrag
       self.searchSuggestionViewModel = SearchSuggestionViewModel(data:[])
        
        let paymentViewNavigationController = self.tabBarController?.viewControllers?[0]
        let nav1 = paymentViewNavigationController as! UINavigationController;
        let paymentMethodViewController = nav1.viewControllers[0] as! ViewController
        cataegoriesCollectionModel = paymentMethodViewController.homeViewModel.cataegoriesCollectionModel
        productCollectionModel = paymentMethodViewController.homeViewModel.latestProductCollectionModel
        brandProduct = paymentMethodViewController.homeViewModel.brandProduct
        
        bottomTableView.register(UINib(nibName: "SearchCategoryCell", bundle: nil), forCellReuseIdentifier: "SearchCategoryCell")
        bottomTableView.register(UINib(nibName: "SuggestionProductCell", bundle: nil), forCellReuseIdentifier: "SuggestionProductCell")
        bottomTableView.register(UINib(nibName: "SearchBrandTableViewCell", bundle: nil), forCellReuseIdentifier: "SearchBrandTableViewCell")
        bottomTableView.register(UINib(nibName: "RecentSearchTableCell", bundle: nil), forCellReuseIdentifier: "RecentSearchTableCell")
        
        if defaults.object(forKey: "recentsearch") != nil{
            recentSearchData = defaults.object(forKey: "recentsearch") as! NSArray
        }
        
        
        bottomTableView.delegate = self
        bottomTableView.dataSource = self
        bottomTableView.reloadData()
        suggestionTableViewHeight.constant = 200
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        searchBars.becomeFirstResponder();
        suggestionTableView.separatorColor = UIColor.clear
        cancelButton.title = "cancel".localized
    }
    
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            suggestionTableViewHeight.constant = SCREEN_HEIGHT - keyboardHeight - 120
            
        }
    }

    
    @IBAction func cancelSearcBar(_ sender: Any) {
        if isHome{
           navigationController?.popViewController(animated: true)
        }else{
           self.tabBarController!.selectedIndex = 0
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        suggestionTableView.isHidden = true
        if defaults.object(forKey: "recentsearch") != nil{
            recentSearchData = defaults.object(forKey: "recentsearch") as! NSArray
            if recentSearchData.count > 0{
                self.bottomTableView.reloadData()
            }
        }

        self.view.isUserInteractionEnabled = true
        self.navigationItem.setHidesBackButton(true, animated: false)
        navigationItem.titleView = searchBars
       
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationItem.titleView = nil
        self.navigationItem.setHidesBackButton(false, animated: false)
        NetworkManager.sharedInstance.removePreviousNetworkCall()
        NetworkManager.sharedInstance.dismissLoader()
        
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
                self.callingHttppApi()
                
            }
        }
    }
    
    
    func callingHttppApi(){
        self.view.isUserInteractionEnabled = false
        
        let sessionId = self.defaults.object(forKey:"wk_token");
        var requstParams = [String:Any]();
        requstParams["wk_token"] = sessionId;
        requstParams["search"] = searchtext;
        
        NetworkManager.sharedInstance.callingHttpRequest(params:requstParams, apiname:"catalog/searchSuggest",cuurentView:self){success,responseObject in
            if success == 1 {
                
                let dict = responseObject as! NSDictionary;
                if dict.object(forKey: "fault") != nil{
                    let fault = dict.object(forKey: "fault") as! Bool;
                    
                    if fault == true{
                        self.loginRequest()
                    }
                }else{
                    self.view.isUserInteractionEnabled = true
                    let resultDict : JSON = JSON(responseObject!)
                    if resultDict["error"].number == 1{
                        NetworkManager.sharedInstance.showWarningSnackBar(msg:resultDict["message"].stringValue)
                    }else{
                        self.searchSuggestionViewModel = SearchSuggestionViewModel(data: JSON(responseObject as! NSDictionary))
                        self.doFurtherProcessingWithResult()
                    }
                    
                }
            }else if success == 2{
                NetworkManager.sharedInstance.dismissLoader()
                self.callingHttppApi()
            }
        }
        
    }

    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        if section == 0{
            return 0
        }else{
            return 20
        }
        
    }
    

    
    func doFurtherProcessingWithResult(){
        if searchSuggestionViewModel.getSuggestedHints.count > 0{
            suggestionTableView.isHidden = false
            searchBars.isLoading = false
            suggestionTableView.delegate = self
            suggestionTableView.dataSource = self
            suggestionTableView.reloadData()
        }else{
            searchBars.isLoading = false
            suggestionTableView.isHidden = true;
        }
 
    }
    
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count > 0{
            searchBar.isLoading = true
            searchtext = searchText;
            NetworkManager.sharedInstance.removePreviousNetworkCall()
            callingHttppApi()
        }else{
            searchBar.isLoading = false
            suggestionTableView.isHidden = true;
        }

    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchQuery = searchBar.text!
        if searchQuery.count > 0{
            
            if defaults.object(forKey: "recentsearch") != nil{
                let storeData = defaults.object(forKey: "recentsearch") as! NSArray
                if !storeData.contains(self.searchQuery){
                var local:NSArray = [self.searchQuery]
                local = local.addingObjects(from:storeData as! [Any]) as NSArray
                self.defaults.set(local, forKey: "recentsearch")
                self.defaults.synchronize()
                }
            }else{
                let local:NSArray = [self.searchQuery]
                self.defaults.set(local, forKey: "recentsearch")
                self.defaults.synchronize()
            }
            categoryType = "search"
            categoryId = ""
            self.performSegue(withIdentifier:"productcategory" , sender: self)
           
        }
        
        
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar){
        navigationController?.popViewController(animated: true)
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int{
        if tableView == bottomTableView{
             return 4
        }else{
          return 1
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if tableView == bottomTableView{
            if section == 0{
                if recentSearchData.count > 0{
                    return 1
                }else{
                    return 0
                }
            }else if section == 1{
                if cataegoriesCollectionModel.count > 0{
                    return 1
                }else{
                    return 0
                }
            }else if section == 2{
                if productCollectionModel.count > 0{
                    return 1
                }else{
                    return 0
                }
            }else if section == 3{
                if brandProduct.count > 0{
                    return 1
                }else{
                    return 0
                }
            }else{
              return  0
            }
       
        }else{
           return searchSuggestionViewModel.getSuggestedHints.count
        }
        
    
    }
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == bottomTableView{
            if indexPath.section == 0{
             let cell:RecentSearchTableCell = tableView.dequeueReusableCell(withIdentifier: "RecentSearchTableCell") as! RecentSearchTableCell
             cell.recentSearchData = self.recentSearchData
             cell.clearButton.addTarget(self, action: #selector(clearAllClick(sender:)), for: .touchUpInside)
             cell.delegate = self
             cell.collectionView.reloadData()
             return cell
            }
           else if indexPath.section == 1{
            let cell:SearchCategoryCell = tableView.dequeueReusableCell(withIdentifier: "SearchCategoryCell") as! SearchCategoryCell
            cell.featureCategoryCollectionModel = cataegoriesCollectionModel
            cell.delegate = self
            cell.collectionView.reloadData()
             return cell
            }else if indexPath.section == 2 {
                let cell:SuggestionProductCell = tableView.dequeueReusableCell(withIdentifier: "SuggestionProductCell") as! SuggestionProductCell
                cell.productCollectionModel = self.productCollectionModel
                cell.delegate = self
                cell.collectionView.reloadData()
                return cell
            }else{
                let cell:SearchBrandTableViewCell = tableView.dequeueReusableCell(withIdentifier: "SearchBrandTableViewCell") as! SearchBrandTableViewCell
                cell.brandCollectionModel = self.brandProduct
                cell.delegate = self
                 cell.collectionView.reloadData()
                return cell
            }
        }else{
            let cell:UITableViewCell = UITableViewCell(style:UITableViewCell.CellStyle.subtitle, reuseIdentifier:"cell")
            cell.textLabel?.font = UIFont(name: REGULARFONT, size: 12)
            cell.detailTextLabel?.font = UIFont(name: BOLDFONT, size: 12)
            cell.detailTextLabel?.text = searchSuggestionViewModel.getSuggestedHints[indexPath.row].label
            cell.detailTextLabel?.textColor = UIColor().HexToColor(hexString: LIGHTGREY)
            cell.backgroundColor = UIColor.white.withAlphaComponent(1)
            cell.detailTextLabel?.halfTextColorChange(fullText:searchSuggestionViewModel.getSuggestedHints[indexPath.row].label , changeText: searchtext)
           return cell
        }
  
       
    }

    
    @objc func clearAllClick(sender: UIButton){
        let AC = UIAlertController(title: "warning".localized, message: "searchemptyinfo".localized, preferredStyle: .alert)
        let ok = UIAlertAction(title: "yes".localized, style: .default, handler: {(_ action: UIAlertAction) -> Void in
            self.defaults.removeObject(forKey:"recentsearch")
            self.recentSearchData = []
            self.bottomTableView.reloadData()
            
        })
        let noBtn = UIAlertAction(title: "no".localized, style: .destructive, handler: {(_ action: UIAlertAction) -> Void in
        })
        AC.addAction(ok)
        AC.addAction(noBtn)
        self.present(AC, animated: true, completion:nil)

    
    }
    
    
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat{
            return 30
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
         if tableView == bottomTableView{
            if indexPath.section == 0{
                return 140
            }
            else if indexPath.section == 1{
                return 60
            }else if indexPath.section == 2{
                return SCREEN_WIDTH/2 + 110
            }else{
                return 110
            }
        
         }else{
            return 60;
        }
    }
   

    
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if tableView == bottomTableView{
        
        if section == 1{
            return "categories".localized
        }else if section == 2{
            if productCollectionModel.count > 0{
               return "newproduct".localized
            }else{
                return ""
            }
        }else if section == 3{
            if brandProduct.count > 0{
                return "popularbrand".localized
            }else{
                return ""
            }
        }else{
          return ""
        }
        }
        else{
            if searchSuggestionViewModel.getSuggestedHints.count > 0{
                    return "searchresult".localized
            }else{
                return ""
            }
        }
        
        
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView == suggestionTableView{
            self.productName = searchSuggestionViewModel.getSuggestedHints[indexPath.row].label
            self.productId = searchSuggestionViewModel.getSuggestedHints[indexPath.row].productID
            self.performSegue(withIdentifier: "catalogproduct", sender: self)
        }
    }
    
    
    
    
    func categoryProductClick(name:String,ID:String,isChild:Bool){
        categoryId = ID
        categoryName = name
        categoryType = ""
        if isChild{
            self.performSegue(withIdentifier: "subcategory", sender: self);
        }else{
            self.performSegue(withIdentifier: "productcategory", sender: self);
        }
    }
    
    
    func productClick(name:String,image:String,id:String){
        self.imageUrl = image
        self.productName = name
        self.productId = id
        self.performSegue(withIdentifier: "catalogproduct", sender: self)
    }
    
    
    func brandProductClick(name:String,ID:String){
        categoryId = ID
        categoryName = name
        categoryType = "manufacture"
        self.performSegue(withIdentifier: "productcategory", sender: self);
    }
    
    
    func recentTextClick(data:String){
        categoryType = "search"
        categoryName = NetworkManager.sharedInstance.language(key: "searchresult")
        categoryId = ""
        searchQuery = data
        self.performSegue(withIdentifier:"productcategory" , sender: self)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         if (segue.identifier! == "productcategory") {
            self.view.endEditing(true)
            let viewController:Productcategory = segue.destination as UIViewController as! Productcategory
            viewController.categoryId = categoryId
            viewController.categoryName = NetworkManager.sharedInstance.language(key: "searchresult")
            viewController.categoryType = self.categoryType;
            viewController.searchQuery = searchQuery;
        }else if (segue.identifier == "subcategory") {
            let viewController:subCategory = segue.destination as UIViewController as! subCategory
            viewController.subName = categoryName
            viewController.subId = categoryId
            
            
        }else if (segue.identifier! == "catalogproduct") {
            let viewController:CatalogProduct = segue.destination as UIViewController as! CatalogProduct
            viewController.productImageUrl = self.imageUrl
            viewController.productId = self.productId
            viewController.productName = self.productName
            viewController.productPrice = ""
            
        }


    }
    
    
    
    
}



