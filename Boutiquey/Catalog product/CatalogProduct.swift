//
//  CatalogProduct.swift
//  Magento2MobikulNew
//
//  Created by Kunal Parsad on 10/08/17.
//  Copyright © 2017 Kunal Parsad. All rights reserved.
//

import UIKit
import MobileCoreServices
import Alamofire


class CatalogProduct: UIViewController ,UIScrollViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIPickerViewDelegate,RelatedProductHandlerDelegate,UIDocumentPickerDelegate,UIDocumentMenuDelegate,UIPickerViewDataSource{
    
    
    @IBOutlet weak var availabilityStockLbl: UILabel!
    @IBOutlet weak var specialrice: UILabel!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionViewHeightConstarints: NSLayoutConstraint!
    var cellHeight:CGFloat = SCREEN_HEIGHT/2
    var cellWidth:CGFloat = SCREEN_WIDTH
    var productId:String = ""
    var productName:String = ""
    var productPrice:String = ""
    var productImageUrl:String = ""
    let defaults = UserDefaults.standard;
    var imageArrayUrl:NSMutableArray = []
    var dominantColor:NSMutableArray = []
    
    //var toolbar : UIToolbar! = nil
    var selectArr  = [Int:JSON]()
    var selectID  = [Int:String]()
    var keyBoardFlag:Int = 1;
    var whichApiToProcess:String = ""
    var radioId = [Int:String]()
    var fileCodeValue = ""
    var optionDictionary = [String:AnyObject]()
    
    @IBOutlet var parentView: UIView!
    @IBOutlet weak var addToCartView: UIView!
   
    var catalogProductViewModel:CatalogProductViewModel!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productpriceLabel: UILabel!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var addToCartButton: UIButton!
    @IBOutlet weak var gotobagbutton: UIButton!
    @IBOutlet weak var optionView: UIView!
    @IBOutlet weak var optionViewHeightConstarints: NSLayoutConstraint!
    var goToBagFlag:Bool = false
    var currentOptionTag:Int = 0;
    
    var childZoomingScrollView, parentZoomingScrollView :UIScrollView!
    var imageview,imageZoom : UIImageView!
    var currentTag:NSInteger = 0
    var pager:UIPageControl!
    
    
    @IBOutlet weak var ratingView: UIView!
    @IBOutlet weak var ratingValue: UILabel!
    @IBOutlet weak var totalReview: UILabel!
    @IBOutlet weak var addYourReviewButton: UIButton!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var quantityValue: UILabel!
    
    @IBOutlet weak var itemsLabel: UILabel!
    @IBOutlet weak var stepper: UIStepper!
    @IBOutlet weak var wishListAndSahreView: UIView!
    @IBOutlet weak var shareLabel: UILabel!
    @IBOutlet weak var addToWishListLabel: UILabel!
    @IBOutlet weak var internalCartView: UIView!
    @IBOutlet weak var internalGoToBagButton: UIButton!
    @IBOutlet weak var internalAddToCartButton: UIButton!
    @IBOutlet weak var descriptionView: UIView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var viewAllReviewsView: UIView!
    @IBOutlet weak var viewAllReviewLabel: UILabel!
    @IBOutlet weak var additionInfoLabel: UILabel!
    @IBOutlet weak var additionalInfoView: UIView!
    var weatherData:Data?
    var fileName:String!
    var isCart:Bool = false
    
    @IBOutlet var wishListIcon: UIImageView!
    
    
    @IBOutlet var infoImage: UIImageView!
    @IBOutlet var quantityWarningMessage: UILabel!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ratingView.isHidden = true
        ratingView.applyGradientToTopView(colours: STARGRADIENT, locations: nil)
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.title = productName
        let nib = UINib(nibName: "CatalogProductImage", bundle:nil)
        self.collectionView.register(nib, forCellWithReuseIdentifier: "catalogimage")
        scrollView.delegate = self
        collectionViewHeightConstarints.constant = SCREEN_HEIGHT/2 + 16
        collectionView.delegate = self;
        collectionView.dataSource = self
        collectionView.reloadData()
        if productImageUrl != ""{
            imageArrayUrl.add(productImageUrl);
        }
        productNameLabel.text = productName
        productpriceLabel.text = productPrice
        self.tabBarController?.tabBar.isHidden = true
        callingHttppApi()
        addToCartView.backgroundColor = UIColor().HexToColor(hexString: BUTTON_COLOR)
        
      
        addToCartButton.setTitle(NetworkManager.sharedInstance.language(key: "addtocart"), for: .normal)
        gotobagbutton.setTitle(NetworkManager.sharedInstance.language(key: "gotobag"), for: .normal)
        
    
        internalAddToCartButton.setTitle(NetworkManager.sharedInstance.language(key: "addtocart"), for: .normal)
        internalGoToBagButton.setTitle(NetworkManager.sharedInstance.language(key: "gotobag"), for: .normal)
        
        
        wishListAndSahreView.layer.borderWidth = 1.0
        wishListAndSahreView.layer.borderColor = UIColor().HexToColor(hexString: LIGHTGREY).cgColor
        
        addYourReviewButton.setTitle(NetworkManager.sharedInstance.language(key: "addreview"), for:  .normal)
        addYourReviewButton.setTitleColor(UIColor().HexToColor(hexString: BUTTON_COLOR), for: .normal)
        stepper.tintColor = UIColor().HexToColor(hexString: BUTTON_COLOR)
        shareLabel.text = NetworkManager.sharedInstance.language(key: "share")
        addToWishListLabel.text = NetworkManager.sharedInstance.language(key: "addtowishlist")
        
        addToCartButton.setTitleColor(UIColor.white, for: .normal)
        
        addToCartButton.layer.cornerRadius = 5;
        addToCartButton.layer.masksToBounds = true
        
        gotobagbutton.setTitleColor(UIColor().HexToColor(hexString: BUTTON_COLOR), for: .normal)
        gotobagbutton.layer.cornerRadius = 5;
        gotobagbutton.layer.masksToBounds = true
        gotobagbutton.backgroundColor = UIColor.white
        
        internalGoToBagButton.setTitleColor(UIColor().HexToColor(hexString: BUTTON_COLOR), for: .normal)
        internalGoToBagButton.layer.cornerRadius = 5;
        internalGoToBagButton.layer.masksToBounds = true
        
        
        
        internalAddToCartButton.setTitleColor(UIColor.white, for: .normal)
        internalAddToCartButton.backgroundColor = UIColor().HexToColor(hexString: BUTTON_COLOR)
        internalAddToCartButton.layer.cornerRadius = 5;
        internalAddToCartButton.layer.masksToBounds = true
        
        internalAddToCartButton.isHidden = false
        internalGoToBagButton.isHidden = false
        internalGoToBagButton.backgroundColor = UIColor.white
        
        
        
