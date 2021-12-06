//
//  LeftMenuController.swift
//  LMCSideMenuExample
//
//  Created by Andrey Buksha on 18/09/2018.
//  Copyright © 2018 letmecode. All rights reserved.
//

import UIKit
import LMCSideMenu


class LeftMenuController: UIViewController, UITableViewDelegate, UITableViewDataSource{


@IBOutlet weak var heightofview: NSLayoutConstraint!

var languageCode:String = ""
var languageData = [Languages]()
var whichApiToProcess:String = ""
var currencyCode:String = ""
var productModel = ProductViewModel()

@IBOutlet weak var homemenu: UIView!
@IBOutlet weak var homelabel: UILabel!

@IBOutlet weak var loginmenu: UIView!
@IBOutlet weak var loginlabel: UILabel!
@IBOutlet weak var loginimage: UIImageView!

@IBOutlet weak var categoriesmenu: UILabel!
@IBOutlet weak var languagemenu: UILabel!
@IBOutlet weak var aboutmenu: UILabel!
    
@IBOutlet weak var arlangmenu: UIView!
@IBOutlet weak var img_round_ar: UIImageView!
@IBOutlet weak var ar_label_color: UILabel!
@IBOutlet weak var ar_lang_color: UILabel!

@IBOutlet weak var enlangmenu: UIView!
@IBOutlet weak var img_round_en: UIImageView!
@IBOutlet weak var en_label_color: UILabel!
@IBOutlet weak var en_lang_color: UILabel!

@IBOutlet weak var tableViewHeight: NSLayoutConstraint!

let defaults = UserDefaults.standard;
var isloggedIn = false

@IBOutlet weak var category_tableview: UITableView!

@IBOutlet weak var about_tableview: UITableView!

var featureCategoryCollectionModel = [Categories]()
var cataegoriesCollectionModel = [Categories]()

var arrayForBool :NSMutableArray = [];
var categoryName:String = ""
var categoryId:String = ""
var categoryType:String = ""
var categoryDict :NSDictionary = [:]
var subCategory:NSArray = []
var subId:String = ""
var subName:String = ""
var subcategoryViewModel:SubcategoryViewModel!
    
