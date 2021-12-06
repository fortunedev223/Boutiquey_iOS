//
//  RecentViewTableViewCell.swift
//  MobikulMagento-2
//
//  Created by himanshu on 15/05/18.
//  Copyright © 2018 kunal. All rights reserved.
//

import UIKit

@objc protocol RecentProductViewControllerHandlerDelegate: class {
    func recentProductClick(name:String,image:String,id:String)
}

class RecentViewTableViewCell: UITableViewCell {
    
    @IBOutlet weak var recentViewLabel: UILabel!
    @IBOutlet weak var recentViewCollectionView: UICollectionView!
    
    var recentCollectionModel = [Productcollection]()
    var delegate:RecentProductViewControllerHandlerDelegate!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        recentViewCollectionView.register(UINib(nibName: "ProductImageCell", bundle: nil), forCellWithReuseIdentifier: "productimagecell")
        recentViewCollectionView.delegate = self
        recentViewCollectionView.dataSource = self
        recentViewLabel.text = NetworkManager.sharedInstance.language(key: "RecentViews")
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

extension RecentViewTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource , UICollectionViewDelegateFlowLayout{
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recentCollectionModel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "productimagecell", for: indexPath) as! ProductImageCell
        
        cell.myBorder()
        cell.productImage.image = UIImage(named: "ic_placeholder.png")
        cell.productImage.loadImageFrom(url:recentCollectionModel[indexPath.row].image , dominantColor: "ffffff")
        cell.productName.text = recentCollectionModel[indexPath.row].name
        cell.productPrice.text = recentCollectionModel[indexPath.row].price
        cell.layoutIfNeeded()
        cell.specialPrice.isHidden = true
        cell.saleLabel.isHidden = true
        cell.addToCartButton_home.isHidden = true
        if recentCollectionModel[indexPath.row].specialPrice != 0  && (recentCollectionModel[indexPath.row].specialPrice) > 0{
            cell.specialPrice.isHidden = false
            cell.productPrice.text =  recentCollectionModel[indexPath.row].formatted_special
            let attributeString = NSMutableAttributedString(string: recentCollectionModel[indexPath.row].price)
            attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 1, range: NSRange(location: 0, length: attributeString.length))
            cell.specialPrice.attributedText = attributeString
            cell.saleLabel.isHidden = false
            
        }
        
        cell.wishListButton.isHidden = true
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width/2 , height: collectionView.frame.size.width/2 + 70)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row < recentCollectionModel.count{
            delegate.recentProductClick(name: recentCollectionModel[indexPath.row].name, image: recentCollectionModel[indexPath.row].image, id: recentCollectionModel[indexPath.row].ProductID)
        }
    }
    
    
}

