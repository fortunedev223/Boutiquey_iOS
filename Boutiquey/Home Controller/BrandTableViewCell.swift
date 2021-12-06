//
//  BrandTableViewCell.swift
//  OpenCartMpV3
//
//  Created by kunal on 11/12/17.
//  Copyright © 2017 kunal. All rights reserved.
//




@objc protocol BrandViewControllerHandlerDelegate: class {
    func brandProductClick(name:String,ID:String)
}


import UIKit

class BrandTableViewCell: UITableViewCell {
@IBOutlet weak var collectionView: UICollectionView!
var brandCollectionModel = [BrandProducts]()
var delegate:BrandViewControllerHandlerDelegate!
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.register(UINib(nibName: "BannerImageCell", bundle: nil), forCellWithReuseIdentifier: "bannerImageCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        
        
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


extension BrandTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource , UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       return brandCollectionModel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "bannerImageCell", for: indexPath) as! BannerImageCell
        cell.myBorder()
        cell.bannerImageView.loadImageFrom(url:brandCollectionModel[indexPath.row].image , dominantColor: brandCollectionModel[indexPath.row].dominant_color)
        
        cell.layoutIfNeeded()
        
        return cell
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width/3, height: SCREEN_WIDTH/3 - 16)
    }
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            delegate.brandProductClick(name: brandCollectionModel[indexPath.row].title, ID: brandCollectionModel[indexPath.row].link)
        
    }
    
   
    
}
