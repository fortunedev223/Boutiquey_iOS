//

/*
 JaguarImport
 @Category Webkul
 @author Webkul
 Created by: kunal on 18/07/18
 FileName: PrivacyTableViewCell.swift
 Copyright (c) 2010-2018 Webkul Software Private Limited (https://webkul.com)
 @license https://store.webkul.com/license.html
 */


import UIKit

class PrivacyTableViewCell: UITableViewCell {
@IBOutlet var privacyMessage: UIButton!
@IBOutlet var mainView: UIView!
@IBOutlet var switchButton: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        mainView.layer.cornerRadius = 5;
        mainView.layer.masksToBounds = true
        mainView.layer.borderColor = UIColor().HexToColor(hexString: LIGHTGREY).cgColor
        mainView.layer.borderWidth = 0.5
        privacyMessage.setTitle(NetworkManager.sharedInstance.language(key: "privacypolicy"), for: .normal)
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    @IBAction func switchClick(_ sender: UISwitch) {
    }
    
    
    
    
    
    
}
