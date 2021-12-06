//
//  CartTableViewCell.swift
//  Magento2MobikulNew
//
//  Created by Kunal Parsad on 29/08/17.
//  Copyright © 2017 Kunal Parsad. All rights reserved.
//

protocol UpdateCartHandlerDelegate {
    func updateAPICall()
}



import UIKit

class CartTableViewCell: UITableViewCell {
@IBOutlet weak var productName: UILabel!

@IBOutlet weak var qtyTextField: UITextField!
@IBOutlet weak var priceValue: UILabel!
@IBOutlet weak var subTotalValue: UILabel!
@IBOutlet weak var removeButton: UIButton!
@IBOutlet weak var productImageView: UIImageView!
@IBOutlet weak var qtyLabel: UILabel!
@IBOutlet weak var priceLabel: UILabel!
@IBOutlet weak var subtotalLabel: UILabel!
@IBOutlet weak var qtyStepper: UIStepper!
var myCartViewModel:CartViewModel!
@IBOutlet weak var mainView: UIView!
@IBOutlet var extraLabel: UILabel!
@IBOutlet var stockMessageLabel: UILabel!
@IBOutlet var updateIndicator: UIActivityIndicatorView!
var delegate:UpdateCartHandlerDelegate!
    
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        mainView.layer.cornerRadius = 10
        mainView.myBorder()
        extraLabel.textColor = UIColor().HexToColor(hexString: LIGHTGREY)
        qtyStepper.tintColor = UIColor().HexToColor(hexString: BUTTON_COLOR)
        stockMessageLabel.text = ""
        stockMessageLabel.textColor = UIColor().HexToColor(hexString: REDCOLOR)
    }
    
    
    override func layoutSubviews() {
        priceLabel.text = NetworkManager.sharedInstance.language(key: "price")
        qtyLabel.text = NetworkManager.sharedInstance.language(key: "qty")
        subtotalLabel.text = NetworkManager.sharedInstance.language(key: "subtotal")
        priceLabel.textColor = UIColor().HexToColor(hexString: LIGHTGREY)
        qtyLabel.textColor = UIColor().HexToColor(hexString: LIGHTGREY)
        subtotalLabel.textColor = UIColor().HexToColor(hexString: LIGHTGREY)
 
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func stepperClick(_ sender: UIStepper) {
        let value =   String(format:"%d",Int(sender.value));
        qtyTextField.text = value
        myCartViewModel.setDataToCartModel(data: value, pos: sender.tag)
        updateIndicator.startAnimating()
        delegate.updateAPICall()
        //NetworkManager.sharedInstance.showInfoSnackBar(msg: "updatecartplease".localized);
    }
    
    
    
    
}
