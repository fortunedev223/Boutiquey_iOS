//
//  Productcategory.swift
//  OpenCartApplication
//
//  Created by Kunal Parsad on 30/08/17.
//  Copyright © 2017 webkul. All rights reserved.
//

import UIKit

class Productcategory: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,FilterControllerHandlerDelegate {
    var categoryId:String!
    var categoryName:String!
    var categoryType:String = ""
    let defaults = UserDefaults.standard;
    var whichApiToProcess:String = ""
    var pageNumber:Int = 1
    var productCollectionViewModel:ProductCollectionViewModel!
    var change:Bool = true
    var loadPageRequestFlag:Bool = true;
    var totalCount:Int = 0
    var indexPathValue:IndexPath!
    var sortDataPicker: UIPickerView!
    var sortValue:String = ""
    var sortOrder:String = ""
    var productId:String = ""
    var productName:String = ""
    var ImageIurl:String = ""
    var productprice:String = ""
    var searchQuery:String = ""
    var emptyView:EmptyNewAddressView!
    
@IBOutlet weak var sortbyLabel: UILabel!
@IBOutlet weak var filterbyLabel: UILabel!
@IBOutlet weak var productCollectionView: UICollectionView!
@IBOutlet weak var ic_grid_list_imageview: UIImageView!
var selectedFilterIDs:NSMutableArray = []
@IBOutlet var sortView: UIView!
var footerView:CustomFooterView?
let footerViewReuseIdentifier = "RefreshFooterView"
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = categoryName;
        whichApiToProcess = ""
        let sessionId = defaults.object(forKey:"wk_token")
        productCollectionView.register(UINib(nibName: "ProductImageCell", bundle: nil), forCellWithReuseIdentifier: "productimagecell")
        self.productCollectionView.register(UINib(nibName: "CustomFooterView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "RefreshFooterView")
        
        
        if(sessionId == nil){
            loginRequest();
        }
        else{
            callingHttppApi();
            
        }
        
        
        sortbyLabel.text = NetworkManager.sharedInstance.language(key: "sort")
        filterbyLabel.text = NetworkManager.sharedInstance.language(key: "filter")
        emptyView = EmptyNewAddressView(frame: self.productCollectionView.frame);
        emptyView.emptyImages.image = UIImage(named: "empty_category")!
        emptyView.addressButton.setTitle(NetworkManager.sharedInstance.language(key: "tryagain"), for: .normal)
        emptyView.labelMessage.text = NetworkManager.sharedInstance.language(key: "noproduct")
        emptyView.addressButton.addTarget(self, action: #selector(browseCategory(sender:)), for: .touchUpInside)

        emptyView.addressButton.isHidden = true
        sortView.isHidden = true
        
    }
    
    @objc func browseCategory(sender: UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
    
    func refresh(_ refreshControl: UIRefreshControl) {
        refreshControl.endRefreshing()
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if(velocity.y>0) {
            UIView.animate(withDuration: 2.5, delay: 0, options: UIView.AnimationOptions(), animations: {
                self.navigationController?.setNavigationBarHidden(true, animated: true)
            }, completion: nil)
            
        } else {
            UIView.animate(withDuration: 2.5, delay: 0, options: UIView.AnimationOptions(), animations: {
                self.navigationController?.setNavigationBarHidden(false, animated: true)
            }, completion: nil)
        }
        
    }
    
    
    
    @IBAction func changeView(_ sender: UITapGestureRecognizer) {
        if change == false{
            ic_grid_list_imageview.image = UIImage(named: "ic_grid")
            change = true;
            let nib = UINib(nibName: "ProductImageCell", bundle:nil)
            self.productCollectionView.register(nib, forCellWithReuseIdentifier: "Productimagecell")
            productCollectionView.reloadData()
        }else{
            ic_grid_list_imageview.image = UIImage(named: "ic_list")
            change = false;
            let nib = UINib(nibName: "ListCollectionViewCell", bundle:nil)
            self.productCollectionView.register(nib, forCellWithReuseIdentifier: "listcollectionview")
            productCollectionView.reloadData()
            
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
            let sessionId = self.defaults.object(forKey:"wk_token");
            var requstParams = [String:Any]();
            
            if self.categoryType == "manufacture"{
                    requstParams["page"] = "\(self.pageNumber)"
                    let width = String(format:"%f", SCREEN_WIDTH * UIScreen.main.scale)
                    requstParams["width"] = width
                    if self.pageNumber == 1{
                        NetworkManager.sharedInstance.showLoader()
                        self.view.isUserInteractionEnabled = false
                    }
                    requstParams["manufacturer_id"] = self.categoryId
                    requstParams["order"] = self.sortOrder
                    requstParams["sort"] = self.sortValue
                    
                    requstParams["limit"] = "20"
                    requstParams["wk_token"] = sessionId
                    NetworkManager.sharedInstance.callingHttpRequest(params:requstParams, apiname:"catalog/manufacturerInfo", cuurentView: self){success,responseObject in
                        if success == 1{
                            let dict = responseObject as! NSDictionary;
                            
                            if dict.object(forKey: "fault") != nil{
                                let fault = dict.object(forKey: "fault") as! Bool;
                                if fault == true{
                                    self.loginRequest()
                                }
                            }else{
                                
                                self.view.isUserInteractionEnabled = true
                          
                                if self.pageNumber == 1{
                                    self.productCollectionViewModel = ProductCollectionViewModel(data:JSON(responseObject as! NSDictionary) , type: "manufacture")
                                }else{
                                    self.productCollectionViewModel.setProductCollectionData(data:JSON(responseObject as! NSDictionary),type:"manufacture")
                                }
                                self.doFurtherProcessingWithResult()
                                NetworkManager.sharedInstance.dismissLoader()
                                
                                
                            }
                        }else if success == 2{
                            NetworkManager.sharedInstance.dismissLoader()
                            self.callingHttppApi()
                        }
                }
            }else if self.categoryType == "custom"{
                    requstParams["page"] = "\(self.pageNumber)"
                    let width = String(format:"%f", SCREEN_WIDTH * UIScreen.main.scale)
                    requstParams["width"] = width
                    if self.pageNumber == 1{
                        NetworkManager.sharedInstance.showLoader()
                        self.view.isUserInteractionEnabled = false
                    }
                    requstParams["id"] = self.categoryId
                    requstParams["wk_token"] = sessionId
                    NetworkManager.sharedInstance.callingHttpRequest(params:requstParams, apiname:"catalog/customCollection", cuurentView: self){success,responseObject in
                        if success == 1{
                            let dict = responseObject as! NSDictionary;
                            
                            if dict.object(forKey: "fault") != nil{
                                let fault = dict.object(forKey: "fault") as! Bool;
                                if fault == true{
                                    self.loginRequest()
                                }
                            }else{
                                self.view.isUserInteractionEnabled = true
                                
                              
                                if self.pageNumber == 1{
                                    self.productCollectionViewModel = ProductCollectionViewModel(data:JSON(responseObject as! NSDictionary), type: "search")
                                }else{
                                    self.productCollectionViewModel.setProductCollectionData(data:JSON(responseObject as! NSDictionary),type:"search")
                                }
                                self.doFurtherProcessingWithResult()
                                NetworkManager.sharedInstance.dismissLoader()
                                
                            }
                        }else if success == 2{
                            NetworkManager.sharedInstance.dismissLoader()
                            self.callingHttppApi();
                        }
                }
                
            }
            else if self.categoryType == "search"{
                    requstParams["page"] = "\(self.pageNumber)"
                    let width = String(format:"%f", SCREEN_WIDTH * UIScreen.main.scale)
                    requstParams["width"] = width
                    if self.pageNumber == 1{
                        NetworkManager.sharedInstance.showLoader()
                        self.view.isUserInteractionEnabled = false
                    }
                    requstParams["search"] = self.searchQuery
                    requstParams["order"] = self.sortOrder
                    requstParams["sort"] = self.sortValue
                    
                    requstParams["limit"] = "20"
                    requstParams["wk_token"] = sessionId
                    NetworkManager.sharedInstance.callingHttpRequest(params:requstParams, apiname:"catalog/productSearch", cuurentView: self){success,responseObject in
                        if success == 1{
                            let dict = responseObject as! NSDictionary;
                            
                            if dict.object(forKey: "fault") != nil{
                                let fault = dict.object(forKey: "fault") as! Bool;
                                if fault == true{
                                    self.loginRequest()
                                }
                            }else{
                                self.view.isUserInteractionEnabled = true
                                
                               
                                if self.pageNumber == 1{
                                    self.productCollectionViewModel = ProductCollectionViewModel(data:JSON(responseObject as! NSDictionary), type: "search")
                                }else{
                                    self.productCollectionViewModel.setProductCollectionData(data:JSON(responseObject as! NSDictionary),type:"search")
                                }
                                self.doFurtherProcessingWithResult()
                                NetworkManager.sharedInstance.dismissLoader()
                                
                            }
                        }else if success == 2{
                            NetworkManager.sharedInstance.dismissLoader()
                            self.callingHttppApi()
                        }
                    }
                
            }else if self.categoryType == "crousal"{
                requstParams["page"] = "\(self.pageNumber)"
                let width = String(format:"%f", SCREEN_WIDTH * UIScreen.main.scale)
                requstParams["width"] = width
                if self.pageNumber == 1{
                    NetworkManager.sharedInstance.showLoader()
                    self.view.isUserInteractionEnabled = false
                }
                
                requstParams["order"] = self.sortOrder
                requstParams["sort"] = self.sortValue
                
                requstParams["limit"] = "10"
                requstParams["wk_token"] = sessionId
                
                NetworkManager.sharedInstance.callingHttpRequest(params:requstParams, apiname:"common/"+self.categoryId, cuurentView: self){success,responseObject in
                    if success == 1{
                        let dict = responseObject as! NSDictionary;
                        
                        if dict.object(forKey: "fault") != nil{
                            let fault = dict.object(forKey: "fault") as! Bool;
                            if fault == true{
                                self.loginRequest()
                            }
                        }else{
                            self.view.isUserInteractionEnabled = true
                            if self.pageNumber == 1{
                                self.productCollectionViewModel = ProductCollectionViewModel(data:JSON(responseObject as! NSDictionary), type: "crousal")
                            }else{
                                self.productCollectionViewModel.setProductCollectionData(data:JSON(responseObject as! NSDictionary),type:"crousal")
                            }
                            self.doFurtherProcessingWithResult()
                            NetworkManager.sharedInstance.dismissLoader()
                        }
                    }else if success == 2{
                        NetworkManager.sharedInstance.dismissLoader()
                        self.callingHttppApi()
                    }
                }
            }
            else{
                    requstParams["page"] = "\(self.pageNumber)"
                    let width = String(format:"%f", SCREEN_WIDTH * UIScreen.main.scale)
                    requstParams["width"] = width
                    if self.pageNumber == 1{
                        self.view.isUserInteractionEnabled = false
                        NetworkManager.sharedInstance.showLoader()
                    }
                    
                    requstParams["path"] = self.categoryId
                    requstParams["order"] = self.sortOrder
                    requstParams["sort"] = self.sortValue
                    
                    requstParams["limit"] = "20"
                    requstParams["wk_token"] = sessionId
                    
                    if self.selectedFilterIDs.count > 0{
                        var filterIds:String = ""
                        
                    for data in self.selectedFilterIDs{
                        filterIds += (data as? String)!+","
                    }
                    filterIds.remove(at: filterIds.index(before: filterIds.endIndex))
                    requstParams["filter"]  = filterIds
                    }
                
                    NetworkManager.sharedInstance.callingHttpRequest(params:requstParams, apiname:"catalog/productCategory", cuurentView: self){success,responseObject in
                        if success == 1{
                            let dict = responseObject as! NSDictionary;
                            
                            if dict.object(forKey: "fault") != nil{
                                let fault = dict.object(forKey: "fault") as! Bool;
                                if fault == true{
                                    self.loginRequest()
                                }
                            }else{
                                 self.view.isUserInteractionEnabled = true
                                
                              
                                if self.pageNumber == 1{
                                    self.productCollectionViewModel = ProductCollectionViewModel(data:JSON(responseObject as! NSDictionary), type: "")
                                }else{
                                    self.productCollectionViewModel.setProductCollectionData(data:JSON(responseObject as! NSDictionary),type:"")
                                }
                                self.doFurtherProcessingWithResult()
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
    
    
    func selectedFilterData(categories:NSMutableArray){
        self.selectedFilterIDs = categories
        self.pageNumber = 1
        callingHttppApi()
        
    }
    
    
    
    @IBAction func filterBY(_ sender: UITapGestureRecognizer) {
        
        
        if productCollectionViewModel.filterData.count  > 0{
            let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "filter") as! FilterController
            popOverVC.delegate = self;
            popOverVC.selectedFilterIDs = self.selectedFilterIDs
            popOverVC.productCollectionViewModel = self.productCollectionViewModel
            popOverVC.modalPresentationStyle = .overFullScreen
            popOverVC.modalTransitionStyle = .coverVertical
            self.present(popOverVC, animated: true, completion: nil)
        }else{
            NetworkManager.sharedInstance.showInfoSnackBar(msg: NetworkManager.sharedInstance.language(key: "nofilterdata"))
        }
    }
    
    @IBAction func sortBy(_ sender: UITapGestureRecognizer) {
        self.sortByTapped()
    }
    
    
    
    
    
    func doFurtherProcessingWithResult(){
        sortView.isHidden = false
        if self.pageNumber == 1{
            productCollectionView.delegate = self;
            productCollectionView.dataSource = self
        }
        
        if productCollectionViewModel.getProductCollectionData.count > 0{
            NetworkManager.sharedInstance.dismissLoader()
            
            totalCount = productCollectionViewModel.totalCount
            loadPageRequestFlag = true;
           
            
        }else{
            loadPageRequestFlag = true;
            totalCount = productCollectionViewModel.totalCount
        }
        
        productCollectionView.reloadData()
        
    }
    
    func collectionView(_ view: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if productCollectionViewModel.getProductCollectionData.count == 0{
            view.backgroundView = emptyView
            return 0
        }
        else {
           view.backgroundView = nil
           return productCollectionViewModel.getProductCollectionData.count
        }
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if change == true{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "productimagecell", for: indexPath) as! ProductImageCell
            cell.layer.borderColor = UIColor().HexToColor(hexString: LIGHTGREY).cgColor
            cell.layer.borderWidth = 0.5
            cell.productImage.backgroundColor = UIColor().HexToColor(hexString:productCollectionViewModel.getProductCollectionData[indexPath.row].dominant_color)
            cell.productName.text = productCollectionViewModel.getProductCollectionData[indexPath.row].productName
            cell.productPrice.text =  productCollectionViewModel.getProductCollectionData[indexPath.row].price
            
            
            cell.productImage.loadImageFrom(url:productCollectionViewModel.getProductCollectionData[indexPath.row].productImage , dominantColor: productCollectionViewModel.getProductCollectionData[indexPath.row].dominant_color)
            
            cell.specialPrice.isHidden = true
            cell.saleLabel.isHidden = true
            

           if productCollectionViewModel.getProductCollectionData[indexPath.row].specialPrice != 0  && (productCollectionViewModel.getProductCollectionData[indexPath.row].specialPrice) > 0{
                cell.specialPrice.isHidden = false;
                cell.productPrice.text =  productCollectionViewModel.getProductCollectionData[indexPath.row].formatted_special
                let attributeString = NSMutableAttributedString(string: productCollectionViewModel.getProductCollectionData[indexPath.row].price)
            attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 1, range: NSRange(location: 0, length: attributeString.length))
                cell.specialPrice.attributedText = attributeString
                cell.specialPrice.textColor = UIColor().HexToColor(hexString: REDCOLOR)
                cell.saleLabel.isHidden = false
            }
            
            cell.wishListButton.tag = indexPath.row
            cell.wishListButton.addTarget(self, action: #selector(addToWishList(sender:)), for: .touchUpInside)
            cell.wishListButton.isUserInteractionEnabled = true;
            
            if productCollectionViewModel.getProductCollectionData[indexPath.row].isInWishList == 1{
               cell.wishListButton.setImage( UIImage(named:"ic_wishlist_fill"), for: .normal)
            }else{
               cell.wishListButton.setImage( UIImage(named:"ic_wishlist_empty"), for: .normal)
            }
            
            
            cell.addToCartButton_home.tag = indexPath.row
            cell.addToCartButton_home.addTarget(self, action: #selector(addToCart(sender:)), for: .touchUpInside)
            cell.addToCartButton_home.isUserInteractionEnabled = true;
            
            
            cell.productImage.tag = indexPath.row
            let Gesture2 = UITapGestureRecognizer(target: self, action: #selector(self.viewProducts))
            Gesture2.numberOfTapsRequired = 1
            cell.productImage.isUserInteractionEnabled = true;
            cell.productImage.addGestureRecognizer(Gesture2)
            
            return cell;
        }
        else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "listcollectionview", for: indexPath) as! ListCollectionViewCell
            cell.layer.borderColor = UIColor().HexToColor(hexString: LIGHTGREY).cgColor
            cell.layer.borderWidth = 0.5
            cell.name.text = productCollectionViewModel.getProductCollectionData[indexPath.row].productName
            cell.price.text =  productCollectionViewModel.getProductCollectionData[indexPath.row].price
            cell.descriptionData.text = productCollectionViewModel.getProductCollectionData[indexPath.row].descriptionData
            
            cell.imageView.loadImageFrom(url:productCollectionViewModel.getProductCollectionData[indexPath.row].productImage , dominantColor: productCollectionViewModel.getProductCollectionData[indexPath.row].dominant_color)
            
            
            cell.quickView.tag = indexPath.row
            cell.quickView.addTarget(self, action: #selector(addToWishList(sender:)), for: .touchUpInside)
            cell.quickView.isUserInteractionEnabled = true;
            
            cell.addToCartButton.tag = indexPath.row
            cell.addToCartButton.addTarget(self, action: #selector(addToCart(sender:)), for: .touchUpInside)
            cell.addToCartButton.isUserInteractionEnabled = true;
            
            cell.imageView.tag = indexPath.row
            let Gesture2 = UITapGestureRecognizer(target: self, action: #selector(self.viewProducts))
            Gesture2.numberOfTapsRequired = 1
            cell.imageView.isUserInteractionEnabled = true;
            cell.imageView.addGestureRecognizer(Gesture2)
            
            
           if productCollectionViewModel.getProductCollectionData[indexPath.row].specialPrice != 0  && (productCollectionViewModel.getProductCollectionData[indexPath.row].specialPrice) > 0{
                cell.specialPriceLabel.isHidden = false;
                cell.price.text =  productCollectionViewModel.getProductCollectionData[indexPath.row].formatted_special
                let attributeString = NSMutableAttributedString(string: productCollectionViewModel.getProductCollectionData[indexPath.row].price)
            attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 1, range: NSRange(location: 0, length: attributeString.length))
                cell.specialPriceLabel.attributedText = attributeString
                cell.specialPriceLabel.textColor = UIColor().HexToColor(hexString: REDCOLOR)
            }
            
            
            if productCollectionViewModel.getProductCollectionData[indexPath.row].isInWishList == 1{
                cell.quickView.setImage( UIImage(named:"ic_wishlist_fill"), for: .normal)
            }else{
                cell.quickView.setImage( UIImage(named:"ic_wishlist_empty"), for: .normal)
            }
            
            
            return cell;
        }
        
    }
    
    
    
    @objc func addToCart(sender: UIButton){
        
        let hasOption = productCollectionViewModel.getProductCollectionData[(sender.tag)].hasOption
        if hasOption == 1{
            self.ImageIurl = productCollectionViewModel.getProductCollectionData[(sender.tag)].productImage
            self.productName = productCollectionViewModel.getProductCollectionData[(sender.tag)].productName
            self.productId = productCollectionViewModel.getProductCollectionData[(sender.tag)].id
            self.performSegue(withIdentifier: "productpage", sender: self)
        }else{
            whichApiToProcess = "addtocart"
            self.productId = productCollectionViewModel.getProductCollectionData[(sender.tag)].id
            self.callingExtraHttpi()
           
        }
    }
    
    @objc func addToWishList(sender: UIButton){
        let customerId = defaults.object(forKey: "customer_id")
        if(customerId == nil){
            let AC = UIAlertController(title: NetworkManager.sharedInstance.language(key: "warning"), message: NetworkManager.sharedInstance.language(key: "loginrequired"), preferredStyle: .alert)
            let okBtn = UIAlertAction(title: NetworkManager.sharedInstance.language(key: "ok"), style: .default, handler: {(_ action: UIAlertAction) -> Void in
                let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "CustomerLogin") as? CustomerLogin
                self.navigationController?.pushViewController(vc!, animated: true)
            })
            let cancelBtn = UIAlertAction(title: NetworkManager.sharedInstance.language(key: "cancel"), style: .default, handler: nil)
            AC.addAction(okBtn)
            AC.addAction(cancelBtn)
            
            self.parent!.present(AC, animated: true, completion: nil)
        }else{
            productId = productCollectionViewModel.getProductCollectionData[(sender.tag)].id;
            if productCollectionViewModel.getProductCollectionData[(sender.tag)].isInWishList == 0{
             
              whichApiToProcess = "addtowishlist";
              productCollectionViewModel.productCollectionModel[(sender.tag)].isInWishList = 1
              sender.setImage( UIImage(named:"ic_wishlist_fill"), for: .normal)
              callingExtraHttpi()
            }else{
                whichApiToProcess = "removetowishlist";
                productCollectionViewModel.productCollectionModel[(sender.tag)].isInWishList = 0
                sender.setImage( UIImage(named:"ic_wishlist_empty"), for: .normal)
                callingExtraHttpi()
            }
        }
        
        
    }
    
    @objc func viewProducts(_ recognizer: UITapGestureRecognizer){
        productId =    productCollectionViewModel.getProductCollectionData[(recognizer.view?.tag)!].id;
        productName = productCollectionViewModel.getProductCollectionData[(recognizer.view?.tag)!].productName;
        ImageIurl = productCollectionViewModel.getProductCollectionData[(recognizer.view?.tag)!].productImage;
        productprice = productCollectionViewModel.getProductCollectionData[(recognizer.view?.tag)!].price;
        self.performSegue(withIdentifier: "productpage", sender: self)
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier! == "productpage") {
            let viewController:CatalogProduct = segue.destination as UIViewController as! CatalogProduct
            viewController.productImageUrl = ImageIurl
            viewController.productId = self.productId
            viewController.productName = self.productName
            viewController.productPrice = self.productprice

        }
    }
    
    
    
    
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        if change == false{
            return CGSize(width: collectionView.frame.size.width, height:SCREEN_WIDTH/2 + 50)
        }else{
            return CGSize(width: collectionView.frame.size.width/2, height:SCREEN_WIDTH/2.5 + 140)
        }
    }
    
    func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        let currentCellCount = self.productCollectionView.numberOfItems(inSection: 0)
         if totalCount > currentCellCount{
            return CGSize(width: collectionView.bounds.size.width, height: 55)
        }else{
            return CGSize.zero
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionFooter {
            let aFooterView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: footerViewReuseIdentifier, for: indexPath) as! CustomFooterView
            self.footerView = aFooterView
            self.footerView?.backgroundColor = UIColor.clear
            return aFooterView
        } else {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: footerViewReuseIdentifier, for: indexPath)
            return headerView
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
        if elementKind == UICollectionView.elementKindSectionFooter {
            self.footerView?.startAnimate()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplayingSupplementaryView view: UICollectionReusableView, forElementOfKind elementKind: String, at indexPath: IndexPath) {
        if elementKind == UICollectionView.elementKindSectionFooter {
            self.footerView?.stopAnimate()
        }
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentCellCount = self.productCollectionView.numberOfItems(inSection: 0)
        for cell: UICollectionViewCell in self.productCollectionView.visibleCells {
            indexPathValue = self.productCollectionView.indexPath(for: cell)!
            if indexPathValue.row == self.productCollectionView.numberOfItems(inSection: 0) - 1 {
                if (totalCount > currentCellCount) && loadPageRequestFlag{
                    loadPageRequestFlag = false
                    pageNumber += 1;
                    whichApiToProcess = ""
                    callingHttppApi()
                }
            }
        }
    }
    
    
    func sortByTapped(){
        if self.productCollectionViewModel.getSortCollectionData.count == 0{
            NetworkManager.sharedInstance.showWarningSnackBar(msg:NetworkManager.sharedInstance.language(key: "nosortingdata") )
        }else{
            let alert = UIAlertController(title: NetworkManager.sharedInstance.language(key: "chooseyoursortselection"), message: nil, preferredStyle: .actionSheet)
            for i in 0..<self.productCollectionViewModel.getSortCollectionData.count {
                var image:UIImage!
                if productCollectionViewModel.getSortCollectionData[i].value == sortValue && productCollectionViewModel.getSortCollectionData[i].order == sortOrder {
                    image = UIImage(named: "ic_check")
                }else{
                    image = UIImage(named: "")
                }
                let str : String = productCollectionViewModel.getSortCollectionData[i].label
                let action = UIAlertAction(title: str, style: .default, handler: {(_ action: UIAlertAction) -> Void in
                    self.selectSortData(data:i)
                })
                action.setValue(image, forKey: "image")
                alert.addAction(action)
            }
            
            let cancel = UIAlertAction(title: NetworkManager.sharedInstance.language(key: "cancel"), style: .destructive, handler: {(_ action: UIAlertAction) -> Void in
            })
            alert.addAction(cancel)
            
            // Support display in iPad
            alert.popoverPresentationController?.sourceView = self.view
            alert.popoverPresentationController?.sourceRect = CGRect(x:self.view.bounds.size.width / 2.0, y: self.view.bounds.size.height / 2.0, width : 1.0, height : 1.0)
            self.present(alert, animated: true, completion: nil)
            
        }
        
        
        
        
    }
    
    func selectSortData(data:Int){
        sortOrder = self.productCollectionViewModel.getSortCollectionData[data].order
        sortValue = self.productCollectionViewModel.getSortCollectionData[data].value
        whichApiToProcess = ""
        pageNumber = 1
        callingHttppApi();
    }
    
    
    


    
    override func willMove(toParent parent: UIViewController?) {
        super.willMove(toParent: parent)
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.isNavigationBarHidden = false
        NetworkManager.sharedInstance.removePreviousNetworkCall()
        NetworkManager.sharedInstance.dismissLoader()
      
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    
    
    func callingExtraHttpi(){
        if self.whichApiToProcess == "addtowishlist"{
            self.view.isUserInteractionEnabled = false
            NetworkManager.sharedInstance.showLoader()
            let sessionId = self.defaults.object(forKey:"wk_token");
            var requstParams = [String:Any]();
            requstParams["product_id"] = self.productId
            requstParams["wk_token"] = sessionId
            NetworkManager.sharedInstance.callingHttpRequest(params:requstParams, apiname:"catalog/addToWishlist", cuurentView: self){success,responseObject in
                if success == 1{
                    let dict = responseObject as! NSDictionary;
                    
                    if dict.object(forKey: "fault") != nil{
                        let fault = dict.object(forKey: "fault") as! Bool;
                        if fault == true{
                            self.loginRequest()
                        }
                    }else{
                     
                        self.view.isUserInteractionEnabled = true
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
            
        }else if self.whichApiToProcess == "addtocart"{
            self.view.isUserInteractionEnabled = false
            NetworkManager.sharedInstance.showLoader()
            let sessionId = self.defaults.object(forKey:"wk_token");
            var requstParams = [String:Any]();
            requstParams["wk_token"] = sessionId;
            let width = String(format:"%f", SCREEN_WIDTH * UIScreen.main.scale)
            requstParams["width"] = width
            requstParams["product_id"] = self.productId
            requstParams["quantity"] = "1"
            NetworkManager.sharedInstance.callingHttpRequest(params:requstParams, apiname:"cart/addToCart", cuurentView: self){val,responseObject in
                if val == 1 {
                    let dict = responseObject as! NSDictionary;
                    if dict.object(forKey: "fault") != nil{
                        let fault = dict.object(forKey: "fault") as! Bool;
                        if fault == true{
                            self.extraLoginRequest()
                        }
                    }else{
                      
                        self.view.isUserInteractionEnabled = true
                        NetworkManager.sharedInstance.dismissLoader()
                        let dict = responseObject as! NSDictionary
                        if dict.object(forKey: "error") as! Int == 0{
                            NetworkManager.sharedInstance.showSuccessSnackBar(msg: dict.object(forKey: "message") as! String)
                            let data = dict.object(forKey: "total") as! String
                         //   self.tabBarController!.tabBar.items?[2].badgeValue = data.components(separatedBy: " ")[0]
                            ViewController.selfVC.notificationButton.badge = data.components(separatedBy: " ")[0]
                            ViewController.selfVC.countofcart = data.components(separatedBy: " ")[0]
                            
                        }else{
                            NetworkManager.sharedInstance.showWarningSnackBar(msg: dict.object(forKey: "message") as! String)
                        }
                        
                    }
                    
                }else if val == 2{
                    NetworkManager.sharedInstance.dismissLoader()
                    self.callingExtraHttpi()
                    
                    
                }
            }
        }else if whichApiToProcess == "removetowishlist"{
            self.view.isUserInteractionEnabled = false
            NetworkManager.sharedInstance.showLoader()
            let sessionId = self.defaults.object(forKey:"wk_token");
            var requstParams = [String:Any]();
            requstParams["wk_token"] = sessionId;
            requstParams["product_id"] = productId;
            NetworkManager.sharedInstance.callingHttpRequest(params:requstParams, apiname:"customer/removeFromWishlist", cuurentView: self){success,responseObject in
                
                if success == 1 {
                    
                    let dict = responseObject as! NSDictionary;
                    if dict.object(forKey: "fault") != nil{
                        let fault = dict.object(forKey: "fault") as! Bool;
                        if fault == true{
                            self.extraLoginRequest()
                        }
                    }else{
                        self.view.isUserInteractionEnabled = true
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
                self.callingExtraHttpi()
            }else if val == 2{
                NetworkManager.sharedInstance.dismissLoader()
                self.extraLoginRequest()
                
            }
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
}
