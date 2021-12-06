//
//  FootermenuCell.swift
//  Boutiquey
//
//  Created by Alex on 04/08/2019.
//  Copyright © 2019 yogesh. All rights reserved.
//

import UIKit

class FootermenuCell: UITableViewCell {

    @IBOutlet weak var footermenu_label: UILabel!
    @IBOutlet weak var footarrow: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        footarrow.image = UIImage(named: "ic_arrow")!
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
