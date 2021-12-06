//

/*
 JaguarImport
 @Category Webkul
 @author Webkul
 Created by: kunal on 18/07/18
 FileName: CommentCell.swift
 Copyright (c) 2010-2018 Webkul Software Private Limited (https://webkul.com)
 @license https://store.webkul.com/license.html
 */


import UIKit

class CommentCell: UITableViewCell {
    
    @IBOutlet var addcommnetLabel: UILabel!
    
    @IBOutlet var commentField: UITextField!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        addcommnetLabel.text = "addcommentaboutorder".localized
        commentField.placeholder = NetworkManager.sharedInstance.language(key: "commentplaceholder")
        commentField.applyTextFieldAlingment()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    
    @IBAction func commentClick(_ sender: UITextField) {
    }
    
    
    
    
    
    
    
}
