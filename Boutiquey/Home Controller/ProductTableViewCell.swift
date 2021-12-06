//
//  ProductTableViewCell.swift
//  WooCommerce
//
//  Created by Kunal Parsad on 04/11/17.
//  Copyright © 2017 Kunal Parsad. All rights reserved.
//

import UIKit

@objc protocol productViewControllerHandlerDelegate: class {
    func productClick(name:String,image:String,id:String)
    func viewAllClick(type:String)
}



class ProductTableViewCell: UITableViewCell {
    
var productCollectionModel = [Products]()

    

    
var titles:String = ""
var delegate:productViewControllerHandlerDelegate!
@IBOutlet weak var prodcutCollectionView: UICollectionView!
@IBOutlet weak var productCollectionViewHeight: NSLayoutConstraint!
@IBOutlet weak var newProductLabel: UILabel!
var showFeature:Bool = false
var homeViewModel:HomeViewModel!
//var catalogProductViewModel:CatalogProductViewModel!
//    var radioId = [Int:String]()
//     @IBOutlet weak var optionView: UIView!
//    var fileCodeValue = ""
@IBOutlet var viewAllbutton: UIButton!
var items = [HomeViewModelItem]()
var controller:UIViewController!
var sectionValue:Int = 0
var whichApiToProcess:String = ""
var product_id:String = ""
var viewAllID:String = ""

    
    override func awakeFromNib() {
        super.awakeFromNib()
        showFeature = false
        productCollectionViewHeight.constant = 20
        prodcutCollectionView.register(UINib(nibName: "ProductImageCell", bundle: nil), forCellWithReuseIdentifier: "productimagecell")
        prodcutCollectionView.delegate = self
        prodcutCollectionView.dataSource = self
        viewAllbutton.setTitleColor(UIColor().HexToColor(hexString: BUTTON_COLOR), for: .normal)
        viewAllbutton.layer.cornerRadius = 3;
        viewAllbutton.layer.borderWidth = 1
        viewAllbutton.contentEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        viewAllbutton.layer.borderColor = UIColor().HexToColor(hexString: BUTTON_COLOR).cgColor
    }
    
    
    @IBAction func viewAllClick(_ sender: UIButton) {
        self.delegate.viewAllClick(type: viewAllID)
    }
    
    override func layoutSubviews() {
        prodcutCollectionView.register(UINib(nibName: "ProductImageCell", bundle: nil), forCellWithReuseIdentifier: "productimagecell")
        viewAllbutton.setTitle("viewall".localized, for: .normal)
    }

    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    static var nib:UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    static var identifier: String {
        return String(describing: self)
    }
    
    
    

    
}


