//
//  ProductReviewsTableViewCell.swift
//  Opencart
//
//  Created by Kunal Parsad on 07/09/17.
//  Copyright © 2017 Kunal Parsad. All rights reserved.
//

import UIKit

class ProductReviewsTableViewCell: UITableViewCell {

@IBOutlet weak var name: UILabel!
@IBOutlet weak var descriptiontext: UILabel!
@IBOutlet weak var dateValue: UILabel!
@IBOutlet weak var ratingValue: HCSStarRatingView!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
