//
//  MyProfile.swift
//  Magento2MobikulNew
//
//  Created by Kunal Parsad on 17/08/17.
//  Copyright © 2017 Kunal Parsad. All rights reserved.
//

import UIKit
import LMCSideMenu

var languages1: NSMutableArray = []
var currencyData1: NSMutableArray = []


class MyProfile: UIViewController, LMCSideMenuCenterControllerProtocol,UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var interactor: MenuTransitionInteractor = MenuTransitionInteractor()
    
    @IBAction func openSideMenu(_ sender: Any) {
        if(self.defaults.object(forKey: "language") as! String != "ar"){
            presentLeftMenu()
        }else {
            presentRightMenu()
        }
    }
    var bannerImageView:UIImageView!
    var welcomeLabel:UILabel!
    var HeaderHeight = SCREEN_HEIGHT/3
    let defaults = UserDefaults.standard;
    var profileImageView:UIImageView!
    var headerTitleData: NSMutableArray = []
    var profileData:NSMutableArray = []
    var showUserDataFlag:Int = 0
    var myOrdersData:NSMutableArray = []
    
    var storeData:NSMutableArray = []
    var userProfileData: NSMutableArray = []
    var marketPlaceData:NSMutableArray = []
    var userLogout:NSMutableArray = []
    var languageCode:String = ""
    var whichApiToProcess:String = ""
    var currencyCode:String = ""
    var guestProfileData:NSMutableArray = []
    var currencyData  = [Currency]()
    var languageData = [Languages]()
    var showSellerProfile:Bool = false
    var productModel = ProductViewModel()
    var sinInView:NSMutableArray = [""]
    
    var notificationButton3 = SSBadgeButton()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let leftMenuController = storyboard.instantiateViewController(withIdentifier: String(describing: LeftMenuController.self)) as! LeftMenuController
        let rightMenuController = storyboard.instantiateViewController(withIdentifier: String(describing: RightMenuController.self)) as! RightMenuController
        
        //Setup menu
        setupMenu(leftMenu: leftMenuController, rightMenu: rightMenuController)
        //        MenuHelper.set(menuWidth: 0.8)
        
        //enable screen edge gestures if needed
        if(self.defaults.object(forKey: "language") as! String != "ar"){
            enableLeftMenuGesture()
            disableRightMenuGesture()
        }else {
            disableLeftMenuGesture()
            enableRightMenuGesture()
        }
        
        tableView.register(UINib(nibName: "ProfileCell", bundle: nil), forCellReuseIdentifier: "ProfileCell")
        tableView.register(UINib(nibName: "ProfileTableViewCell", bundle: nil), forCellReuseIdentifier: "ProfileTableViewCell")
        userProfileData = [NetworkManager.sharedInstance.language(key: "edityouraccountinfo"),NetworkManager.sharedInstance.language(key:"notification"),NetworkManager.sharedInstance.language(key: "changeyourpassword"),NetworkManager.sharedInstance.language(key: "modifyyouraddressbook"),NetworkManager.sharedInstance.language(key: "modifyyourwishlist")];
        myOrdersData = [NetworkManager.sharedInstance.language(key: "viewyourorderhistory"),NetworkManager.sharedInstance.language(key: "rewardpoints"),NetworkManager.sharedInstance.language(key: "yourreturnrequest"),NetworkManager.sharedInstance.language(key: "yourtransaction"),NetworkManager.sharedInstance.language(key: "mydownloads")];
        guestProfileData = [NetworkManager.sharedInstance.language(key: "signin"),NetworkManager.sharedInstance.language(key:"notification"),"setting".localized];
        userLogout = [NetworkManager.sharedInstance.language(key: "logout")];
        
        
        if isMarketPlace{
        if defaults.object(forKey: "partner") != nil{
            if defaults.object(forKey: "partner") as! String == "true"{
                showSellerProfile = true
                marketPlaceData = [NetworkManager.sharedInstance.language(key: "sell"),NetworkManager.sharedInstance.language(key: "sellerdashboard"),NetworkManager.sharedInstance.language(key: "sellerorder")]
            }else{
                showSellerProfile = false
                marketPlaceData = [NetworkManager.sharedInstance.language(key: "sell")];
            }
        }else{
            showSellerProfile = false
            marketPlaceData = [NetworkManager.sharedInstance.language(key: "sell")];
        }
        }
        
        
        profileData = [sinInView,guestProfileData,marketPlaceData,userProfileData,myOrdersData,userLogout];
        
        self.navigationItem.title = NetworkManager.sharedInstance.language(key: "guestprofile")
        
        bannerImageView = UIImageView(image: UIImage(named: "beverley"))
        
        let paymentViewNavigationController = self.tabBarController?.viewControllers?[0]
        let nav1 = paymentViewNavigationController as! UINavigationController;
        let paymentMethodViewController = nav1.viewControllers[0] as! ViewController
        currencyData = paymentMethodViewController.homeViewModel.currencyData
        languageData = paymentMethodViewController.homeViewModel.languageData
        
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        if(ViewController.selfVC.countofcart != ""){
            notificationButton3.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
            notificationButton3.setImage(UIImage(named: "ic_cart")?.withRenderingMode(.alwaysTemplate), for: .normal)
            notificationButton3.badgeEdgeInsets = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 10)
            notificationButton3.addTarget(self, action: #selector(self.gotoAddToCart(_:)), for: .touchUpInside)
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: notificationButton3)
            
            self.notificationButton3.badge = ViewController.selfVC.countofcart
        }
        
        self.view.isUserInteractionEnabled = true
        whichApiToProcess = ""
        
        if isMarketPlace{
        if defaults.object(forKey: "partner") != nil{
            if defaults.object(forKey: "partner") as! String == "true"{
                showSellerProfile = true
                marketPlaceData = [NetworkManager.sharedInstance.language(key: "sell"),NetworkManager.sharedInstance.language(key: "sellerdashboard"),NetworkManager.sharedInstance.language(key: "sellerorder")]
            }else{
                showSellerProfile = false
                marketPlaceData = [NetworkManager.sharedInstance.language(key: "sell")];
            }
        }else{
            showSellerProfile = false
            marketPlaceData = [NetworkManager.sharedInstance.language(key: "sell")];
        }
        }
        
        profileData = [sinInView,guestProfileData,marketPlaceData,userProfileData,myOrdersData,userLogout];
        if defaults.object(forKey: "customer_id") != nil{
//            self.navigationController?.isNavigationBarHidden = true
            showUserDataFlag = 1;
            self.navigationItem.title = ""
            tableView.delegate = self
            tableView.dataSource = self
            tableView.reloadData()
            //setUpUserView()
            
        }else{
            self.navigationItem.title = NetworkManager.sharedInstance.language(key: "guestprofile")
            self.navigationController?.isNavigationBarHidden = false
            showUserDataFlag = 0
            tableView.delegate = self
            tableView.dataSource = self
            tableView.reloadData()
        }
        
        
    }
    
    @IBAction func gotoAddToCart(_ sender:Any!) {
        // do cool stuff here
        print("gotoAddToCart")
        
        performSegue(withIdentifier: "mycart", sender: self)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return profileData.count
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 && showUserDataFlag == 1{
            return 250
        }else if indexPath.section == 0 && showUserDataFlag == 0{
            return 0
        }
        else{
            return UITableView.automaticDimension
        }
        
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNonzeroMagnitude
    }
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if showUserDataFlag == 1 && section == 0{
            return 1
        }else if showUserDataFlag == 0 && section == 0{
            return 0
        }else if showUserDataFlag == 0 && section == 1{
            return (profileData[section] as! NSMutableArray).count;
        }else if showUserDataFlag == 1 && section == 1{
            return 0;
        }else if section == 2 && showSellerProfile == true{
            return (profileData[section] as! NSMutableArray).count
        }else if showUserDataFlag == 1{
            return (profileData[section] as! NSMutableArray).count
        }
        else{
            return 0;
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 || section == 1{
            return CGFloat.leastNonzeroMagnitude
        }else if marketPlaceData.count == 0 && section == 2{
            return CGFloat.leastNonzeroMagnitude
        }else if showUserDataFlag == 0{
            return CGFloat.leastNonzeroMagnitude
        }
        else{
            return 20
        }
    }
    
    
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0{
            let cell:ProfileTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ProfileTableViewCell") as! ProfileTableViewCell
            cell.profileEmail.text = self.defaults.object(forKey:"email") as? String
            cell.profileName.text = self.defaults.object(forKey:"firstname") as? String
            let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(MyProfile.changeSetting))
            cell.editView.addGestureRecognizer(tap)
            return cell
            
        }else{
        let cell:UITableViewCell = UITableViewCell(style:.value1, reuseIdentifier:"cell")
        let sectionContents:NSMutableArray = profileData[indexPath.section] as! NSMutableArray
        let contentForThisRow  = sectionContents[indexPath.row]
        cell.textLabel?.text = contentForThisRow as? String
        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.font = UIFont(name: REGULARFONT, size: 15)
        cell.imageView?.layer.borderColor = UIColor.lightGray.cgColor
        cell.imageView?.backgroundColor = UIColor().HexToColor(hexString: BUTTON_COLOR)
        cell.imageView?.layer.cornerRadius = 4;
        cell.imageView?.clipsToBounds = true
        cell.selectionStyle = .none
        cell.imageView?.contentMode = .scaleAspectFit
        cell.textLabel?.alingment()
            
        if indexPath.section == 1{
            if indexPath.row == 0{
                cell.imageView?.image = UIImage(named: "ic_signin")!
            }else if indexPath.row == 1{
                cell.imageView?.image = UIImage(named: "ic_profile_notification")!
            }else if indexPath.row == 2{
                cell.imageView?.image = UIImage(named: "setting")!
            }
         
        }
        else if indexPath.section == 2{
            if indexPath.row == 0{
                cell.imageView?.image = UIImage(named: "ic_sell")!
            }else
                if indexPath.row == 1{
                    cell.imageView?.image = UIImage(named: "ic_selldashboard")!
                }else if indexPath.row == 2{
                    cell.imageView?.image = UIImage(named: "ic_sellerorder")!
            }
        }
        else if indexPath.section == 3{
            if indexPath.row == 0{
                cell.imageView?.image = UIImage(named: "ic_editaccountinfo")!
            }
            else if indexPath.row == 1{
                cell.imageView?.image = UIImage(named: "ic_profile_notification")!
            }
            else if indexPath.row == 2{
                cell.imageView?.image = UIImage(named: "ic_change_password")!
            }else if indexPath.row == 3{
                cell.imageView?.image = UIImage(named: "ic_addressbook")!
            }else if indexPath.row == 4{
                cell.imageView?.image = UIImage(named: "ic_profile_wishlist")!
            }
            
            
        }else if indexPath.section == 4{
            if indexPath.row == 0{
                cell.imageView?.image = UIImage(named: "ic_order")!
            }else if indexPath.row == 1{
                cell.imageView?.image = UIImage(named: "ic_reward")!
            }else if indexPath.row == 2{
                cell.imageView?.image = UIImage(named: "ic_return")!
            }else if indexPath.row == 3{
                cell.imageView?.image = UIImage(named: "ic_transaction")!
            }else if indexPath.row == 4{
                cell.imageView?.image = UIImage(named: "ic_downloadable")!
            }
            
            
        }
            
        else if indexPath.section == 5{
            if indexPath.row == 0{
                cell.imageView?.image = UIImage(named: "ic_loagout")!
            }
        }
          return cell
        }
    }
    
    
    @objc func changeSetting(){
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "AppSettingController") as? AppSettingController
        vc?.languageData = self.languageData
        vc?.currencyData = self.currencyData
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    
    
   
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      
        
        if indexPath.section == 1{
            if indexPath.row == 0{
                self.performSegue(withIdentifier: "customerLogin", sender: self)
            }else if indexPath.row == 1{
                self.performSegue(withIdentifier: "notification", sender: self)
            }else if indexPath.row == 2{
                self.changeSetting()
            }
        }else if indexPath.section == 2{
            if indexPath.row == 0{
                self.performSegue(withIdentifier: "sell", sender: self)
            }else
                if indexPath.row == 1{
                    self.performSegue(withIdentifier: "sellerdashboard", sender: self)
                }else if indexPath.row == 2{
                    self.performSegue(withIdentifier: "sellerorder", sender: self)
            }
        }else if indexPath.section == 3{
            if indexPath.row == 0{
                self.performSegue(withIdentifier: "myProfileToAccountInformation", sender: self)
            }else if indexPath.row == 1{
                self.performSegue(withIdentifier: "notification", sender: self)
            }else if indexPath.row == 2{
                self.performSegue(withIdentifier: "changePassword", sender: self)
            }else if indexPath.row == 3{
                self.performSegue(withIdentifier: "addressbook", sender: self)
            }else if indexPath.row == 4{
                self.performSegue(withIdentifier: "mywishlist", sender: self)
            }
        }else if indexPath.section == 4{
            if indexPath.row == 0{
                self.performSegue(withIdentifier: "orderhistory", sender: self)
            }else if indexPath.row == 1{
                self.performSegue(withIdentifier: "rewardpoints", sender: self)
            }else if indexPath.row == 2{
                self.performSegue(withIdentifier: "returnrequest", sender: self)
            }else if indexPath.row == 3{
                self.performSegue(withIdentifier: "yourtransaction", sender: self)
            }else if indexPath.row == 4{
                self.performSegue(withIdentifier: "mydownloads", sender: self)
            }
        }else if indexPath.section == 5{
            if indexPath.row == 0{
                let AC = UIAlertController(title: NetworkManager.sharedInstance.language(key: "message"), message: NetworkManager.sharedInstance.language(key: "logoutmessagewarning"), preferredStyle: .alert)
                let okBtn = UIAlertAction(title: NetworkManager.sharedInstance.language(key: "ok"), style: .default, handler: {(_ action: UIAlertAction) -> Void in
                    for key in UserDefaults.standard.dictionaryRepresentation().keys {  //guestcheckout
                        if(key.description == "wk_token"||key.description == "language"||key.description == "AppleLanguages" || key.description == "currency" || key.description == "guest" || key.description == "touchIdFlag" || key.description == "TouchEmailId" || key.description == "TouchPasswordValue" ) {
                            continue
                        }else{
                            UserDefaults.standard.removeObject(forKey: key.description)
                        }
                    }
                    
                    UserDefaults.standard.synchronize()
                    self.tabBarController!.tabBar.items?[2].badgeValue = nil
                    self.viewWillAppear(true)
                    NetworkManager.sharedInstance.updateCartShortCut(count:"", succ: false)
                    self.whichApiToProcess = ""
                    self.productModel.deleteAllRecentViewProductData()
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refreshRecentView"), object: nil)
                    NetworkManager.sharedInstance.showSuccessSnackBar(msg:NetworkManager.sharedInstance.language(key: "logoutmessage"))
                    self.callingHttppApi()
                })
                let noBtn = UIAlertAction(title: NetworkManager.sharedInstance.language(key: "cancel"), style: .destructive, handler: {(_ action: UIAlertAction) -> Void in
                })
                AC.addAction(okBtn)
                AC.addAction(noBtn)
                self.present(AC, animated: true, completion: nil)
            }
        }
    }
    
    func showCurrency(){
        let alert = UIAlertController(title: NetworkManager.sharedInstance.language(key: "chooseyourcurrency"), message: nil, preferredStyle: .actionSheet)
        for i in 0..<self.currencyData.count {
            var image = UIImage(named: "")
            if sharedPrefrence.object(forKey: "currency") != nil{
                let currencyCode = sharedPrefrence.object(forKey: "currency") as! String
                if currencyCode == self.currencyData[i].code{
                    image = UIImage(named: "ic_check")
                }else{
                    image = UIImage(named: "")
                }
            }
            
            let str : String = currencyData[i].title
            let action = UIAlertAction(title: str, style: .default, handler: {(_ action: UIAlertAction) -> Void in
                self.selectCurrencyData(pos:i)
            })
            action.setValue(image, forKey: "image")
            alert.addAction(action)
        }
        
        let cancel = UIAlertAction(title: NetworkManager.sharedInstance.language(key: "cancel"), style: .cancel, handler: {(_ action: UIAlertAction) -> Void in
        })
        alert.addAction(cancel)
        
        // Support display in iPad
        alert.popoverPresentationController?.sourceView = self.view
        alert.popoverPresentationController?.sourceRect = CGRect(x:self.view.bounds.size.width / 2.0, y: self.view.bounds.size.height / 2.0, width : 1.0, height : 1.0)
        self.present(alert, animated: true, completion: nil)
    }
    
    func selectCurrencyData(pos:Int){
        currencyCode = currencyData[pos].code
        whichApiToProcess = "currencychanges";
        callingHttppApi()
    }
    
    func showLanguage(){
        let alert = UIAlertController(title: NetworkManager.sharedInstance.language(key: "chooseyourlanguage"), message: nil, preferredStyle: .actionSheet)
        for i in 0..<self.languageData.count {
            var image = UIImage(named: "")
            if sharedPrefrence.object(forKey: "language") != nil{
                let currencyCode = sharedPrefrence.object(forKey: "language") as! String
                if currencyCode == self.languageData[i].code{
                    image = UIImage(named: "ic_check")
                }else{
                    image = UIImage(named: "")
                }
            }
            
            let str : String = languageData[i].title
            let action = UIAlertAction(title: str, style: .default, handler: {(_ action: UIAlertAction) -> Void in
                self.selectLanguageData(pos:i)
            })
            action.setValue(image, forKey: "image")
            alert.addAction(action)
        }
        
        let cancel = UIAlertAction(title: NetworkManager.sharedInstance.language(key: "cancel"), style: .cancel, handler: {(_ action: UIAlertAction) -> Void in
        })
        alert.addAction(cancel)
        
        // Support display in iPad
        alert.popoverPresentationController?.sourceView = self.view
        alert.popoverPresentationController?.sourceRect = CGRect(x:self.view.bounds.size.width / 2.0, y: self.view.bounds.size.height / 2.0, width : 1.0, height : 1.0)
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func selectLanguageData(pos:Int){
        languageCode = languageData[pos].code
        print(languageCode)
        whichApiToProcess = "languagechanges";
       // callingHttppApi()
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
        DispatchQueue.main.async{
            let sessionId = self.defaults.object(forKey:"wk_token");
            var requstParams = [String:Any]();
            requstParams["wk_token"] = sessionId;
            
            if  self.whichApiToProcess == "languagechanges"{
                requstParams["code"] = self.languageCode;
                NetworkManager.sharedInstance.callingHttpRequest(params:requstParams, apiname:"common/language", cuurentView: self){success,responseObject in
                    if success == 1 {
                        NetworkManager.sharedInstance.dismissLoader()
                        let dict = responseObject as! NSDictionary;
                        if dict.object(forKey: "fault") != nil{
                            let fault = dict.object(forKey: "fault") as! Bool;
                            if fault == true{
                                self.loginRequest()
                            }
                        }else{
                            if dict.object(forKey: "error") as! Int == 0{
                                self.doFurtherProcessingWithResult()
                            }
                        }
                        
                    }else if success == 2{
                        NetworkManager.sharedInstance.dismissLoader()
                        self.callingHttppApi();
                    }
                }
                
                
            }else if self.whichApiToProcess == "currencychanges"{
                requstParams["code"] = self.currencyCode;
                NetworkManager.sharedInstance.callingHttpRequest(params:requstParams, apiname:"common/currency", cuurentView: self){success,responseObject in
                    if success == 1 {
                        NetworkManager.sharedInstance.dismissLoader()
                        let dict = responseObject as! NSDictionary;
                        if dict.object(forKey: "fault") != nil{
                            let fault = dict.object(forKey: "fault") as! Bool;
                            if fault == true{
                                self.loginRequest()
                            }
                        }else{
                            if dict.object(forKey: "error") as! Int == 0{
                                self.doFurtherProcessingWithResult()
                            }
                        }
                        
                    }else if success == 2{
                        NetworkManager.sharedInstance.dismissLoader()
                        self.callingHttppApi()
                        
                        
                    }
                }
                
                
            }
            else{
                NetworkManager.sharedInstance.callingHttpRequest(params:requstParams, apiname:"customer/customerLogout", cuurentView: self){success,responseObject in
                    if success == 1 {
                        NetworkManager.sharedInstance.dismissLoader()
                        let dict = responseObject as! NSDictionary;
                        if dict.object(forKey: "fault") != nil{
                            let fault = dict.object(forKey: "fault") as! Bool;
                            if fault == true{
                                self.loginRequest()
                            }
                        }else{
                            
                        }
                        
                    }else if success == 2{
                        NetworkManager.sharedInstance.dismissLoader()
                        self.callingHttppApi()
                    }
                }
            }
        }
    }
    
    func doFurtherProcessingWithResult(){
        productModel.deleteAllRecentViewProductData()
        DBManager.sharedInstance.deleteAllFromDatabase()
        if whichApiToProcess == "languagechanges"{
            defaults.set(languageCode, forKey: "language")
            defaults.synchronize()
            if languageCode == "ar" {
                L102Language.setAppleLAnguageTo(lang: "ar")
                if #available(iOS 9.0, *) {
                    UIView.appearance().semanticContentAttribute = .forceRightToLeft
                } else {
                    // Fallback on earlier versions
                }
            }else {
                L102Language.setAppleLAnguageTo(lang: "en")
                if #available(iOS 9.0, *) {
                    UIView.appearance().semanticContentAttribute = .forceLeftToRight
                } else {
                    // Fallback on earlier versions
                }
            }
        }else if whichApiToProcess  == "currencychanges"{
            defaults.set(currencyCode, forKey: "currency")
            defaults.synchronize()
        }
        
        let rootviewcontroller: UIWindow = ((UIApplication.shared.delegate?.window)!)!
        rootviewcontroller.rootViewController = self.storyboard?.instantiateViewController(withIdentifier: "rootnav")
        let mainwindow = (UIApplication.shared.delegate?.window!)!
        mainwindow.backgroundColor = UIColor(hue: 0.6477, saturation: 0.6314, brightness: 0.6077, alpha: 0.8)
        UIView.transition(with: mainwindow, duration: 0.55001, options: .transitionFlipFromLeft, animations: { () -> Void in
            
        }) { (finished) -> Void in
        }
    }
}

let APPLE_LANGUAGE_KEY = "AppleLanguages"

/// L102Language

class L102Language {
    
    /// get current Apple language
    
    class func currentAppleLanguage() -> String{
        
        let userdef = UserDefaults.standard
        let langArray = userdef.object(forKey: APPLE_LANGUAGE_KEY) as! NSArray
        let current = langArray.firstObject as! String
        
        return current
    }
    
    /// set @lang to be the first in Applelanguages list
    
    class func setAppleLAnguageTo(lang: String) {
        
        let userdef = UserDefaults.standard
        userdef.set([lang,currentAppleLanguage()], forKey: APPLE_LANGUAGE_KEY)
        userdef.synchronize()
    }
}

extension CGRect{
    init(_ x:CGFloat,_ y:CGFloat,_ width:CGFloat,_ height:CGFloat) {
        self.init(x:x,y:y,width:width,height:height)
    }
}

extension CGSize{
    init(_ width:CGFloat,_ height:CGFloat) {
        self.init(width:width,height:height)
    }
}
