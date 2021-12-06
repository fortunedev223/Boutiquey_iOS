//
//  ExtraCartTableViewCell.swift
//  Magento2MobikulNew
//
//  Created by Kunal Parsad on 29/08/17.
//  Copyright © 2017 Kunal Parsad. All rights reserved.
//

import UIKit

class ExtraCartTableViewCell: UITableViewCell {

@IBOutlet weak var applyVoucharCode: UIButton!
@IBOutlet weak var updateCartButton: UIButton!
@IBOutlet weak var applyCoupanCodeButton: UIButton!
@IBOutlet weak var view1: UIView!
@IBOutlet weak var view2: UIView!
@IBOutlet weak var view3: UIView!
@IBOutlet var mainView: UIStackView!
    
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        applyVoucharCode.setTitleColor(UIColor.black, for: .normal)
        updateCartButton.setTitleColor(UIColor.black, for: .normal)
        applyCoupanCodeButton.setTitleColor(UIColor.black, for: .normal)
        view1.backgroundColor = UIColor.white
        view1.layer.cornerRadius = 5;
        view1.layer.borderWidth = 1
        view1.layer.borderColor = UIColor().HexToColor(hexString: LIGHTGREY).cgColor
        
        view2.backgroundColor = UIColor.white
        view2.layer.cornerRadius = 5;
        view2.layer.borderWidth = 1
        view2.layer.borderColor = UIColor().HexToColor(hexString: LIGHTGREY).cgColor
        
        view3.backgroundColor = UIColor.white
        view3.layer.cornerRadius = 5;
        view3.layer.borderWidth = 1
        view3.layer.borderColor = UIColor().HexToColor(hexString: LIGHTGREY).cgColor
       
        
        
        
    }

    override func layoutSubviews() {
       applyVoucharCode.setTitle(NetworkManager.sharedInstance.language(key: "applyvoucharcode"), for: .normal)
       updateCartButton.setTitle(NetworkManager.sharedInstance.language(key: "updatecart"), for: .normal)
       applyCoupanCodeButton.setTitle(NetworkManager.sharedInstance.language(key: "entercoupan"), for: .normal)
    
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
