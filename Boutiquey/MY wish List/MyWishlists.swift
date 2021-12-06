//
//  MyWishlists.swift
//  OpenCartApplication
//
//  Created by shobhit on 24/08/17.
//  Copyright © 2017 webkul. All rights reserved.
//

import UIKit

class MyWishlists: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var wishlistsTableView: UITableView!
    
    let defaults = UserDefaults.standard
    var myWishlistsViewModel:MyWishlistsViewModel!
    var productId:String = ""
    var whichApiToProcess:String = ""
    var productName:String!
    var productPrice:String!
    var imageUrl:String!
    var refreshControl:UIRefreshControl!
    var emptyView:EmptyNewAddressView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = false
        self.title = NetworkManager.sharedInstance.language(key: "mywishlist")
        
        //pull to refresh
        refreshControl = UIRefreshControl()
        let attributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        let attributedTitle = NSAttributedString(string: NetworkManager.sharedInstance.language(key: "pulltorefresh"), attributes: attributes)
        refreshControl.attributedTitle = attributedTitle
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        if #available(iOS 10.0, *) {
            wishlistsTableView.refreshControl = refreshControl
        } else {
            wishlistsTableView.backgroundView = refreshControl
        }
        
        whichApiToProcess = ""
        self.wishlistsTableView.separatorStyle = .none
        callingHttppApi()
        emptyView = EmptyNewAddressView(frame: self.view.frame);
        self.view.addSubview(emptyView)
        emptyView.isHidden = true;
        emptyView.emptyImages.image = UIImage(named: "empty_wishlist")!
        emptyView.addressButton.setTitle(NetworkManager.sharedInstance.language(key: "gotohome"), for: .normal)
        emptyView.labelMessage.text = NetworkManager.sharedInstance.language(key: "emptywishlist")
        emptyView.addressButton.addTarget(self, action: #selector(browseCategory(sender:)), for: .touchUpInside)
        
    }
    
    @objc func browseCategory(sender: UIButton){
        self.tabBarController!.selectedIndex = 0
    }
    
    //MARK:- Pull to refresh
    @objc func refresh(_ refreshControl: UIRefreshControl) {
        self.refreshControl.endRefreshing()
        
        whichApiToProcess = ""
        callingHttppApi()
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
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    
    func callingHttppApi(){
        self.view.isUserInteractionEnabled = false
        NetworkManager.sharedInstance.showLoader()
        
        let sessionId = self.defaults.object(forKey:"wk_token");
        var requstParams = [String:Any]();
        requstParams["wk_token"] = sessionId;
        if whichApiToProcess == "delete"{
            requstParams["product_id"] = productId;
            NetworkManager.sharedInstance.callingHttpRequest(params:requstParams, apiname:"customer/removeFromWishlist", cuurentView: self){success,responseObject in
                
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
                        if dict.object(forKey: "error") as! Int == 0{
                            self.whichApiToProcess = ""
                            self.callingHttppApi()
                        }
                    }
                }else if success == 2{
                    NetworkManager.sharedInstance.dismissLoader()
                    self.callingHttppApi();
                }
            }
            
        }else if whichApiToProcess == "addtocart"{
            requstParams["product_id"] = productId;
            requstParams["quantity"] = "1"
            NetworkManager.sharedInstance.callingHttpRequest(params:requstParams, apiname:"cart/addToCart", cuurentView: self){success,responseObject in
                
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
                        if dict.object(forKey: "error") as! Int == 0{
                            NetworkManager.sharedInstance.showSuccessSnackBar(msg: dict.object(forKey: "message") as! String)
                            let data = dict.object(forKey: "total") as! String
                            self.tabBarController!.tabBar.items?[3].badgeValue = data.components(separatedBy: " ")[0]
                            
                        }else{
                            NetworkManager.sharedInstance.showErrorMessage(view: self, message:dict.object(forKey: "message") as! String)
                        }
                    }
                }else if success == 2{
                    NetworkManager.sharedInstance.dismissLoader()
                    self.callingHttppApi();
                }
            }
            
        }
        else{
            let width = String(format:"%f", SCREEN_WIDTH * UIScreen.main.scale)
            requstParams["width"] = width
            NetworkManager.sharedInstance.callingHttpRequest(params:requstParams, apiname:"customer/getWishlist", cuurentView: self){success,responseObject in
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
                            self.myWishlistsViewModel = MyWishlistsViewModel(data: JSON(responseObject as! NSDictionary))
                            self.doFurtherProcessingWithResult()
                            NetworkManager.sharedInstance.showWarningSnackBar(msg:resultDict["message"].stringValue)
                        }else{
                            self.myWishlistsViewModel = MyWishlistsViewModel(data: JSON(responseObject as! NSDictionary))
                            self.doFurtherProcessingWithResult()
                        }
                        
                    }
                }else if success == 2{
                    NetworkManager.sharedInstance.dismissLoader()
                    self.callingHttppApi();
                }
            }
        }
        
    }
    
    
    
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    
    func doFurtherProcessingWithResult(){
        DispatchQueue.main.async {
            if self.myWishlistsViewModel.getWishlistsData.count > 0{
                self.wishlistsTableView.delegate = self
                self.wishlistsTableView.dataSource = self
                self.wishlistsTableView.reloadData()
                self.wishlistsTableView.isHidden = false
                self.emptyView.isHidden = true
            }else{
                self.wishlistsTableView.isHidden = true
                self.emptyView.isHidden = false
            }
            
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let addToCart = UITableViewRowAction(style: .normal, title: "addtocart".localized) { action, index in
            self.productId = self.myWishlistsViewModel.getWishlistsData[indexPath.row].productId
            if self.myWishlistsViewModel.getWishlistsData[indexPath.row].hasOption == 1{
                self.productName = self.myWishlistsViewModel.getWishlistsData[indexPath.row].name
                self.productPrice = self.myWishlistsViewModel.getWishlistsData[indexPath.row].price
                self.imageUrl = self.myWishlistsViewModel.getWishlistsData[indexPath.row].imageUrl
                self.performSegue(withIdentifier: "mywistlisttoproduct", sender: self)
            }else{
                self.whichApiToProcess = "addtocart";
                self.callingHttppApi()
            }
            
        }
        addToCart.backgroundColor = UIColor().HexToColor(hexString: BUTTON_COLOR)
        
        
        let delete = UITableViewRowAction(style: .normal, title: "delete".localized) { action, index in
            self.productId = self.myWishlistsViewModel.getWishlistsData[indexPath.row].productId
            self.whichApiToProcess = "delete";
            self.callingHttppApi()
            
        }
        delete.backgroundColor = UIColor.red
        
        return [delete,addToCart]
        
    }
    
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.myWishlistsViewModel.getWishlistsData.count;
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "wishlistsCell", for: indexPath) as! WishlistsTableViewCell
        
        cell.productNameLbl.text = self.myWishlistsViewModel.getWishlistsData[indexPath.row].name
        cell.productPriceLbl.text = self.myWishlistsViewModel.getWishlistsData[indexPath.row].price
        cell.stockAvailabilityLbl.text = "stock".localized+" "+self.myWishlistsViewModel.getWishlistsData[indexPath.row].stockAvailability
        let imgUrl : String = self.myWishlistsViewModel.getWishlistsData[indexPath.row].imageUrl
        cell.productImageView.image = UIImage(named: "ic_placeholder.png")
      
        
        cell.productImageView.loadImageFrom(url:imgUrl , dominantColor: "ffffff")
        
        
        if self.myWishlistsViewModel.getWishlistsData[indexPath.row].specialPrice != 0  && (self.myWishlistsViewModel.getWishlistsData[indexPath.row].specialPrice) > 0{
            cell.specialPriceLbl.isHidden = false;
            cell.productPriceLbl.text =  self.myWishlistsViewModel.getWishlistsData[indexPath.row].formatted_special
            let attributeString = NSMutableAttributedString(string: self.myWishlistsViewModel.getWishlistsData[indexPath.row].price)
            attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 1, range: NSRange(location: 0, length: attributeString.length))
            cell.specialPriceLbl.attributedText = attributeString
        }
        
        
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        productId = self.myWishlistsViewModel.getWishlistsData[indexPath.row].productId
        productName = self.myWishlistsViewModel.getWishlistsData[indexPath.row].name
        productPrice = self.myWishlistsViewModel.getWishlistsData[indexPath.row].price
        imageUrl = self.myWishlistsViewModel.getWishlistsData[indexPath.row].imageUrl
        self.performSegue(withIdentifier: "mywistlisttoproduct", sender: self)
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 150
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier! == "mywistlisttoproduct") {
            let viewController:CatalogProduct = segue.destination as UIViewController as! CatalogProduct
            viewController.productImageUrl = imageUrl
            viewController.productId = self.productId
            viewController.productName = self.productName
            viewController.productPrice = self.productPrice
            
        }
    }
    
    
    
}
