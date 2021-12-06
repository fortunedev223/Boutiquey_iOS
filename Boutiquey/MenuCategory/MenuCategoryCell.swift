//
//  menuCaegoryCell.swift
//  Boutiquey
//
//  Created by Alex on 31/07/2019.
//  Copyright © 2019 yogesh. All rights reserved.
//

import UIKit

class MenuCategoryCell: UITableViewCell {

    @IBOutlet weak var catimg: UIImageView!
    @IBOutlet weak var catlab: UILabel!
    @IBOutlet weak var cararrow: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        cararrow.image = UIImage(named: "ic_arrow")!
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