        descriptionView.layer.borderWidth = 1.0
        viewAllReviewsView.layer.borderWidth = 1.0
        descriptionView.layer.borderColor = UIColor().HexToColor(hexString: LIGHTGREY).cgColor
        viewAllReviewsView.layer.borderColor = UIColor().HexToColor(hexString: LIGHTGREY).cgColor
        
        descriptionLabel.text = NetworkManager.sharedInstance.language(key: "description")
        viewAllReviewLabel.text = NetworkManager.sharedInstance.language(key: "viewallreview")
        additionInfoLabel.text = NetworkManager.sharedInstance.language(key: "additionalinfo")
        quantityLabel.text = "qty".localized
        itemsLabel.text = "items".localized
        
        
        
        descriptionLabel.textColor = UIColor().HexToColor(hexString: BUTTON_COLOR)
        viewAllReviewLabel.textColor = UIColor().HexToColor(hexString: BUTTON_COLOR)
        additionInfoLabel.textColor = UIColor().HexToColor(hexString: BUTTON_COLOR)
        
        
        addToCartView.backgroundColor = UIColor().HexToColor(hexString: BUTTON_COLOR)
        internalCartView.backgroundColor = UIColor().HexToColor(hexString: BUTTON_COLOR)
        
        
        self.quantityWarningMessage.isHidden = true
        self.infoImage.isHidden = true
        self.addYourReviewButton.isHidden = true
        self.viewAllReviewsView.isHidden = true
        self.ratingView.isHidden = true
    }
    
    
    @IBAction func dismissKeyboard(_ sender: Any) {
        view.endEditing(true)
    }
    
    
    @IBAction func stepperClick(_ sender: UIStepper) {
        quantityValue.text = String(format:"%d",Int(sender.value))
    }
    
    @IBAction func additionalInfoClick(_ sender: UITapGestureRecognizer) {
        self.performSegue(withIdentifier: "specifiaction", sender: self)
    }
    
    
    @IBAction func addReviewClick(_ sender: UIButton) {
        if self.catalogProductViewModel.catalogProductModel.review_status == 1 && self.catalogProductViewModel.catalogProductModel.review_guest == 0{
           NetworkManager.sharedInstance.showWarningSnackBar(msg: "loginrequired".localized)
        }else{
           self.performSegue(withIdentifier: "writeReview", sender: self)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }
    
    
    
    
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func collectionView(_ view: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArrayUrl.count
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "catalogimage", for: indexPath) as! CatalogProductImage
        
        if self.dominantColor.count > 0{
            cell.imageView.loadImageFrom(url:imageArrayUrl.object(at: indexPath.row) as! String , dominantColor: dominantColor.object(at: indexPath.row) as! String)
        }else{
           cell.imageView.loadImageFrom(url:imageArrayUrl.object(at: indexPath.row) as! String , dominantColor: "ffffff")
        }
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(openImage))
        cell.imageView.addGestureRecognizer(tapGesture)
        return cell;
        
    }
    
    @objc func openImage(_sender : UITapGestureRecognizer){
        self.zoomAction()
    }
    
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width:cellWidth , height:cellHeight)
        
    }
    
    
    @IBAction func goToBag(_ sender: Any) {
        goToBagFlag = true;
        self.addToCartAction(UIButton())
        
        
    }
    
    @IBAction func reviewsClick(_ sender: UITapGestureRecognizer) {
        self.performSegue(withIdentifier: "reviewsData", sender: self)
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
      
        //self.zoomAction()
    }
    
    
    @IBAction func description(_ sender: UITapGestureRecognizer) {
        self.performSegue(withIdentifier: "gotodescription", sender: self)
        
    }
   
    
    func callingHttppApi(){
        DispatchQueue.main.async{
            NetworkManager.sharedInstance.showLoader()
            let sessionId = self.defaults.object(forKey:"wk_token");
            let width = String(format:"%f", SCREEN_WIDTH * UIScreen.main.scale)
            self.view.isUserInteractionEnabled = false
            
            if self.whichApiToProcess == "addtocart"{
                var requstParams = [String:String]();
                requstParams["width"] = width
                requstParams["product_id"] = self.productId
                requstParams["wk_token"] = sessionId as? String
                requstParams["quantity"] = self.quantityValue.text
                do {
                    let jsonSortData =  try JSONSerialization.data(withJSONObject: self.optionDictionary, options: .prettyPrinted)
                    let jsonSortString:String = NSString(data: jsonSortData, encoding: String.Encoding.utf8.rawValue)! as String
                    requstParams["option"] = jsonSortString
                }
                catch {
                    print(error.localizedDescription)
                }
                
                
                NetworkManager.sharedInstance.callingHttpRequest(params:requstParams, apiname:"cart/addToCart", cuurentView: self){success,responseObject in
                    if success == 1{
                        let dict = responseObject as! NSDictionary;
                        NetworkManager.sharedInstance.dismissLoader()
                        if dict.object(forKey: "fault") != nil{
                            let fault = dict.object(forKey: "fault") as! Bool;
                            if fault == true{
                                self.loginRequest()
                            }
                        }else{
                           
                            self.view.isUserInteractionEnabled = true
                            let dict = responseObject as! NSDictionary
                            if dict.object(forKey: "error") as! Int == 0{
                                NetworkManager.sharedInstance.showSuccessSnackBar(msg: dict.object(forKey: "message") as! String)
                                let data = dict.object(forKey: "total") as! String
                             //   self.tabBarController!.tabBar.items?[2].badgeValue = data.components(separatedBy: " ")[0]
                                ViewController.selfVC.notificationButton.badge = data.components(separatedBy: " ")[0]
                                ViewController.selfVC.countofcart = data.components(separatedBy: " ")[0]
                                if self.goToBagFlag && !self.isCart{
                                    self.tabBarController!.selectedIndex = 3
                                }else{
                                    if self.goToBagFlag  && self.isCart{
                                        self.navigationController?.popToRootViewController(animated: true)
                                    }
                                }
                                
                            }else{
                                NetworkManager.sharedInstance.showWarningSnackBar(msg: dict.object(forKey: "message") as! String)
                            }
                        }
                    }else if success == 2{
                        NetworkManager.sharedInstance.dismissLoader()
                        self.callingHttppApi()
                    }
                }
            }
            else if self.whichApiToProcess == "adtowishlist"{
                var requstParams = [String:Any]();
                requstParams["product_id"] = self.productId
                requstParams["wk_token"] = sessionId
                NetworkManager.sharedInstance.callingHttpRequest(params:requstParams, apiname:"catalog/addToWishlist", cuurentView: self){success,responseObject in
                    if success == 1{
                        self.view.isUserInteractionEnabled = true
                        NetworkManager.sharedInstance.dismissLoader()
                        let dict = JSON(responseObject as! NSDictionary)
                        
                        if dict["fault"].intValue == 1{
                                self.loginRequest()
                        }else{
                            
                            if dict["error"].intValue == 0{
                                NetworkManager.sharedInstance.showSuccessSnackBar(msg: dict["message"].stringValue)
                                self.catalogProductViewModel.catalogProductModel.wishlist_status = 1
                                self.wishListIcon.image = #imageLiteral(resourceName: "ic_wishlist_fill")
                                
                            }else{
                                NetworkManager.sharedInstance.showWarningSnackBar(msg: dict["message"].stringValue)
                            }
                        }
                    }else if success == 2{
                        NetworkManager.sharedInstance.dismissLoader()
                        self.callingHttppApi()
                    }
                }
            }else if self.whichApiToProcess == "removewishlist"{
                self.view.isUserInteractionEnabled = false
                NetworkManager.sharedInstance.showLoader()
                let sessionId = self.defaults.object(forKey:"wk_token");
                var requstParams = [String:Any]();
                requstParams["wk_token"] = sessionId;
                requstParams["product_id"] = self.productId;
                NetworkManager.sharedInstance.callingHttpRequest(params:requstParams, apiname:"customer/removeFromWishlist", cuurentView: self){success,responseObject in
                    
                    if success == 1 {
                        self.view.isUserInteractionEnabled = true
                        NetworkManager.sharedInstance.dismissLoader()
                        let dict = JSON(responseObject as! NSDictionary)
                        if dict["fault"].intValue == 1{
                            self.loginRequest()
                        }else{
                            if dict["error"].intValue == 0{
                                NetworkManager.sharedInstance.showSuccessSnackBar(msg: dict["message"].stringValue)
                                self.catalogProductViewModel.catalogProductModel.wishlist_status = 0
                                self.wishListIcon.image = #imageLiteral(resourceName: "ic_wishlist_empty")
                            }
                        }
                    }else if success == 2{
                        NetworkManager.sharedInstance.dismissLoader()
                        self.callingHttppApi();
                    }
                }
            }
            else{
                self.parentView.isUserInteractionEnabled = false
                var requstParams = [String:Any]();
                requstParams["width"] = width
                requstParams["product_id"] = self.productId
                requstParams["wk_token"] = sessionId
                NetworkManager.sharedInstance.callingHttpRequest(params:requstParams, apiname:"catalog/getProduct", cuurentView: self){success,responseObject in
                    if success == 1{
                        let dict = responseObject as! NSDictionary;
                        
                        if dict.object(forKey: "fault") != nil{
                            let fault = dict.object(forKey: "fault") as! Bool;
                            if fault == true{
                                self.loginRequest()
                            }
                        }else{
                            
                          
                            self.view.isUserInteractionEnabled = true
                            self.parentView.isUserInteractionEnabled = true
                            let dict = JSON(responseObject as! NSDictionary)
                            if dict["error"].intValue == 1{
                                NetworkManager.sharedInstance.showErrorSnackBar(msg: NetworkManager.sharedInstance.language(key: "productnotexist"))
                            }else{
                                
                                let data = JSON(responseObject as! NSDictionary)
                                var ProductDict = [String: Any]()
                                ProductDict["name"] = data["name"].stringValue
                                ProductDict["ProductID"] = data["product_id"].stringValue
                                ProductDict["image"] = data["images"].arrayValue.count>0 ? data["images"].arrayValue[0]["popup"].stringValue:"a.jpeg"
                                ProductDict["price"] = data["price"].stringValue
                                ProductDict["DateTime"] = String(describing: Date())
                                ProductDict["specialPrice"] = data["special"].floatValue
                                ProductDict["formatted_special"] = data["formatted_special"].stringValue
                                ProductDict["hasOption"] = (data["options"].arrayObject?.count)! > 0 ? "1" : "0"
                                
                                let productModel = ProductViewModel(data: JSON(ProductDict))
                                
                                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refreshRecentView"), object: nil)
                                
                              
                                
                                self.catalogProductViewModel = CatalogProductViewModel(productData:JSON(responseObject as! NSDictionary))
                                self.doFurtherProcessingWithResult();
                            }
                            NetworkManager.sharedInstance.dismissLoader()
                            
                        }
                    }else if success == 2{
                        NetworkManager.sharedInstance.dismissLoader()
                        self.callingHttppApi()
                    }
                }
            }
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
    
    
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.tag == 888888{
            let pageWidth: CGFloat = self.parentZoomingScrollView.frame.size.width
            let page = floor((self.parentZoomingScrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1
            self.currentTag = NSInteger(page)
            self.pager.currentPage = Int(page)
        }
        
        for cell: UICollectionViewCell in self.collectionView.visibleCells {
            let indexPathValue = self.collectionView.indexPath(for: cell)!
            self.pageControl.currentPage = indexPathValue.row
        }
        
        let actualHeight = scrollView.contentOffset.y+scrollView.frame.size.height;
        if actualHeight > internalCartView.frame.origin.y{
            addToCartView.isHidden = true;
            internalCartView.isHidden = false
        }else{
            addToCartView.isHidden = false;
            internalCartView.isHidden = true
        }
        
    }
    
    
    func doFurtherProcessingWithResult(){
        DispatchQueue.main.async{
            self.activityIndicator.stopAnimating()
            self.productNameLabel.text = self.catalogProductViewModel.getProductName
            self.availabilityStockLbl.text = self.catalogProductViewModel.getStock
            self.availabilityStockLbl.textColor = UIColor().HexToColor(hexString: GREEN_COLOR)
            self.productpriceLabel.text = self.catalogProductViewModel.getPrice
            self.ratingValue.text = self.catalogProductViewModel.getRating
            if self.catalogProductViewModel.catalogProductModel.ratingValue > 0{
             self.ratingView.isHidden = false
            }
            self.totalReview.text = self.catalogProductViewModel.catalogProductModel.reviews
            self.imageArrayUrl = []
            self.dominantColor = []
            for i in 0..<self.catalogProductViewModel.getProductImages.count{
                self.imageArrayUrl.add(self.catalogProductViewModel.getProductImages[i].imageURL)
                self.dominantColor.add(self.catalogProductViewModel.getProductImages[i].dominant)
            }
            self.collectionView.reloadData()
            self.pageControl.numberOfPages = self.imageArrayUrl.count
            if self.imageArrayUrl.count == 1{
              self.pageControl.isHidden = true
            }
            
            if self.catalogProductViewModel.catalogProductModel.minimum > 1{
                let value =   String(format:"%d",self.catalogProductViewModel.catalogProductModel.minimum);
                self.quantityValue.text = value;
                self.stepper.value = Double(self.catalogProductViewModel.catalogProductModel.minimum)
                self.stepper.minimumValue = Double(self.catalogProductViewModel.catalogProductModel.minimum)
                self.quantityWarningMessage.text = "minimumqtywarning".localized+" "+value
                self.quantityWarningMessage.isHidden = false
                self.infoImage.isHidden = false
            }
            
            
            if self.catalogProductViewModel.attributes_Data.count > 0 {
                self.additionalInfoView.isHidden = false;
            }
            else{
                self.additionalInfoView.isHidden = true;
            }
            
            if self.catalogProductViewModel.catalogProductModel.wishlist_status == 1{
                self.wishListIcon.image = #imageLiteral(resourceName: "ic_wishlist_fill")
            }
            
            
            
            // for add review option
            let customerId = self.defaults.object(forKey: "customer_id")
            if(customerId == nil){
                if  self.catalogProductViewModel.catalogProductModel.review_status == 1 && self.catalogProductViewModel.catalogProductModel.review_guest == 1{
                    self.addYourReviewButton.isHidden = false
                }else if self.catalogProductViewModel.catalogProductModel.review_status == 1 && self.catalogProductViewModel.catalogProductModel.review_guest == 0{
                    self.addYourReviewButton.isHidden = true
                }
                
            }else{
                if self.catalogProductViewModel.catalogProductModel.review_status == 1{
                    self.addYourReviewButton.isHidden = false
                }
            }
            
            if self.catalogProductViewModel.catalogProductModel.review_status == 1{
                self.viewAllReviewsView.isHidden = false
            }
            
       
            
            /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
            //////////////////////////////////////////////OPTION           /////////////////////////////////////////////////////////////////////////////////////
            
            self.specialrice.isHidden = true;
             if self.catalogProductViewModel.getSpecialprice != 0 && self.catalogProductViewModel.getSpecialprice  > 0{
                self.productpriceLabel.text = self.catalogProductViewModel.catalogProductModel.formatted_special;
                
                let attributeString = NSMutableAttributedString(string: self.catalogProductViewModel.getPrice)
                attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 1, range: NSRange(location: 0, length: attributeString.length))
                self.specialrice.attributedText = attributeString
                self.specialrice.isHidden = false
                self.specialrice.textColor = UIColor().HexToColor(hexString: REDCOLOR)
                
            }
            
            
            var Y:CGFloat = 0
            
            
            if self.catalogProductViewModel.getOption.count > 0 {
                
                for i in 0..<self.catalogProductViewModel.getOption.count {
                    var dict = JSON(self.catalogProductViewModel.getOption[i]);
                    let optionLbl = UILabel(frame: CGRect(x: 5, y: Y, width: self.optionView.frame.size.width - 10, height: 30))
                    optionLbl.textColor = UIColor.black
                    optionLbl.backgroundColor = UIColor.clear
                    optionLbl.font = UIFont(name: BOLDFONT, size: 15)
                    if dict["required"].intValue == 1{
                        optionLbl.text = dict["name"].stringValue+" "+ASTERISK
                    }else{
                        optionLbl.text = dict["name"].stringValue
                    }
                    self.optionView.addSubview(optionLbl)
                    Y += 30;
                    
                    if dict["type"].stringValue == "radio"{
                        let subOptionView = UIView(frame: CGRect(x: 5, y: Y, width: self.optionView.frame.size.width - 10, height: 30))
                        subOptionView.isUserInteractionEnabled = true
                        self.optionView.addSubview(subOptionView)
                        subOptionView.tag = i
                        self.radioId[i] = ""
                        Y += 30;
                        let productOptionArray : JSON = JSON(dict["product_option_value"].arrayObject!)
                        let buttonArray:NSMutableArray = []
                        var internalY:CGFloat = 0
                        for j in 0..<productOptionArray.count {
                            let btn = RadioButton(frame: CGRect(x: 5, y: internalY, width: subOptionView.frame.size.width, height: 30))
                            btn.setTitle(productOptionArray[j]["name"].stringValue, for: .normal)
                            btn.setTitleColor(UIColor.darkGray, for: .normal)
                            btn.titleLabel?.font = UIFont.init(name: REGULARFONT, size: 13.0)
                            btn.setImage(UIImage(named: "unchecked.png"), for: .normal)
                            btn.setImage(UIImage(named: "checked.png"), for: .selected)
                            if let languageCode =  sharedPrefrence.object(forKey: "language") as? String{
                                if languageCode == "ar"{
                                    btn.contentHorizontalAlignment = .right
                                }else{
                                    btn.contentHorizontalAlignment = .left
                                }
                            }
                            btn.contentHorizontalAlignment = .left
                            btn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 6, bottom: 0, right: 0)
                            btn.addTarget(self, action: #selector(self.onRadioButtonValueChangedAccount), for:.touchUpInside)
                            btn.tag = j;
                            subOptionView.addSubview(btn)
                            internalY += 40;
                            buttonArray.add(btn)
                        }
                        
                        var paymentInformationContainerFrame = subOptionView.frame
                        paymentInformationContainerFrame.size.height = internalY
                        subOptionView.frame = paymentInformationContainerFrame
                        let radioButton:RadioButton = RadioButton()
                        radioButton.groupButtons = buttonArray as! [RadioButton]
                        
                        Y += internalY;
                        
                    }else if dict["type"].stringValue == "checkbox"{
                        let subOptionView = UIView(frame: CGRect(x: 5, y: Y, width: self.optionView.frame.size.width - 10, height: 30))
                        subOptionView.isUserInteractionEnabled = true
                        subOptionView.tag = 8000 + i;
                        self.optionView.addSubview(subOptionView)
                        Y += 30;
                        let productOptionArray : JSON = JSON(dict["product_option_value"].arrayObject!)
                        var internalY:CGFloat = 0
                        for j in 0..<productOptionArray.count {
                            let checkBox = UISwitch(frame: CGRect(x:10, y:internalY+10, width:40, height:40))
                            checkBox.isOn = false
                            checkBox.tag = j
                            subOptionView.addSubview(checkBox)
                            let name = UILabel(frame: CGRect(x: checkBox.frame.size.width+25, y: internalY+10, width: self.optionView.frame.size.width - 60, height: 30))
                            name.textColor = UIColor.black
                            name.backgroundColor = UIColor.clear
                            name.textAlignment = .left
                            name.font = UIFont.init(name: REGULARFONT, size: 13.0)
                            
                            if productOptionArray[j]["price"].stringValue != ""{
                                name.text = productOptionArray[j]["name"].stringValue+" ("+productOptionArray[j]["price_prefix"].stringValue+productOptionArray[j]["price"].stringValue+")"
                            }else{
                                name.text = productOptionArray[j]["name"].stringValue
                            }
                            subOptionView.addSubview(name)
                            
                            internalY += 40;
                            
                        }
                        var paymentInformationContainerFrame = subOptionView.frame
                        paymentInformationContainerFrame.size.height = internalY
                        subOptionView.frame = paymentInformationContainerFrame
                        Y += internalY;
                        
                    }else if dict["type"].stringValue == "text"{
                        let textField = UITextField(frame: CGRect(x: 5, y: Y, width: self.optionView.frame.size.width - 10, height: 50))
                        textField.placeholder = "entertext".localized
                        textField.borderStyle = UITextField.BorderStyle.roundedRect
                        textField.keyboardType = UIKeyboardType.default
                        textField.tag = 9000;
                        textField.backgroundColor = UIColor.white
                        textField.font = UIFont.init(name: REGULARFONT, size: 13.0)
                        textField.isUserInteractionEnabled = true
                        textField.textAlignment = UITextField().isLanguageLayoutDirectionRightToLeft() ? .right : .left;
                        self.optionView.addSubview(textField)
                        Y += 60
                    }else if dict["type"].stringValue == "date"{
                        let textField = UITextField(frame: CGRect(x: 5, y: Y, width: self.optionView.frame.size.width - 10, height: 50))
                        textField.placeholder = "selectdate".localized
                        textField.tag = 1000;
                        textField.borderStyle = UITextField.BorderStyle.roundedRect
                        textField.addTarget(self, action: #selector(self.selectDatePicker), for: UIControl.Event.editingDidBegin)
                        textField.keyboardType = UIKeyboardType.default
                        textField.backgroundColor = UIColor.white
                        textField.font = UIFont.init(name: REGULARFONT, size: 13.0)
                        textField.isUserInteractionEnabled = true
                        textField.tintColor = UIColor.clear
                        textField.textAlignment = UITextField().isLanguageLayoutDirectionRightToLeft() ? .right : .left;
                        self.optionView.addSubview(textField)
                        Y += 60
                        
                    }else if dict["type"].stringValue == "time"{
                        let textField = UITextField(frame: CGRect(x: 5, y: Y, width: self.optionView.frame.size.width - 10, height: 50))
                        textField.placeholder = "selecttime".localized
                        textField.tag = 2000;
                        textField.borderStyle = UITextField.BorderStyle.roundedRect
                        textField.addTarget(self, action: #selector(self.selectDatePicker), for: UIControl.Event.editingDidBegin)
                        textField.keyboardType = UIKeyboardType.default
                        textField.backgroundColor = UIColor.white
                        textField.font = UIFont.init(name: REGULARFONT, size: 13.0)
                        textField.isUserInteractionEnabled = true
                        textField.tintColor = UIColor.clear
                        textField.textAlignment = UITextField().isLanguageLayoutDirectionRightToLeft() ? .right : .left;
                        self.optionView.addSubview(textField)
                        Y += 60
                        
                    }else if dict["type"].stringValue == "datetime"{
                        let textField = UITextField(frame: CGRect(x: 5, y: Y, width: self.optionView.frame.size.width - 10, height: 50))
                        textField.placeholder = "selectdateandtime".localized
                        textField.tag = 3000;
                        textField.borderStyle = UITextField.BorderStyle.roundedRect
                        textField.addTarget(self, action: #selector(self.selectDatePicker), for: UIControl.Event.editingDidBegin)
                        textField.keyboardType = UIKeyboardType.default
                        textField.backgroundColor = UIColor.white
                        textField.font = UIFont.init(name: REGULARFONT, size: 13.0)
                        textField.isUserInteractionEnabled = true
                        textField.tintColor = UIColor.clear
                        textField.textAlignment = UITextField().isLanguageLayoutDirectionRightToLeft() ? .right : .left;
                        self.optionView.addSubview(textField)
                        Y += 60
                        
                    }else if dict["type"].stringValue == "textarea"{
                        let textView = UITextView(frame: CGRect(x: 5, y: Y, width: self.optionView.frame.size.width - 10, height: 80))
                        textView.keyboardType = UIKeyboardType.default
                        textView.backgroundColor = UIColor.white
                        textView.tag = 10000
                        textView.font = UIFont.init(name: REGULARFONT, size: 13.0)
                        textView.layer.borderColor = UIColor.lightGray.cgColor
                        textView.layer.borderWidth = 0.5
                        textView.textAlignment = UITextField().isLanguageLayoutDirectionRightToLeft() ? .right : .left;
                        textView.isUserInteractionEnabled = true
                        self.optionView.addSubview(textView)
                        Y += 110
                        
                    }else if dict["type"].stringValue == "select"{
                        self.selectArr[i] = JSON(dict["product_option_value"].arrayObject ?? [])
                        self.selectID[i] = ""
                        let textField = UITextField(frame: CGRect(x: 5, y: Y, width: self.optionView.frame.size.width - 10, height: 50))
                        textField.placeholder = "pleaseselect".localized
                        textField.tag = 7000 + i;
                        textField.borderStyle = UITextField.BorderStyle.roundedRect
                        textField.addTarget(self, action: #selector(self.selectOptionPicker), for: UIControl.Event.editingDidBegin)
                        textField.keyboardType = UIKeyboardType.default
                        textField.backgroundColor = UIColor.white
                        textField.textAlignment = UITextField().isLanguageLayoutDirectionRightToLeft() ? .right : .left;
                        textField.font = UIFont.init(name: REGULARFONT, size: 13.0)
                        textField.isUserInteractionEnabled = true
                        textField.tintColor = UIColor.clear
                        self.optionView.addSubview(textField)
                        Y += 60
                        
                    }else if dict["type"].stringValue == "file"{
                        self.fileCodeValue = ""
                        let textField = UITextField(frame: CGRect(x: 5, y: Y, width: self.optionView.frame.size.width - 10, height: 50))
                        textField.placeholder = "pleaseselectfile".localized
                        textField.tag = 15000;
                        textField.borderStyle = UITextField.BorderStyle.roundedRect
                        textField.addTarget(self, action: #selector(self.selectFile), for: UIControl.Event.editingDidBegin)
                        textField.keyboardType = UIKeyboardType.default
                        textField.backgroundColor = UIColor.white
                        textField.font = UIFont.init(name: REGULARFONT, size: 13.0)
                        textField.textAlignment = UITextField().isLanguageLayoutDirectionRightToLeft() ? .right : .left;
                        textField.isUserInteractionEnabled = true
                        self.optionView.addSubview(textField)
                        Y += 60
                        
                    }
                    
                    
                        
                    self.optionViewHeightConstarints.constant = Y
                   
                }
            }
            
        }
        
    }
    
    
    @objc func onRadioButtonValueChangedAccount(_ sender: RadioButton) {
        if ((sender.selected) != nil){
            var dict = JSON(self.catalogProductViewModel.getOption[(sender.superview?.tag)!]);
            if dict["type"].stringValue == "radio"{
                let productOptionArray : JSON = JSON(dict["product_option_value"].arrayObject!)
                radioId[(sender.superview?.tag)!] = productOptionArray[sender.tag]["product_option_value_id"].stringValue
            }
            
            
        }
        
        
    }
    
    
    
    @objc func selectOptionPicker(textField: UITextField){
        currentOptionTag = textField.tag - 7000
        let selectPicker = UIPickerView()
        selectPicker.tag = 8000 + currentOptionTag;
        textField.inputView = selectPicker
        
        selectPicker.delegate = self
        let dict = selectArr[currentOptionTag]
        if (dict?.count)! > 0{
            if dict![0]["price"].stringValue != ""{
              let str : String = dict![0]["name"].stringValue + "(" + dict![0]["price"].stringValue + ")"
              textField.text = str
            }else{
                let str : String = dict![0]["name"].stringValue
                textField.text = str
            }
            selectID[currentOptionTag] = dict![0]["product_option_value_id"].stringValue
        }
        
    }
    
    
    @IBAction func addToCartAction(_ sender: UIButton) {
        var isValid = 0;
        var errorMessage:String = "pleaseselect".localized+" "
        optionDictionary = [String:AnyObject]()
        
        print(productId)
        
        for i in 0..<self.catalogProductViewModel.getOption.count {
            var dict = JSON(self.catalogProductViewModel.getOption[i]);
            
            if dict["type"].stringValue == "radio"{
                if dict["required"].intValue == 1{
                    if radioId[i] == ""{
                        isValid = 1;
                        errorMessage = errorMessage+dict["name"].stringValue
                        break
                    }else{
                        optionDictionary[dict["product_option_id"].stringValue] = radioId[i] as AnyObject
                    }
                    
                }else{
                    optionDictionary[dict["product_option_id"].stringValue] = radioId[i] as AnyObject
                }
                
            }
                
                
            else if dict["type"].stringValue == "checkbox"{
                let checkBoxArry:NSMutableArray = []
                let productOptionArray : JSON = JSON(dict["product_option_value"].arrayObject!)
                let  checkBoxView = self.optionView.viewWithTag(8000 + i);
                for j in 0..<productOptionArray.count {
                    let switchValue = checkBoxView?.viewWithTag(j) as! UISwitch
                    if switchValue.isOn{
                        checkBoxArry.add(productOptionArray[j]["product_option_value_id"].stringValue)
                    }
                }
                if checkBoxArry.count == 0{
                    isValid = 1;
                    errorMessage = errorMessage+dict["name"].stringValue
                    break
                }else{
                    optionDictionary[dict["product_option_id"].stringValue] = checkBoxArry
                }
                
                
            }
            else if dict["type"].stringValue == "text"{
                let textField:UITextField = self.optionView.viewWithTag(9000) as! UITextField
                if textField.text == ""{
                    isValid = 1;
                    errorMessage = dict["name"].stringValue+" "+"required".localized
                    break
                }else{
                    optionDictionary[dict["product_option_id"].stringValue] = textField.text as AnyObject
                }
                
            }
            else if dict["type"].stringValue == "date"{
                let textField:UITextField = self.optionView.viewWithTag(1000) as! UITextField
                if textField.text == ""{
                    isValid = 1;
                    errorMessage = dict["name"].stringValue+" "+"required".localized
                    break
                }else{
                    optionDictionary[dict["product_option_id"].stringValue] = textField.text as AnyObject
                }
                
            }
            else if dict["type"].stringValue == "time"{
                let textField:UITextField = self.optionView.viewWithTag(2000) as! UITextField
                if textField.text == ""{
                    isValid = 1;
                    errorMessage = dict["name"].stringValue+" "+"required".localized
                    break
                }else{
                    optionDictionary[dict["product_option_id"].stringValue] = textField.text as AnyObject
                }
                
            }
            else if dict["type"].stringValue == "datetime"{
                let textField:UITextField = self.optionView.viewWithTag(3000) as! UITextField
                if textField.text == ""{
                    isValid = 1;
                    errorMessage = dict["name"].stringValue+" "+"required".localized
                    break
                }else{
                    optionDictionary[dict["product_option_id"].stringValue] = textField.text as AnyObject
                }
                
            }
            else if dict["type"].stringValue == "textarea"{
                let textField:UITextView = self.optionView.viewWithTag(10000) as! UITextView
                if textField.text == ""{
                    isValid = 1;
                    errorMessage = dict["name"].stringValue+" "+"required".localized
                    break
                }else{
                    optionDictionary[dict["product_option_id"].stringValue] = textField.text as AnyObject
                }
                
            }
            else if dict["type"].stringValue == "select"{
                let textField:UITextField = self.optionView.viewWithTag(7000 + i) as! UITextField
                if dict["required"].intValue == 1{
                    if textField.text == ""{
                        isValid = 1;
                        errorMessage = errorMessage+dict["name"].stringValue
                        break
                    }else{
                        optionDictionary[dict["product_option_id"].stringValue] = selectID[i] as AnyObject;
                    }
                }else{
                    optionDictionary[dict["product_option_id"].stringValue] = selectID[i] as AnyObject
                }
                
                
            }else if dict["type"].stringValue == "file"{
                if dict["required"].intValue == 1{
                    if fileCodeValue == ""{
                        isValid = 1
                        errorMessage = errorMessage+dict["name"].stringValue
                        break
                    }else{
                        optionDictionary[dict["product_option_id"].stringValue] = self.fileCodeValue as AnyObject
                    }
                }else{
                    optionDictionary[dict["product_option_id"].stringValue] = fileCodeValue as AnyObject
                }
                
                
            }
            
            
        }
        
        if isValid == 1{
            NetworkManager.sharedInstance.showErrorSnackBar(msg: errorMessage)
            goToBagFlag = false;
        }else{
            whichApiToProcess = "addtocart"
            self.callingHttppApi()
        }
        
        
    }
    
    func openProduct(productId:String,productName:String){
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let initViewController: CatalogProduct? = (sb.instantiateViewController(withIdentifier: "catalogproduct") as? CatalogProduct)
        initViewController?.productId = productId;
        initViewController?.productName = productName
        initViewController?.modalTransitionStyle = .flipHorizontal
        self.navigationController?.pushViewController(initViewController!, animated: true)
        
        
    }
    
    
    @IBAction func shareToOther(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
        let productUrl = catalogProductViewModel.getHref;
        let activityItems = [productUrl]
        let activityController = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        if UI_USER_INTERFACE_IDIOM() == .phone {
            self.present(activityController, animated: true, completion:nil)
        }
        else {
            let popup = UIPopoverController(contentViewController: activityController)
            popup.present(from: CGRect(x: CGFloat(self.view.frame.size.width / 2), y: CGFloat(self.view.frame.size.height / 4), width: CGFloat(0), height: CGFloat(0)), in: self.view, permittedArrowDirections: .any, animated: true)
        }
        
        
    }
    
    @IBAction func addToWishListClick(_ sender: UITapGestureRecognizer) {
        let customerId = defaults.object(forKey: "customer_id")
        if(customerId == nil){
            let AC = UIAlertController(title: "warning".localized, message: "loginrequired".localized, preferredStyle: .alert)
            let okBtn = UIAlertAction(title: "ok".localized, style: .default, handler: {(_ action: UIAlertAction) -> Void in
            })
            AC.addAction(okBtn)
            
            self.parent!.present(AC, animated: true, completion: nil)
        }
        else{
            if self.catalogProductViewModel.catalogProductModel.wishlist_status == 0{
                whichApiToProcess = "adtowishlist"
            }else{
                whichApiToProcess = "removewishlist"
            }
            callingHttppApi();
            
            
        }
    }
    
    
    
    @IBAction func showRelatedProducts(_ sender: Any) {
        
        if catalogProductViewModel.relatedProduct.count > 0{
            
            self.tabBarController?.tabBar.isHidden = true
            let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "relatedproduct") as! RelatedProductController
            popOverVC.catalogProductViewModel = catalogProductViewModel;
            popOverVC.delegate = self
            popOverVC.modalPresentationStyle = .overCurrentContext
            popOverVC.modalTransitionStyle = .coverVertical
            self.present(popOverVC, animated: true, completion: nil)
        }else{
            NetworkManager.sharedInstance.showWarningSnackBar(msg: NetworkManager.sharedInstance.language(key: "norelatedproduct"))
            
            
        }
    }
    
    
    @objc func selectFile(textField: UITextField) {
        view.endEditing(true)
        let importMenu = UIDocumentMenuViewController(documentTypes: [String(kUTTypePNG),String(kUTTypeImage),String(kUTTypePDF),String(kUTTypeData)], in: .import)
        importMenu.delegate = self
        importMenu.modalPresentationStyle = .popover
        importMenu.popoverPresentationController?.sourceView = self.view
        self.present(importMenu, animated: true, completion: nil)
        
    }
    
    
    @available(iOS 8.0, *)
    public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
        
        let cico = url as URL
        print("The Url is : /(cico)", cico)
        let type:String = NetworkManager.sharedInstance.getMimeType(type:cico.pathExtension.lowercased())
        
        if let d = NSData(contentsOf: cico) as Data?{
            weatherData = d
            self.uplaodImages(data:weatherData!,fileName:url.absoluteString,mimetype:type)
        }

    }
    
    @available(iOS 8.0, *)
    public func documentMenu(_ documentMenu:     UIDocumentMenuViewController, didPickDocumentPicker documentPicker: UIDocumentPickerViewController) {
        documentPicker.delegate = self
        present(documentPicker, animated: true, completion: nil)
        
    }
    
    
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        dismiss(animated: true, completion: nil)
        
        
    }
    
    func uplaodImages(data:Data,fileName:String,mimetype:String){
        DispatchQueue.main.async {
            let UploadUrl:String = BASE_DOMAIN+"tool/upload"
            Alamofire.upload(multipartFormData: { multipartFormData in
                
                multipartFormData.append(data, withName: "file", fileName: fileName, mimeType: mimetype)
                print("success");
                
                
            },
                             to: UploadUrl,method:HTTPMethod.post,encodingCompletion: { encodingResult in
                                switch encodingResult {
                                case .success(let upload, _, _):
                                    upload
                                        .validate()
                                        .responseJSON { response in
                                            switch response.result {
                                            case .success(let value):
                                              
                                                let dict = JSON(value as! NSDictionary)
                                                self.fileCodeValue = dict["code"].stringValue
                                                if let field = self.optionView.viewWithTag(15000) as? UITextField{
                                                    field.text = fileName
                                                }
                                            case .failure(let responseError):
                                                
                                                print("responseError: \(responseError)")
                                            }
                                    }
                                case .failure(let encodingError):
                                    print("encodingError: \(encodingError)")
                                }
            })
            
        }
        
        
    }
    
    
    
    
    
    
     @objc func selectDatePicker(textField: UITextField) {
         let dateFormatter = DateFormatter()
        if (textField.viewWithTag(1000) != nil) {
            let datePickerView:UIDatePicker = UIDatePicker()
            datePickerView.tag = 4000;
            datePickerView.datePickerMode = UIDatePicker.Mode.date
            textField.inputView = datePickerView
            dateFormatter.dateFormat = "dd-MM-yyyy"
            textField.text = dateFormatter.string(from: datePickerView.date)
            datePickerView.addTarget(self, action: #selector(CatalogProduct.datePickerFromValueChanged), for: UIControl.Event.valueChanged)
        }else if(textField.viewWithTag(2000) != nil) {
            let datePickerView:UIDatePicker = UIDatePicker()
            datePickerView.tag = 5000;
            datePickerView.datePickerMode = UIDatePicker.Mode.time
            textField.inputView = datePickerView
            dateFormatter.dateFormat = "HH:mm"
            textField.text = dateFormatter.string(from: datePickerView.date)
            datePickerView.addTarget(self, action: #selector(CatalogProduct.datePickerFromValueChanged), for: UIControl.Event.valueChanged)
        }else if(textField.viewWithTag(3000) != nil) {
            let datePickerView:UIDatePicker = UIDatePicker()
            datePickerView.tag = 6000;
            datePickerView.datePickerMode = UIDatePicker.Mode.dateAndTime
            dateFormatter.dateFormat = "dd-MM-yyyy HH:mm"
            textField.text = dateFormatter.string(from: datePickerView.date)
            textField.inputView = datePickerView
            datePickerView.addTarget(self, action: #selector(CatalogProduct.datePickerFromValueChanged), for: UIControl.Event.valueChanged)
        }else if(textField.viewWithTag(7000) != nil) {
            let selectPicker = UIPickerView()
            selectPicker.tag = 8000;
            textField.inputView = selectPicker
            selectPicker.delegate = self
        }
        
        
    }
    
    
   @objc func datePickerFromValueChanged(sender:UIDatePicker) {
        let dateFormatter = DateFormatter()
        
        if sender.tag == 4000{
            dateFormatter.dateFormat = "dd-MM-yyyy"
            let textField = self.optionView.viewWithTag(1000) as! UITextField
            textField.text = dateFormatter.string(from: sender.date)
        }else if sender.tag == 5000{
            dateFormatter.dateFormat = "HH:mm"
            let textField = self.optionView.viewWithTag(2000) as! UITextField
            textField.text = dateFormatter.string(from: sender.date)
        }else if sender.tag == 6000{
            dateFormatter.dateFormat = "dd-MM-yyyy HH:mm"
            let textField = self.optionView.viewWithTag(3000) as! UITextField
            textField.text = dateFormatter.string(from: sender.date)
        }
        
    }
    
    
    
    
    
    

    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if(pickerView.tag == 8000 + currentOptionTag){
            let dict = selectArr[currentOptionTag]
            return (dict?.count)!
        }else{
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 8000 + currentOptionTag{
            let dict = selectArr[currentOptionTag]
            
            if dict![row]["price"].stringValue != ""{
                let str : String = dict![row]["name"].stringValue + "(" + dict![row]["price"].stringValue + ")"
                return str
            }else{
                let str : String = dict![row]["name"].stringValue
                return str
            }
        }else{
            return ""
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        if(pickerView.tag == 8000+currentOptionTag){
            let textField4 = self.optionView.viewWithTag(7000 + currentOptionTag) as! UITextField
            let dict = selectArr[currentOptionTag]
            if dict![row]["price"].stringValue != ""{
               textField4.text = dict![row]["name"].stringValue + "(" + dict![row]["price"].stringValue + ")"
            }else{
                textField4.text = dict![row]["name"].stringValue
            }
         
            selectID[currentOptionTag] = dict![row]["product_option_value_id"].stringValue
        }
    }
    
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier! == "gotodescription") {
            let viewController:Description = segue.destination as UIViewController as! Description
            viewController.descriptionData = catalogProductViewModel.getdescriptionData
            
        }
        else if (segue.identifier! == "reviewsData") {
            let viewController:ProductReviews = segue.destination as UIViewController as! ProductReviews
            viewController.productId = self.productId
            viewController.productName = self.productName
        }
        else if (segue.identifier! == "writeReview") {
            let viewController:WriteReview = segue.destination as UIViewController as! WriteReview
            viewController.productID = self.productId
            viewController.productNameValue = self.productName
            
        }else if (segue.identifier! == "specifiaction") {
            let viewController:CatalogSpecification = segue.destination as UIViewController as! CatalogSpecification
            viewController.catalogProductViewModel = self.catalogProductViewModel
            
        }
        
        
    }
    
    
    
    
    func zoomAction(){
        let homeDimView = UIView(frame: CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(SCREEN_WIDTH), height: CGFloat(SCREEN_HEIGHT)))
        homeDimView.backgroundColor = UIColor.white
        let currentWindow = UIApplication.shared.keyWindow
        homeDimView.tag = 888
        homeDimView.frame = (currentWindow?.bounds)!
        let cancel = UIImageView(frame: CGRect(x: CGFloat(SCREEN_WIDTH - 50), y: CGFloat(30), width: CGFloat(30), height: CGFloat(30)))
        cancel.image = UIImage(named: "ic_close")
        cancel.backgroundColor = UIColor().HexToColor(hexString: BUTTON_COLOR)
        cancel.isUserInteractionEnabled = true
        homeDimView.addSubview(cancel)
        let cancelTap = UITapGestureRecognizer(target: self, action: #selector(self.closeZoomTap))
        cancelTap.numberOfTapsRequired = 1
        cancel.addGestureRecognizer(cancelTap)
        
        var X:CGFloat = 0
        
        parentZoomingScrollView = UIScrollView(frame: CGRect(x: CGFloat(0), y: CGFloat(70), width: CGFloat(SCREEN_WIDTH), height: CGFloat(SCREEN_HEIGHT - 120)))
        parentZoomingScrollView.isUserInteractionEnabled = true
        parentZoomingScrollView.tag = 888888
        parentZoomingScrollView.delegate = self
        homeDimView.addSubview(parentZoomingScrollView)
        
        
        for i in 0..<imageArrayUrl.count {
            childZoomingScrollView = UIScrollView(frame: CGRect(x: CGFloat(X), y: CGFloat(0), width: CGFloat(SCREEN_WIDTH), height: CGFloat(SCREEN_HEIGHT - 120)))
            childZoomingScrollView.isUserInteractionEnabled = true
            childZoomingScrollView.tag = 90000 + i
            childZoomingScrollView.delegate = self
            parentZoomingScrollView.addSubview(childZoomingScrollView)
            imageZoom = UIImageView(frame: CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(SCREEN_WIDTH), height: CGFloat(SCREEN_HEIGHT - 120)))
            imageZoom.image = UIImage(named: "ic_placeholder.png")
            imageZoom.contentMode = .scaleAspectFit
            imageZoom.loadImageFrom(url:imageArrayUrl[i] as! String , dominantColor: "ffffff")
            
            imageZoom.isUserInteractionEnabled = true
            imageZoom.tag = 10
            childZoomingScrollView.addSubview(imageZoom)
            childZoomingScrollView.maximumZoomScale = 5.0
            childZoomingScrollView.clipsToBounds = true
            childZoomingScrollView.contentSize = CGSize(width: CGFloat(SCREEN_WIDTH), height: CGFloat(SCREEN_HEIGHT - 120))
            let doubleTap = UITapGestureRecognizer(target: self, action: #selector(self.handleDoubleTap))
            doubleTap.numberOfTapsRequired = 2
            imageZoom.addGestureRecognizer(doubleTap)
            X += SCREEN_WIDTH
        }
        
        parentZoomingScrollView.contentSize = CGSize(width: CGFloat(X), height: CGFloat(SCREEN_WIDTH))
        parentZoomingScrollView.isPagingEnabled = true
        let Y: CGFloat = 70 + SCREEN_HEIGHT - 120 + 5
        pager = UIPageControl(frame: CGRect(x: CGFloat(0), y: CGFloat(Y), width: CGFloat(SCREEN_WIDTH), height: CGFloat(50)))
        //SET a property of UIPageControl
        pager.backgroundColor = UIColor.clear
        pager.numberOfPages = imageArrayUrl.count
        //as we added 3 diff views
        pager.currentPage = 0
        pager.isHighlighted = true
        pager.pageIndicatorTintColor = UIColor.black
        pager.currentPageIndicatorTintColor = UIColor.red
        homeDimView.addSubview(pager)
        currentWindow?.addSubview(homeDimView)
        
        let newPosition = SCREEN_WIDTH * CGFloat(self.pageControl.currentPage)
        let toVisible = CGRect(x: CGFloat(newPosition), y: CGFloat(70), width: CGFloat(SCREEN_WIDTH), height: CGFloat(SCREEN_HEIGHT - 120))
        self.parentZoomingScrollView.scrollRectToVisible(toVisible, animated: true)
        
        
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        if scrollView.viewWithTag(90000 + currentTag) as? UIScrollView != nil{
            let scroll = scrollView.viewWithTag(90000 + currentTag) as! UIScrollView
            let image = scroll.viewWithTag(10) as! UIImageView
            return image
        }else{
            return nil
        }
    }
    
    @objc func handleDoubleTap(_ gestureRecognizer: UIGestureRecognizer) {
        let scroll = parentZoomingScrollView.viewWithTag(888888) as! UIScrollView
        let childScroll = scroll.viewWithTag(90000 + currentTag) as! UIScrollView
        let newScale: CGFloat = scroll.zoomScale * 1.5
        let zoomRect = self.zoomRect(forScale: newScale, withCenter: gestureRecognizer.location(in: gestureRecognizer.view))
        childScroll.zoom(to: zoomRect, animated: true)
    }
    
    func zoomRect(forScale scale: CGFloat, withCenter center: CGPoint) -> CGRect {
        var zoomRect = CGRect(x: 0, y: 0, width: 0, height: 0)
        let scroll = parentZoomingScrollView.viewWithTag(888888) as! UIScrollView
        let childScroll = scroll.viewWithTag(90000 + currentTag) as! UIScrollView
        zoomRect.size.height = childScroll.frame.size.height / scale
        zoomRect.size.width = childScroll.frame.size.width / scale
        zoomRect.origin.x = center.x - (zoomRect.size.width / 2.0)
        zoomRect.origin.y = center.y - (zoomRect.size.height / 2.0)
        return zoomRect
    }
    
    
    
    @objc func closeZoomTap(_ gestureRecognizer: UIGestureRecognizer) {
        let currentWindow = UIApplication.shared.keyWindow!
        currentWindow.viewWithTag(888)!.removeFromSuperview()
    }
    
    
    
    
    
    
    
    
    
    
}

