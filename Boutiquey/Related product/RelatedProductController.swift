//
//  RelatedProductController.swift
//  Magento2MobikulNew
//
//  Created by Kunal Parsad on 16/08/17.
//  Copyright © 2017 Kunal Parsad. All rights reserved.
//

import UIKit


@objc protocol RelatedProductHandlerDelegate: class {
    func openProduct(productId:String,productName:String);
    
}



class RelatedProductController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
var delegate:RelatedProductHandlerDelegate?

@IBOutlet weak var collectionView: UICollectionView!
@IBOutlet weak var viewHeight: NSLayoutConstraint!
var catalogProductViewModel:CatalogProductViewModel!
let defaults = UserDefaults.standard;
var optionDictionary = [String:AnyObject]()
var whichApiToProcess:String = ""
var productId:String!
var productName:String!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.clear
        view.isOpaque = false
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        viewHeight.constant = SCREEN_HEIGHT/2
        let nib = UINib(nibName: "NewandFeatureProductCollectionViewCell", bundle:nil)
        self.collectionView.register(nib, forCellWithReuseIdentifier: "newandfeaturecell")
        collectionView.delegate = self;
        collectionView.dataSource = self
        collectionView.reloadData()
    }
    
    func callingHttppApi(){
        DispatchQueue.main.async{
            let sessionId = self.defaults.object(forKey:"wk_token");
            NetworkManager.sharedInstance.showLoader()
            let width = String(format:"%f", SCREEN_WIDTH * UIScreen.main.scale)
            var requstParams = [String:Any]();
            requstParams["width"] = width
            requstParams["product_id"] = self.productId
            requstParams["wk_token"] = sessionId
            
            if self.whichApiToProcess == "addtocart"{
                requstParams["quantity"] = "1"
                requstParams["option"] = self.optionDictionary
                
                NetworkManager.sharedInstance.callingHttpRequest(params:requstParams, apiname:"cart/addToCart", cuurentView: self){success,responseObject in
                    if success == 1{
                        let dict = responseObject as! NSDictionary;
                        
                        if dict.object(forKey: "fault") != nil{
                            let fault = dict.object(forKey: "fault") as! Bool;
                            if fault == true{
                                self.loginRequest()
                            }
                        }else{
                            let dict = responseObject as! NSDictionary
                            NetworkManager.sharedInstance.dismissLoader()
                            if dict.object(forKey: "error") as! Int == 0{
                                NetworkManager.sharedInstance.showSuccessSnackBar(msg: dict.object(forKey: "message") as! String)
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
            else if self.whichApiToProcess == "addtowishlist"{
                NetworkManager.sharedInstance.showLoader()
                let sessionId = self.defaults.object(forKey:"wk_token");
                var requstParams = [String:Any]();
                requstParams["product_id"] = self.productId
                requstParams["wk_token"] = sessionId
                NetworkManager.sharedInstance.showLoader()
                NetworkManager.sharedInstance.callingHttpRequest(params:requstParams, apiname:"catalog/addToWishlist", cuurentView: self){success,responseObject in
                    if success == 1{
                        let dict = JSON(responseObject as! NSDictionary)
                        
                        if dict["fault"].intValue == 1{
                                self.loginRequest()
                        }else{
                            NetworkManager.sharedInstance.dismissLoader()
                            self.view.isUserInteractionEnabled = true
                            if dict["error"].intValue == 0{
                                NetworkManager.sharedInstance.showSuccessSnackBar(msg:dict["message"].stringValue)
                                
                            }else{
                                NetworkManager.sharedInstance.showWarningSnackBar(msg: dict["message"].stringValue)
                            }
                        }
                    }else if success == 2{
                        NetworkManager.sharedInstance.dismissLoader()
                        self.callingHttppApi()
                    }
                }
            }else if self.whichApiToProcess == "removetowishlist"{
                self.view.isUserInteractionEnabled = false
                NetworkManager.sharedInstance.showLoader()
                let sessionId = self.defaults.object(forKey:"wk_token");
                var requstParams = [String:Any]();
                requstParams["wk_token"] = sessionId;
                requstParams["product_id"] = self.productId;
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
                                NetworkManager.sharedInstance.showSuccessSnackBar(msg: dict.object(forKey: "message") as! String)
                            }
                        }
                    }else if success == 2{
                        NetworkManager.sharedInstance.dismissLoader()
                        self.callingHttppApi();
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
    
    
    
    


 
   
    @IBAction func removeView(_ sender: Any) {
            UIView.animate(withDuration: 0.25, animations: {
                self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
                self.view.alpha = 0.0;
            }, completion:{(finished : Bool)  in
                if (finished){
                    self.tabBarController?.tabBar.isHidden = false
                    self.dismiss(animated: true, completion: nil)
                    
                    
                }
            });
        }
    
    
    
    func collectionView(_ view: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return catalogProductViewModel.getRelatedProduct.count;
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "newandfeaturecell", for: indexPath) as! NewandFeatureProductCollectionViewCell
        cell.layer.borderColor = UIColor().HexToColor(hexString: LIGHTGREY).cgColor
        cell.layer.borderWidth = 0.5
        cell.imageView.image = UIImage(named: "ic_placeholder.png")
        cell.productName.text = catalogProductViewModel.getRelatedProduct[indexPath.row].name
        cell.priceLabel.text = catalogProductViewModel.getRelatedProduct[indexPath.row].price
        cell.imageView.loadImageFrom(url:catalogProductViewModel.getRelatedProduct[indexPath.row].imageURL , dominantColor: "ffffff")
        
        cell.addToCartButton.tag = indexPath.row
        let Gesture1 = UITapGestureRecognizer(target: self, action: #selector(self.addToCart))
        Gesture1.numberOfTapsRequired = 1
        cell.addToCartButton.isUserInteractionEnabled = true;
        cell.addToCartButton.addGestureRecognizer(Gesture1)
        let Gesture2 = UITapGestureRecognizer(target: self, action: #selector(self.viewProduct))
        Gesture2.numberOfTapsRequired = 1
        cell.imageView.addGestureRecognizer(Gesture2)
        cell.imageView.tag = indexPath.row
        cell.wishList.tag = indexPath.row
        let Gesture3 = UITapGestureRecognizer(target: self, action: #selector(self.wishList))
        Gesture3.numberOfTapsRequired = 1
        cell.wishList.addGestureRecognizer(Gesture3)
        
        if catalogProductViewModel.getRelatedProduct[indexPath.row].specialPrice != 0  && (catalogProductViewModel.getRelatedProduct[indexPath.row].specialPrice) > 0{
            cell.specialPriceLabel.isHidden = false;
            cell.priceLabel.text =  catalogProductViewModel.getRelatedProduct[indexPath.row].formatted_special
            let attributeString = NSMutableAttributedString(string: catalogProductViewModel.getRelatedProduct[indexPath.row].price)
            attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 1, range: NSRange(location: 0, length: attributeString.length))
            cell.specialPriceLabel.attributedText = attributeString
        }
        
        
        if catalogProductViewModel.getRelatedProduct[indexPath.row].wishlist_status == 1{
            cell.wishList.image = #imageLiteral(resourceName: "ic_wishlist_fill")
        }else{
            cell.wishList.image = #imageLiteral(resourceName: "ic_wishlist_empty")
        }
        
        return cell;
        
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
            return CGSize(width: collectionView.frame.size.width/2, height:collectionView.frame.size.height - 16)
    }
    
    func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }

    
    @objc func wishList(_ recognizer: UITapGestureRecognizer) {
        let customerId = defaults.object(forKey: "customer_id")
        let imageView = recognizer.view as! UIImageView
        
        
        if(customerId == nil){
            let AC = UIAlertController(title: "warning".localized, message: "loginrequired".localized, preferredStyle: .alert)
            let okBtn = UIAlertAction(title: "ok".localized, style: .default, handler: {(_ action: UIAlertAction) -> Void in
            })
            AC.addAction(okBtn)
            self.present(AC, animated: true, completion: nil)
        }else{
            productId = catalogProductViewModel.getRelatedProduct[(recognizer.view?.tag)!].productId
            productName = catalogProductViewModel.getRelatedProduct[(recognizer.view?.tag)!].name
            
            if catalogProductViewModel.getRelatedProduct[(recognizer.view?.tag)!].wishlist_status == 0{
              whichApiToProcess = "addtowishlist"
              imageView.image = #imageLiteral(resourceName: "ic_wishlist_fill")
              catalogProductViewModel.relatedProduct[(recognizer.view?.tag)!].wishlist_status = 1
            }else{
              whichApiToProcess = "removetowishlist"
              imageView.image = #imageLiteral(resourceName: "ic_wishlist_empty")
              catalogProductViewModel.relatedProduct[(recognizer.view?.tag)!].wishlist_status = 0
            }
            
            callingHttppApi()
        }
    }
    
    
    @objc func addToCart(_ recognizer: UITapGestureRecognizer) {
        if catalogProductViewModel.getRelatedProduct[(recognizer.view?.tag)!].hasOption == 1{
            UIView.animate(withDuration: 0.25, animations: {
                self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
                self.view.alpha = 0.0;
            }, completion:{(finished : Bool)  in
                if (finished){
                    self.tabBarController?.tabBar.isHidden = false
                    self.dismiss(animated: true, completion: nil)
                    
                    
                }
            });
            productId = catalogProductViewModel.getRelatedProduct[(recognizer.view?.tag)!].productId
            let productName = catalogProductViewModel.getRelatedProduct[(recognizer.view?.tag)!].name
            self.delegate?.openProduct(productId: productId!, productName: productName!);
            
        }else{
            productId = catalogProductViewModel.getRelatedProduct[(recognizer.view?.tag)!].productId
            whichApiToProcess = "addtocart"
            callingHttppApi()
        }
    
    }
    
    
    @objc func viewProduct(_ recognizer: UITapGestureRecognizer) {
        UIView.animate(withDuration: 0.25, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.view.alpha = 0.0;
        }, completion:{(finished : Bool)  in
            if (finished){
                self.tabBarController?.tabBar.isHidden = false
                self.dismiss(animated: true, completion: nil)
                
                
            }
        });
        productId = catalogProductViewModel.getRelatedProduct[(recognizer.view?.tag)!].productId
        let productName = catalogProductViewModel.getRelatedProduct[(recognizer.view?.tag)!].name
        self.delegate?.openProduct(productId: productId!, productName: productName!);
        
        
    }
    
    
    
    
    
}
