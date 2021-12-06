//
//  TopCategoryTableViewCell.swift
//  WooCommerce
//
//  Created by Kunal Parsad on 01/11/17.
//  Copyright © 2017 Kunal Parsad. All rights reserved.
//

import UIKit

@objc protocol CategoryViewControllerHandlerDelegate: class {
     func categoryProductClick(name:String,ID:String,isChild:Bool)
}


class TopCategoryTableViewCell: UITableViewCell {
    
var delegate:CategoryViewControllerHandlerDelegate!
@IBOutlet weak var categoryCollectionView: UICollectionView!
@IBOutlet weak var collectionViewHeight: NSLayoutConstraint!
var featureCategoryCollectionModel = [Categories]()

    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.collectionViewHeight.constant = 120
        categoryCollectionView.register(UINib(nibName: "CategoryCell", bundle: nil), forCellWithReuseIdentifier: "categorycell")
        categoryCollectionView.delegate = self
        categoryCollectionView.dataSource = self
        categoryCollectionView.reloadData()
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        
        super.setSelected(selected, animated: animated)

    }
    
    static var nib:UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    static var identifier: String {
        return String(describing: self)
    }
    
    
   
    
}
extension TopCategoryTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource , UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return featureCategoryCollectionModel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "categorycell", for: indexPath) as! CategoryCell
         cell.imageView.loadImageFrom(url:featureCategoryCollectionModel[indexPath.row].image , dominantColor: featureCategoryCollectionModel[indexPath.row].dominant_color_icon)
         cell.labelName.text = featureCategoryCollectionModel[indexPath.row].name
       
        return cell
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 60 , height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        delegate.categoryProductClick(name:featureCategoryCollectionModel[indexPath.row].name , ID: featureCategoryCollectionModel[indexPath.row].id, isChild: featureCategoryCollectionModel[indexPath.row].isChild)
    }
}