    var footermenuModel = [Footermenus]()
    var footerid:String = ""
    var footer_description: String = ""

@objc func gotoHome(tapGestureRecognizer: UITapGestureRecognizer){
    ViewController.selfVC.tabBarController?.selectedIndex = 0
    self.dismiss(animated: true, completion: nil)
}

@objc func gotologin(tapGestureRecognizer: UITapGestureRecognizer){
    ViewController.selfVC.tabBarController?.selectedIndex = 0
    ViewController.selfVC.performSegue(withIdentifier: "customerLogin", sender: self)
    self.dismiss(animated: true, completion: nil)
}

@objc func gotologout(tapGestureRecognizer: UITapGestureRecognizer){
    callingHttppApi()
    self.dismiss(animated: true, completion: nil)
}

@objc func toArabian(tapGestureRecognizer: UITapGestureRecognizer){
    languageCode = "ar"
    whichApiToProcess = "languagechanges";
    callingHttppApi()
    
    self.dismiss(animated: true, completion: nil)
}

@objc func toEnglish(tapGestureRecognizer: UITapGestureRecognizer){
    languageCode = "en-gb"
    whichApiToProcess = "languagechanges";
    callingHttppApi()
    
    self.dismiss(animated: true, completion: nil)
}

override func viewDidLoad() {
    super.viewDidLoad()
    
    homelabel.text = "home".localized
    if (self.defaults.object(forKey: "email") != nil){
        isloggedIn = true
        loginlabel.text = "logout".localized
        loginimage.image = UIImage(named: "ic_loagout")!
        
    }else {
        isloggedIn = false
        loginlabel.text = "login".localized
        loginimage.image = UIImage(named: "ic_signin")!
    }
    
    categoriesmenu.text = "categories".localized
    languagemenu.text = "language".localized
    aboutmenu.text = "about".localized
    
    img_round_ar.layer.cornerRadius = 5.0
    img_round_en.layer.cornerRadius = 5.0
    languageCode = self.defaults.object(forKey: "language") as! String
    if(languageCode != "ar"){
        ar_label_color.textColor = UIColor().HexToColor(hexString: LIGHTGREY)
        ar_lang_color.textColor = UIColor().HexToColor(hexString: LIGHTGREY)
        
    } else {
        en_label_color.textColor = UIColor().HexToColor(hexString: LIGHTGREY)
        en_lang_color.textColor = UIColor().HexToColor(hexString: LIGHTGREY)
    }
    
    // category menu
    self.navigationItem.title = NetworkManager.sharedInstance.language(key: "categories")

    cataegoriesCollectionModel = ViewController.selfVC.homeViewModel.cataegoriesCollectionModel
    footermenuModel = ViewController.selfVC.homeViewModel.footermenuData

    
    self.category_tableview.separatorStyle = .singleLine
    category_tableview.delegate = self
    category_tableview.dataSource = self
   // category_tableview.separatorColor = UIColor.init(red: <#T##CGFloat#>, green: <#T##CGFloat#>, blue: <#T##CGFloat#>, alpha: <#T##CGFloat#>)
    
    self.about_tableview.separatorStyle = .singleLine
    about_tableview.delegate = self
    about_tableview.dataSource = self
    
    let tableheight: Double = 42.5 * Double(cataegoriesCollectionModel.count)
    tableViewHeight.constant = CGFloat(tableheight)
    heightofview.constant = CGFloat(627.5 + tableheight)
    
 // Do any additional setup after loading the view.
}

override func viewWillLayoutSubviews(){
    let home_gesture = UITapGestureRecognizer(target: self, action: #selector(gotoHome(tapGestureRecognizer:)))
    homemenu.isUserInteractionEnabled = true
    homemenu.addGestureRecognizer(home_gesture)
    
    if(isloggedIn){
        let login_gesture = UITapGestureRecognizer(target: self, action: #selector(gotologout(tapGestureRecognizer:)))
        loginmenu.isUserInteractionEnabled = true
        loginmenu.addGestureRecognizer(login_gesture)
    }else {
        let login_gesture = UITapGestureRecognizer(target: self, action: #selector(gotologin(tapGestureRecognizer:)))
        loginmenu.isUserInteractionEnabled = true
        loginmenu.addGestureRecognizer(login_gesture)
    }
    
    let ar_gesture = UITapGestureRecognizer(target: self, action: #selector(toArabian(tapGestureRecognizer:)))
    arlangmenu.isUserInteractionEnabled = true
    arlangmenu.addGestureRecognizer(ar_gesture)
    
    let en_gesture = UITapGestureRecognizer(target: self, action: #selector(toEnglish(tapGestureRecognizer:)))
    enlangmenu.isUserInteractionEnabled = true
    enlangmenu.addGestureRecognizer(en_gesture)
    
    
}


func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if (tableView == category_tableview){
        return cataegoriesCollectionModel.count
    } else {
        return footermenuModel.count
    }
}

func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
   if (tableView == category_tableview){
    category_tableview.register(UINib(nibName: "MenuCategoryCell", bundle: nil), forCellReuseIdentifier: "MenuCategoryCell")
    let cell:MenuCategoryCell = tableView.dequeueReusableCell(withIdentifier: "MenuCategoryCell") as! MenuCategoryCell
    cell.catimg.loadImageFrom(url:cataegoriesCollectionModel[indexPath.row].image  , dominantColor: cataegoriesCollectionModel[indexPath.row].dominant_color)
    cell.catlab.text = cataegoriesCollectionModel[indexPath.row].name
    return cell
   }else{
    about_tableview.register(UINib(nibName: "FootermenuCell", bundle: nil), forCellReuseIdentifier: "FootermenuCell")
    let cell:FootermenuCell = tableView.dequeueReusableCell(withIdentifier: "FootermenuCell") as! FootermenuCell
    cell.footermenu_label.text = footermenuModel[indexPath.row].title.replacingOccurrences(of: "&amp;", with: "&")
    return cell
    }
}


func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if (tableView == category_tableview){
    ViewController.selfVC.categoryId = cataegoriesCollectionModel[indexPath.row].id
    ViewController.selfVC.categoryName = cataegoriesCollectionModel[indexPath.row].name
    ViewController.selfVC.categoryType = ""
    let isChild = cataegoriesCollectionModel[indexPath.row].isChild
    if isChild{
        ViewController.selfVC.tabBarController?.selectedIndex = 0
        ViewController.selfVC.performSegue(withIdentifier: "subcategory", sender: self);
        
    }else{
        ViewController.selfVC.tabBarController?.selectedIndex = 0
        ViewController.selfVC.performSegue(withIdentifier: "productcategory", sender: self);
    }
        
    }else{
        self.whichApiToProcess = "getFooterContent"
        self.footerid = footermenuModel[indexPath.row].information_id
        callingHttppApi()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
            NetworkManager.sharedInstance.dismissLoader()
            ViewController.selfVC.performSegue(withIdentifier: "informationpage", sender: self)
        })
                
    }
    
    self.dismiss(animated: true, completion: nil)
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

func selectLanguageData(pos:Int){
    languageCode = languageData[pos].code
    whichApiToProcess = "languagechanges";
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
            
            
        }else if self.whichApiToProcess == "getFooterContent"{
            
            requstParams["information_id"] = self.footerid;
            NetworkManager.sharedInstance.callingHttpRequest(params:requstParams, apiname:"common/getInformationPage", cuurentView: self){success,responseObject in
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
                            ViewController.selfVC.footer_description = dict.object(forKey: "description") as! String
                            print(JSON(dict))
                        }
                    }
                    
                }else if success == 2{
                    NetworkManager.sharedInstance.dismissLoader()
                    self.callingHttppApi()
                    
                }
            }
            
            
        }
        else{
            print("called logout")
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
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier! == "informationpage") {
            let viewController:InformationPage = segue.destination as UIViewController as! InformationPage
            callingHttppApi()
            viewController.descriptionData? = self.footer_description
            print("heee")
            
        }
        
    }


/*
// MARK: - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    // Get the new view controller using segue.destination.
    // Pass the selected object to the new view controller.
}
*/

}
