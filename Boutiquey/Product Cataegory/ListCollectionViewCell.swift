//
//  ListCollectionViewCell.swift
//  Magento2MobikulNew
//
//  Created by Kunal Parsad on 09/08/17.
//  Copyright © 2017 Kunal Parsad. All rights reserved.
//

import UIKit

class ListCollectionViewCell: UICollectionViewCell {
    
    
@IBOutlet weak var imageView: UIImageView!
@IBOutlet weak var name: UILabel!
@IBOutlet weak var descriptionData: UILabel!
@IBOutlet weak var price: UILabel!
@IBOutlet weak var quickView: UIButton!
@IBOutlet weak var specialPriceLabel: UILabel!
@IBOutlet weak var addToCartButton: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        quickView.setTitle(NetworkManager.sharedInstance.language(key: "addtocart"), for: .normal)
        quickView.layer.cornerRadius = 5;
        quickView.layer.masksToBounds = true
        quickView.backgroundColor = UIColor.white
        
        specialPriceLabel.isHidden = true;
        addToCartButton.setTitleColor(UIColor.white, for: .normal)
        addToCartButton.backgroundColor = UIColor().HexToColor(hexString: BUTTON_COLOR)
        addToCartButton.setTitle(NetworkManager.sharedInstance.language(key: "addtocart"), for: .normal)
        addToCartButton.layer.cornerRadius = 5;
        addToCartButton.layer.masksToBounds = true
    }

}
