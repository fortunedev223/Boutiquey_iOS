//
//  WishlistsTableViewCell.swift
//  OpenCartApplication
//
//  Created by shobhit on 24/08/17.
//  Copyright © 2017 webkul. All rights reserved.
//

import UIKit

class WishlistsTableViewCell: UITableViewCell {
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productNameLbl: UILabel!
    @IBOutlet weak var productPriceLbl: UILabel!
    @IBOutlet weak var stockAvailabilityLbl: UILabel!
    @IBOutlet weak var specialPriceLbl: UILabel!
    
    
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        specialPriceLbl.isHidden = true;
        // Initialization code
    }

   
    
}
