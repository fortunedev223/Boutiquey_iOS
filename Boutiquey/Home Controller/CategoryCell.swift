//
//  CategoryCell.swift
//  WooCommerce
//
//  Created by Kunal Parsad on 01/11/17.
//  Copyright © 2017 Kunal Parsad. All rights reserved.
//

import UIKit

class CategoryCell: UICollectionViewCell {

@IBOutlet weak var imageView: UIImageView!
@IBOutlet weak var labelName: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageView?.layer.cornerRadius = 30
        imageView?.clipsToBounds = true
        imageView.layer.borderColor = UIColor.black.cgColor
        imageView.layer.borderWidth = 0.2
        labelName.textColor = UIColor().HexToColor(hexString: LIGHTGREY)
        
    }

}
