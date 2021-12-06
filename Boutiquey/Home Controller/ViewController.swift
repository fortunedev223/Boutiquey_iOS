//
//  ViewController.swift
//  OpenCartMpV3
//
//  Created by kunal on 11/12/17.
//  Copyright © 2017 kunal. All rights reserved.
//

import UIKit
import LMCSideMenu

class ViewController: UIViewController,LMCSideMenuCenterControllerProtocol, UISearchBarDelegate,CategoryViewControllerHandlerDelegate,BrandViewControllerHandlerDelegate,productViewControllerHandlerDelegate,bannerViewControllerHandlerDelegate,UITabBarControllerDelegate, RecentProductViewControllerHandlerDelegate{
    var interactor: MenuTransitionInteractor = MenuTransitionInteractor()
    
    
    @IBOutlet weak var homeTableView: UITableView!
//    @IBOutlet weak var searchBar: UISearchBar!
    
    var homeViewModel:HomeViewModel!
    var categoryId:String = ""
    var categoryName:String = ""
    var categoryType:String = ""
    var productName:String = ""
    var imageUrl:String = ""
    var productId:String = ""
    var launchView:UIViewController!
    var refreshControl:UIRefreshControl!
    var responseObject : AnyObject!
    var subCategory:NSArray = []
    var homeData : JSON!
    var dataBaseObject:AllDataCollection!
    var apiCallingType:APICallingType = .NONE
    var isHomeRefreshed:Bool = false
    static var selfVC : ViewController!
    static var countofcart : String = ""
    @IBOutlet var visualEffectView: UIVisualEffectView!
    var notificationButton = SSBadgeButton()
    var countofcart:String = ""
    let defaults = UserDefaults.standard
    
    var footer_description : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let storyboard = UIStoryboard(name: "Main", bundle: nil)

        let leftMenuController = storyboard.instantiateViewController(withIdentifier: String(describing: LeftMenuController.self)) as! LeftMenuController
        let rightMenuController = storyboard.instantiateViewController(withIdentifier: String(describing: RightMenuController.self)) as! RightMenuController

        //Setup menu
        setupMenu(leftMenu: leftMenuController, rightMenu: rightMenuController)
//        MenuHelper.set(menuWidth: 0.8)

        //enable screen edge gestures if needed
        if(self.defaults.object(forKey: "language") as? String == "ar"){
//        if sharedPrefrence.object(forKey: "language") as? String == "ar"{
            disableLeftMenuGesture()
            enableRightMenuGesture()
           
        }else {
            enableLeftMenuGesture()
            disableRightMenuGesture()

        }
        if self.defaults.object(forKey: "language") as? String == "en-gb" {
            self.tabBarController?.delegate = self
            tabBarController?.tabBar.items?[0].title = "Home"
            tabBarController?.tabBar.items?[1].title = "Category"
            tabBarController?.tabBar.items?[2].title = "Notification"
            tabBarController?.tabBar.items?[3].title = "Profile"
        } else if self.defaults.object(forKey: "language") as? String != "en-gb"{
            self.tabBarController?.delegate = self
            tabBarController?.tabBar.items?[0].title = "الصفحة الرئيسية"
            tabBarController?.tabBar.items?[1].title = "الفئة"
            tabBarController?.tabBar.items?[2].title = "إعلام"
            tabBarController?.tabBar.items?[3].title = "الملف الشخصي"
            
        }
        
        
        