extension ProductTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource , UICollectionViewDelegateFlowLayout{
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return  productCollectionModel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "productimagecell", for: indexPath) as! ProductImageCell
        cell.layer.borderColor = UIColor().HexToColor(hexString: LIGHTGREY).cgColor
        cell.layer.borderWidth = 0.5
        cell.productImage.loadImageFrom(url:productCollectionModel[indexPath.row].image , dominantColor: productCollectionModel[indexPath.row].dominant_color)
        cell.productName.text = productCollectionModel[indexPath.row].name
        cell.productPrice.text = productCollectionModel[indexPath.row].price
        cell.layoutIfNeeded()
        cell.specialPrice.isHidden = true
        cell.saleLabel.isHidden = true
        if productCollectionModel[indexPath.row].specialPrice != 0.00  && (productCollectionModel[indexPath.row].specialPrice) > 0.00{
            cell.specialPrice.isHidden = false;
            cell.productPrice.text =  productCollectionModel[indexPath.row].formatted_special
            let attributeString = NSMutableAttributedString(string: productCollectionModel[indexPath.row].price)
            attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 1, range: NSRange(location: 0, length: attributeString.length))
            cell.specialPrice.attributedText = attributeString
            cell.specialPrice.textColor = UIColor().HexToColor(hexString: REDCOLOR)
            cell.saleLabel.isHidden = false
        }
        cell.wishListButton.tag = indexPath.row
        cell.wishListButton.addTarget(self, action: #selector(addToWishList(sender:)), for: .touchUpInside)
        cell.addToCartButton_home.tag = indexPath.row
        cell.addToCartButton_home.addTarget(self, action: #selector(addToCartAction(sender:)), for: .touchUpInside)
        cell.wishListButton.isUserInteractionEnabled = true;
        if productCollectionModel[indexPath.row].isInWishList == 1{
            cell.wishListButton.setImage( UIImage(named:"ic_wishlist_fill"), for: .normal)
        }else{
            cell.wishListButton.setImage( UIImage(named:"ic_wishlist_empty"), for: .normal)
        }
        
        return cell
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width/2 - 20 , height: collectionView.frame.size.height - 15)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate.productClick(name: productCollectionModel[indexPath.row].name, image: productCollectionModel[indexPath.row].image, id: productCollectionModel[indexPath.row].productID)
        
    }
    
    @objc func addToCartAction(sender: UIButton) {
        print(productCollectionModel[sender.tag].productID)
        
        let defaults = UserDefaults.standard
        let sessionId = defaults.object(forKey:"wk_token")
        var optionDictionary = [String:AnyObject]()
        
        let width = String(format:"%f", SCREEN_WIDTH * UIScreen.main.scale)
        
        do {
            var requstParams = [String:String]()
            requstParams["width"] = width
            requstParams["product_id"] = productCollectionModel[sender.tag].productID
            requstParams["wk_token"] = sessionId as? String
            requstParams["quantity"] = "1"
            do {
                let jsonSortData =  try JSONSerialization.data(withJSONObject: optionDictionary, options: .prettyPrinted)
                let jsonSortString:String = NSString(data: jsonSortData, encoding: String.Encoding.utf8.rawValue)! as String
                requstParams["option"] = jsonSortString
            }
            catch {
                print(error.localizedDescription)
            }
            
            
            NetworkManager.sharedInstance.callingHttpRequest(params:requstParams, apiname:"cart/addToCart", cuurentView: self.parentContainerViewController()!){success,responseObject in
                if success == 1{
                    let dict = responseObject as! NSDictionary;
                    NetworkManager.sharedInstance.dismissLoader()
                    if dict.object(forKey: "fault") != nil{
                        let fault = dict.object(forKey: "fault") as! Bool;
                        if fault == true{
                            self.extraLoginRequest()
                        }
                    }else{
                        
                        let dict = responseObject as! NSDictionary
                        if dict.object(forKey: "error") as! Int == 0 {
                            NetworkManager.sharedInstance.showSuccessSnackBar(msg: dict.object(forKey: "message") as! String)
                            let data = dict.object(forKey: "total") as! String
                            ViewController.selfVC.notificationButton.badge = data
                            ViewController.selfVC.countofcart =  data
                     //  ViewController.selfVC.tabBarController!.tabBar.items?[2].badgeValue = data.components(separatedBy: " ")[0]
//                            if self.goToBagFlag && !self.isCart{
//                                self.tabBarController!.selectedIndex = 3
//                            }else{
//                                if self.goToBagFlag  && self.isCart{
//                                    self.navigationController?.popToRootViewController(animated: true)
//                                }
//                            }
                            
                        }else{
                            NetworkManager.sharedInstance.showWarningSnackBar(msg: dict.object(forKey: "message") as! String)
                        }
                    }
                }else if success == 2{
                    
                    NetworkManager.sharedInstance.dismissLoader()
                    //self.callingHttppApi()
                }
            }
        }
        
    }
    
    @objc func addToWishList(sender: UIButton){

        if defaults.object(forKey: "customer_id") != nil{
            
            let item = items[sectionValue]
            if var collectionData:[Products] =  ((item as? HomeViewModelLatestItem)?.productCollectionModel){
            if collectionData[sender.tag].isInWishList == 0{
                collectionData[sender.tag].isInWishList = 1
            }else{
                collectionData[sender.tag].isInWishList = 0
            }
            
            (item as? HomeViewModelLatestItem)?.productCollectionModel = collectionData
            items[sectionValue] = item
            
            if productCollectionModel[sender.tag].isInWishList == 1{
                sender.setImage(#imageLiteral(resourceName: "ic_wishlist_empty"), for: .normal)
                whichApiToProcess = "removetowishlist"
            }else{
                sender.setImage(#imageLiteral(resourceName: "ic_wishlist_fill"), for: .normal)
                whichApiToProcess = "addtowishlist"
            }
            
            if productCollectionModel[sender.tag].isInWishList == 0{
                productCollectionModel[sender.tag].isInWishList  = 1
            }else{
                productCollectionModel[sender.tag].isInWishList  = 0
            }
            
            product_id = productCollectionModel[sender.tag].productID
            self.callingExtraHttpi()
            }
            
        }else{
            NetworkManager.sharedInstance.showWarningSnackBar(msg: NetworkManager.sharedInstance.language(key:"loginrequired"))
            
        }
        
        
        
    }
    
    
    
    
    
    
    func callingExtraHttpi(){
        self.controller.view.isUserInteractionEnabled = false
        if self.whichApiToProcess == "addtowishlist"{
            
            NetworkManager.sharedInstance.showLoader()
            let sessionId = defaults.object(forKey:"wk_token");
            var requstParams = [String:Any]();
            requstParams["product_id"] = self.product_id
            requstParams["wk_token"] = sessionId
            NetworkManager.sharedInstance.callingHttpRequest(params:requstParams, apiname:"catalog/addToWishlist", cuurentView: self.controller){success,responseObject in
                if success == 1{
                    let dict = responseObject as! NSDictionary;
                    
                    if dict.object(forKey: "fault") != nil{
                        let fault = dict.object(forKey: "fault") as! Bool;
                        if fault == true{
                            self.extraLoginRequest()
                        }
                    }else{
                        
                        self.controller.view.isUserInteractionEnabled = true
                        NetworkManager.sharedInstance.dismissLoader()
                        let dict = JSON(responseObject as! NSDictionary)
                        if dict["error"].intValue == 0{
                            NetworkManager.sharedInstance.showSuccessSnackBar(msg: dict["message"].stringValue)
                            
                        }else{
                            NetworkManager.sharedInstance.showWarningSnackBar(msg: dict["message"].stringValue)
                        }
                    }
                }else if success == 2{
                    NetworkManager.sharedInstance.dismissLoader()
                    self.callingExtraHttpi()
                }
            }
            
        }else if whichApiToProcess == "removetowishlist"{
            NetworkManager.sharedInstance.showLoader()
            let sessionId = defaults.object(forKey:"wk_token");
            var requstParams = [String:Any]();
            requstParams["wk_token"] = sessionId;
            requstParams["product_id"] = product_id;
            NetworkManager.sharedInstance.callingHttpRequest(params:requstParams, apiname:"customer/removeFromWishlist", cuurentView: self.controller){success,responseObject in
                
                if success == 1 {
                    
                    let dict = responseObject as! NSDictionary;
                    if dict.object(forKey: "fault") != nil{
                        let fault = dict.object(forKey: "fault") as! Bool;
                        if fault == true{
                            self.extraLoginRequest()
                        }
                    }else{
                        self.controller.view.isUserInteractionEnabled = true
                        NetworkManager.sharedInstance.dismissLoader()
                        if dict.object(forKey: "error") as! Int == 0{
                            NetworkManager.sharedInstance.showSuccessSnackBar(msg: dict.object(forKey: "message") as! String)
                        }
                    }
                }else if success == 2{
                    NetworkManager.sharedInstance.dismissLoader()
                    self.callingExtraHttpi();
                }
            }
        }
        
    }
    
    
    
    
    func extraLoginRequest(){
        var loginRequest = [String:String]();
        loginRequest["apiKey"] = API_USER_NAME;
        loginRequest["apiPassword"] = API_KEY.md5;
        if defaults.object(forKey: "language") != nil{
            loginRequest["language"] = defaults.object(forKey: "language") as? String;
        }
        if  defaults.object(forKey: "currency") != nil{
            loginRequest["currency"] = defaults.object(forKey: "currency") as? String;
        }
        if defaults.object(forKey: "customer_id") != nil{
            loginRequest["customer_id"] = defaults.object(forKey: "customer_id") as? String;
        }
        NetworkManager.sharedInstance.callingHttpRequest(params:loginRequest, apiname:"common/apiLogin", cuurentView: self.controller){val,responseObject in
            if val == 1{
                let dict = responseObject as! NSDictionary
                defaults.set(dict.object(forKey: "wk_token") as! String, forKey: "wk_token")
                defaults.set(dict.object(forKey: "language") as! String, forKey: "language")
                defaults.set(dict.object(forKey: "currency") as! String, forKey: "currency")
                defaults.synchronize();
                self.callingExtraHttpi()
            }else if val == 2{
                NetworkManager.sharedInstance.dismissLoader()
                self.extraLoginRequest()
                
            }
        }
    }
    

    
    
}
