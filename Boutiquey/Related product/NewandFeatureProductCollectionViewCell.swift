//
//  NewandFeatureProductCollectionViewCell.swift
//  Magento2MobikulNew
//
//  Created by Kunal Parsad on 01/08/17.
//  Copyright © 2017 Kunal Parsad. All rights reserved.
//

import UIKit

class NewandFeatureProductCollectionViewCell: UICollectionViewCell {

@IBOutlet weak var productName: UILabel!
@IBOutlet weak var imageView: UIImageView!
@IBOutlet weak var startRatings: HCSStarRatingView!
@IBOutlet weak var priceLabel: UILabel!
@IBOutlet weak var addToCartButton: UIButton!
@IBOutlet weak var wishList: UIImageView!
@IBOutlet weak var specialPriceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
      
    addToCartButton.setTitle(NetworkManager.sharedInstance.language(key: "addtocart"), for: .normal)
    addToCartButton.layer.cornerRadius = 5;
    addToCartButton.layer.masksToBounds = true
    addToCartButton.backgroundColor = UIColor().HexToColor(hexString: BUTTON_COLOR)
    startRatings.tintColor = UIColor().HexToColor(hexString: BUTTON_COLOR)
        specialPriceLabel.isHidden = true;
        
        
    }
    
    
}