        notificationButton.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
        notificationButton.setImage(UIImage(named: "ic_cart")?.withRenderingMode(.alwaysTemplate), for: .normal)
        notificationButton.badgeEdgeInsets = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 10)
        
        notificationButton.addTarget(self, action: #selector(ViewController.gotoAddToCart(_:)), for: .touchUpInside)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: notificationButton)
        
        ViewController.selfVC = self
//        searchBar.isHidden = true
        homeViewModel  = HomeViewModel()
        dataBaseObject = AllDataCollection()
        self.homeViewModel.homeViewController = self
        let sessionId = sharedPrefrence.object(forKey:"wk_token")
        homeTableView?.register(BannerTableViewCell.nib, forCellReuseIdentifier: BannerTableViewCell.identifier)
        homeTableView?.register(TopCategoryTableViewCell.nib, forCellReuseIdentifier: TopCategoryTableViewCell.identifier)
        homeTableView?.register(ProductTableViewCell.nib, forCellReuseIdentifier: ProductTableViewCell.identifier)
        homeTableView?.register(BrandTableViewCell.nib, forCellReuseIdentifier: BrandTableViewCell.identifier)
        homeTableView?.register(RecentViewTableViewCell.nib, forCellReuseIdentifier: RecentViewTableViewCell.identifier)
        GlobalVariables.hometableView = homeTableView
        
        self.homeTableView?.dataSource = homeViewModel
        self.homeTableView?.delegate = homeViewModel
        homeTableView.rowHeight = UITableView.automaticDimension
        self.homeTableView.estimatedRowHeight = 100
        self.homeTableView.separatorColor = UIColor.clear
//        searchBar.delegate = self
        
        
        self.navigationController?.isNavigationBarHidden = true
        self.tabBarController?.tabBar.isHidden = true
        let launchScreen = UIStoryboard(name: "LaunchScreen", bundle: nil)
        launchView = launchScreen.instantiateInitialViewController()
        if let imageView =  launchView.view.viewWithTag(999) as? UIImageView{
            imageView.layer.cornerRadius = 5;
            imageView.layer.masksToBounds = true
            if let data =  NetworkManager.sharedInstance.getAppIcon(){
                 imageView.image = data
            }
        }
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.pushNotificationReceivedProductTap), name: NSNotification.Name(rawValue: "pushNotificationforProductOnTap"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.pushNotificationReceivedCategoryTap), name: NSNotification.Name(rawValue: "pushNotificationforCategoryOnTap"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.pushNotificationReceivedCustomCategoryTap), name: NSNotification.Name(rawValue: "pushNotificationforCustomCategoryOnTap"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.refreshPageRecentView), name: NSNotification.Name(rawValue: "refreshRecentView"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.pushNotificationOtherTap), name: NSNotification.Name(rawValue: "pushNotificationforOtherOnTap"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.goToCart), name: NSNotification.Name(rawValue: "shortcutcarttap"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.goToSearch), name: NSNotification.Name(rawValue: "shortcutsearchtap"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.goToWishList), name: NSNotification.Name(rawValue: "shortcutwishlisttap"), object: nil)
        
        
        refreshControl = UIRefreshControl()
        
    
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        if #available(iOS 10.0, *) {
            homeTableView.refreshControl = refreshControl
        } else {
            homeTableView.backgroundView = refreshControl
        }
        

        ThemeManager.applyTheme(bar:(self.navigationController?.navigationBar)!)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor().HexToColor(hexString: NAVIGATION_TINTCOLOR)]
        navigationController?.navigationBar.tintColor = UIColor().HexToColor(hexString: NAVIGATION_TINTCOLOR)
        
        
        self.setupTableFooterView()
       // searchBar.isHidden = false
        self.view.addSubview(launchView!.view)
        self.navigationItem.title = NetworkManager.sharedInstance.language(key: "applicationname")
       // searchBar.placeholder = NetworkManager.sharedInstance.language(key: "searchentirestore")
        if let Appname = launchView.view.viewWithTag(998) as? UILabel{
            Appname.text = "applicationname".localized
            Appname.textColor = UIColor.init(patternImage:#imageLiteral(resourceName: "newProduct"))
            Appname.startBlink()
        }
        
        visualEffectView.layer.cornerRadius = 5;
        visualEffectView.layer.masksToBounds = true
        visualEffectView.isHidden = true
        if(sessionId == nil){
            loginRequest()
        }else{
           self.callingHttppApi()
        }
       
        
    }

    
    @IBAction func gotoAddToCart(_ sender:UIButton!) {
        // do cool stuff here
        print("gotoAddToCart")
//        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//        let balanceViewController = storyBoard.instantiateViewController(withIdentifier: "mycart") as! MyCart
//        self.present(balanceViewController, animated: true, completion: nil
        performSegue(withIdentifier: "mycart", sender: self)
    }
    
    
    
    
    func setupTableFooterView() {
        
        guard let historyToolBarView = Bundle.main.loadNibNamed("BottomMoveToTopTableView", owner: nil, options: nil)![0] as? BottomMoveToTopTableView else { return }
        historyToolBarView.tableView = self.homeTableView
        
        // Create a container of your footer view called footerView and set it as a tableFooterView
        let footerView = UIView(frame: CGRect.init(x: 0, y: 0, width: self.homeTableView.frame.width, height: historyToolBarView.frame.height))
        homeTableView.tableFooterView = footerView
        
        // Add your footer view to the container
        footerView.addSubview(historyToolBarView)
    }
    
   
    
    
    
    func getHomeOfflineData(data:AnyObject){
         if let storeData = data as? JSON{
        let productModel = ProductViewModel()
          self.homeViewModel.getData(data: storeData, recentViewData : productModel.getProductDataFromDB()){(data : Bool) in
             if data {
                 self.homeTableView.reloadDataWithAutoSizingCellWorkAround()
                 self.launchView!.view.removeFromSuperview()
                 self.navigationController?.isNavigationBarHidden = false
                 self.tabBarController?.tabBar.isHidden = false
                 if let refreshControl = self.refreshControl{
                   refreshControl.endRefreshing()
                 }

               }
            }
            
        }

    }
    
    
    
    
    @IBAction func openSideMenu(_ sender: Any) {
        
        if(self.defaults.object(forKey: "language") as! String != "ar"){
            presentLeftMenu()
        }else {
            presentRightMenu()
        }
        
    }
    
    @objc func goToSearch(_ note: Notification) {
        self.tabBarController?.selectedIndex = 1
    }
    
    
    @objc func goToCart(_ note: Notification) {
        self.tabBarController?.selectedIndex = 3
    }
    
    @objc func goToWishList(_ note: Notification) {
        let customerId = sharedPrefrence.object(forKey: "customer_id")

        if(customerId == nil){
            let AC = UIAlertController(title: NetworkManager.sharedInstance.language(key: "warning"), message: NetworkManager.sharedInstance.language(key: "loginrequiredtoseewishlist"), preferredStyle: .alert)
            let okBtn = UIAlertAction(title: NetworkManager.sharedInstance.language(key: "ok"), style: .default, handler: {(_ action: UIAlertAction) -> Void in
            })
            AC.addAction(okBtn)
            self.present(AC, animated: true, completion: nil)
        }else{
            self.tabBarController!.selectedIndex = 0
            self.performSegue(withIdentifier: "mywishlist", sender: "self")
        }
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        self.view.isUserInteractionEnabled = true
        DBManager.sharedInstance.getJSONDatafromDatabase(ApiName: "common/getHomepage", taskCallback: { (val, data) in
         if val{
                if !self.isHomeRefreshed{
                   self.getHomeOfflineData(data: data as AnyObject)
             }
            }
        })
        
        
    }
    
    //Refresh page for Recent View
    @objc func refreshPageRecentView()    {
        let productModel = ProductViewModel()
        
        homeViewModel  = HomeViewModel()
        self.homeViewModel.homeViewController = self
        self.homeTableView?.dataSource = homeViewModel
        self.homeTableView?.delegate = homeViewModel
        
        if homeData != nil {
            self.homeViewModel.getData(data: homeData, recentViewData : productModel.getProductDataFromDB()) {
                (data : Bool) in
                if data {
                    self.homeTableView.reloadData()
                }
            }
        }
    }
    
    @objc func refresh(_ refreshControl: UIRefreshControl) {
        callingHttppApi()
    }
    
    @objc func pushNotificationReceivedProductTap(_ note: Notification) {
        var root  = note.userInfo
        productName = root?["title"] as! String
        productId = root?["id"] as! String
        self.performSegue(withIdentifier: "catalogproduct", sender: self);
    }
    
    
    @objc func pushNotificationReceivedCategoryTap(_ note: Notification) {
        var root  = note.userInfo
        categoryId = root?["id"] as! String
        categoryName = root?["title"] as! String
        categoryType = "";
        self.performSegue(withIdentifier: "productcategory", sender: self);
        
    }
    
    
    
    @objc func pushNotificationReceivedCustomCategoryTap(_ note: Notification) {
        var root  = note.userInfo
        categoryId = root?["id"] as! String
        categoryName = root?["title"] as! String
        categoryType = "custom";
        self.performSegue(withIdentifier: "productcategory", sender: self);
        
    }
    
    @objc func pushNotificationOtherTap(_ note: Notification) {
        var root  = note.userInfo
        let title:String = root?["title"] as! String
        let content =  root?["content"] as! String
        let AC = UIAlertController(title: title, message: content, preferredStyle: .alert) // content.htmltostring
        let okBtn = UIAlertAction(title: NetworkManager.sharedInstance.language(key: "retry"), style: .default, handler: {(_ action: UIAlertAction) -> Void in
        })
        
        AC.addAction(okBtn)
        self.present(AC, animated: true, completion: nil)
        
    }
    
    func tabBarController(_ tabBarController: UITabBarController,
                          shouldSelect viewController: UIViewController) -> Bool {
        NetworkManager.sharedInstance.removePreviousNetworkCall()
        NetworkManager.sharedInstance.dismissLoader()
        
        if let refreshControl = self.refreshControl{
           refreshControl.endRefreshing()
           
        }
        
        return true
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        let tabitem: Int = tabBarController.selectedIndex
        let navigation:UINavigationController = tabBarController.viewControllers?[tabitem] as! UINavigationController
        navigation.popToRootViewController(animated: true)
        
        if tabitem != 2{
            let navigation:UINavigationController = tabBarController.viewControllers?[2] as! UINavigationController
            navigation.popToRootViewController(animated: true)
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
                }else{
                let AC = UIAlertController(title: "error".localized, message: "inavalidkeyandpassword".localized, preferredStyle: .alert)
                self.present(AC, animated: true, completion: nil)
                    
                }
            }else if val == 2{
                NetworkManager.sharedInstance.dismissLoader()
                self.loginRequest()
            }
        }
    }
    
    func callingHttppApi(){
        DispatchQueue.main.async{
            let sessionId = sharedPrefrence.object(forKey:"wk_token");
            var requstParams = [String:Any]()
            requstParams["wk_token"] = sessionId
            requstParams["width"] = SCREEN_WIDTH
            requstParams["count"] = "10"
            if !self.refreshControl.isRefreshing{
                self.visualEffectView.isHidden = false
            }
            
            
            
            NetworkManager.sharedInstance.callingHttpRequest(params:requstParams, apiname:"common/getHomepage", cuurentView: self){val,responseObject in
                if val == 1 {
                    self.view.isUserInteractionEnabled = true
                    let dict = JSON(responseObject as! NSDictionary)
                    if dict["fault"].intValue == 1{
                            self.loginRequest()
                    }else{
                        self.homeData = dict
                        if let refreshControl = self.refreshControl{
                             refreshControl.endRefreshing()
                        }
                        let productModel = ProductViewModel()
                        
                        self.homeViewModel.getData(data: dict, recentViewData : productModel.getProductDataFromDB()) {
                            (data : Bool) in
                            if data {
                                self.homeTableView.reloadDataWithAutoSizingCellWorkAround()
                                self.visualEffectView.isHidden = true
                                UIView.animate(withDuration: 1, animations: {
                                    let imageView =  self.launchView.view.viewWithTag(999) as? UIImageView
                                    imageView?.transform = CGAffineTransform(scaleX: 1.7, y: 1.7)
                                    imageView?.alpha = 0.0;
                                }) { _ in
                                    self.launchView!.view.removeFromSuperview()
                                    self.navigationController?.isNavigationBarHidden = false
                                    self.tabBarController?.tabBar.isHidden = false
                                    
                                }
                                
                                // store the data to data base
                                if let data = NetworkManager.sharedInstance.json(from: responseObject as! NSDictionary){
//                                    print(data["footerMenu"])
                                    DBManager.sharedInstance.storeDataToDataBase(data: data, ApiName: "common/getHomepage", dataBaseObject: self.dataBaseObject)
                                }
                                
                                if self.homeViewModel.guestCheckOut == true{
                                    sharedPrefrence.set("true", forKey: "guest");
                                }else{
                                    sharedPrefrence.set("false", forKey: "guest");
                                }
                                if self.homeViewModel.cartCount > 0{
                                   // self.tabBarController!.tabBar.items?[2].badgeValue
                                    self.notificationButton.badge = "\(self.homeViewModel.cartCount)"
                                    self.countofcart = "\(self.homeViewModel.cartCount)"
                                    NetworkManager.sharedInstance.updateCartShortCut(count:"\(self.homeViewModel.cartCount)" , succ: true)
                                }
                                sharedPrefrence.synchronize()
                                self.isHomeRefreshed = true
                            }
                            else{
                              
                            }
                        }}
                    
                }else if val == 2 {
                    NetworkManager.sharedInstance.dismissLoader()
                    self.visualEffectView.isHidden = true
                    self.callingHttppApi()
                    
                }else if val == 3{
                    let productModel = ProductViewModel()
                    self.homeData = responseObject as! JSON
                    self.homeViewModel.getData(data: responseObject as! JSON, recentViewData : productModel.getProductDataFromDB()){
                        (data : Bool) in
                        if data {
                            self.homeTableView.reloadDataWithAutoSizingCellWorkAround()
                            self.visualEffectView.isHidden = true
                            UIView.animate(withDuration: 1, animations: {
                                self.launchView?.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
                                self.launchView?.view.alpha = 0.0;
                            }) { _ in
                                if let Appname = self.launchView.view.viewWithTag(998) as? UILabel{
                                    Appname.stopBlink()
                                }
                                self.launchView!.view.removeFromSuperview()
                                self.navigationController?.isNavigationBarHidden = false
                                self.tabBarController?.tabBar.isHidden = false
                            }
                            
                            
                            
                            if self.homeViewModel.guestCheckOut == true{
                                sharedPrefrence.set("true", forKey: "guest");
                            }else{
                                sharedPrefrence.set("false", forKey: "guest");
                            }
                            sharedPrefrence.synchronize()
                            if let refreshControl = self.refreshControl{
                                refreshControl.endRefreshing()
                        
                            }
                        }
                        
                    }
                }
            }
        }
    }
    
    
    
    @IBAction func notificationClick(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "notification", sender: self)
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        view.endEditing(true)
        self.performSegue(withIdentifier: "search", sender: self)
    
    }
    
    func categoryProductClick(name:String,ID:String,isChild:Bool){
        
        categoryId = ID
        categoryName = name
        categoryType = ""
        print(categoryId)
        print(categoryName)
        print(isChild)
        if isChild{
            print("subcategory")
            self.performSegue(withIdentifier: "subcategory", sender: self);
        }else{
            print("productcategory")
            self.performSegue(withIdentifier: "productcategory", sender: self);
        }
    }
    
    
    
    
    func brandProductClick(name:String,ID:String){
        categoryId = ID
        categoryName = name
        categoryType = "manufacture"
        self.performSegue(withIdentifier: "productcategory", sender: self);
    }
    
    func productClick(name:String,image:String,id:String){
        self.imageUrl = image
        self.productName = name
        self.productId = id
        self.performSegue(withIdentifier: "catalogproduct", sender: self)
    }
    
    func bannerProductClick(type:String,image:String,id:String,title:String){
        if type == "category"{
            categoryId = id
            categoryName = title
            categoryType = ""
            self.performSegue(withIdentifier: "productcategory", sender: self)
        }else if type == "product"{
            self.imageUrl = ""
            self.productName = title
            self.productId = id
            self.performSegue(withIdentifier: "catalogproduct", sender: self)
        }
    }
    
   
    
    
    
    
    
    func viewAllClick(type:String){
        categoryName = ""
        categoryType = "crousal"
        categoryId = type
        self.performSegue(withIdentifier: "productcategory", sender: self);
    }
    
    //MARK:- Recent Views Delegate func
    func recentProductClick(name: String, image: String, id: String) {
        productName = name
        imageUrl = image
        productId = id
        self.performSegue(withIdentifier: "catalogproduct", sender: self)
    }
    
   

    
    
    
    //MARK:-
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier! == "catalogproduct") {
            let viewController:CatalogProduct = segue.destination as UIViewController as! CatalogProduct
            viewController.productImageUrl = self.imageUrl
            viewController.productId = self.productId
            viewController.productName = self.productName
            viewController.productPrice = ""
        }
        if (segue.identifier! == "productcategory") {
            let viewController:Productcategory = segue.destination as UIViewController as! Productcategory
            viewController.categoryId = categoryId
            viewController.categoryName = categoryName;
            viewController.categoryType = categoryType;
        }else if (segue.identifier! == "search") {
            let viewController:SearchSuggestion = segue.destination as UIViewController as! SearchSuggestion
            viewController.isHome = true;
        }else if (segue.identifier == "subcategory") {
            let viewController:subCategory = segue.destination as UIViewController as! subCategory
            viewController.subName = categoryName
            viewController.subId = categoryId
        }
    }
}




extension ViewController{
    func showLanguageOptionWindow(){
        let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LanguageChooseController") as! LanguageChooseController
        popOverVC.modalPresentationStyle = .overFullScreen
        popOverVC.modalTransitionStyle = .crossDissolve
        self.present(popOverVC, animated: true, completion: nil)
    }
    
    
    
}
