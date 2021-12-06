//
//  ProductImageCell.swift
//  WooCommerce
//
//  Created by Kunal Parsad on 04/11/17.
//  Copyright © 2017 Kunal Parsad. All rights reserved.
//

import UIKit

class ProductImageCell: UICollectionViewCell {

@IBOutlet weak var productImage: UIImageView!
@IBOutlet weak var productName: UILabel!
@IBOutlet weak var productPrice: UILabel!
@IBOutlet weak var specialPrice: UILabel!
@IBOutlet weak var wishListButton: UIButton!
@IBOutlet weak var addToCartButton: UIButton!
@IBOutlet weak var addToCartButton_home: UIButton!
    
@IBOutlet var saleLabel: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        specialPrice.isHidden = true
        addToCartButton.setTitleColor(UIColor.white, for: .normal)
        addToCartButton.backgroundColor = UIColor().HexToColor(hexString: BUTTON_COLOR)
        addToCartButton.setTitle("addtocart".localized, for: .normal)
        addToCartButton.layer.cornerRadius = 5;
        addToCartButton.layer.masksToBounds = true
        
        addToCartButton_home.setTitleColor(UIColor.white, for: .normal)
        addToCartButton_home.backgroundColor = UIColor().HexToColor(hexString: BUTTON_COLOR)
        addToCartButton_home.setTitle("addtocart".localized, for: .normal)
        addToCartButton_home.layer.cornerRadius = 5;
        addToCartButton_home.layer.masksToBounds = true
        
        productName.textColor = UIColor().HexToColor(hexString: LIGHTGREY)
        saleLabel.text = " "+"sale".localized+" "
        saleLabel.layer.cornerRadius = 3;
        saleLabel.layer.masksToBounds = true
        saleLabel.backgroundColor = UIColor().HexToColor(hexString: BUTTON_COLOR)
        saleLabel.isHidden = true
        
    }

}
