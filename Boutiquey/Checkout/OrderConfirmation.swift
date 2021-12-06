//
//  OrderConfirmation.swift
//  OpenCartApplication
//
//  Created by Kunal Parsad on 04/09/17.
//  Copyright © 2017 webkul. All rights reserved.
//

import UIKit

class OrderConfirmation: UIViewController {
@IBOutlet weak var messageLabel: UILabel!
@IBOutlet weak var continueButton: UIButton!
var successMessage:String!
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        messageLabel.text = successMessage;
        continueButton.backgroundColor = UIColor().HexToColor(hexString: BUTTON_COLOR)
        self.tabBarController?.tabBar.isHidden = true
        self.navigationItem.setHidesBackButton(true, animated:true);
        
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.title = NetworkManager.sharedInstance.language(key: "orderplaced");
        self.continueButton.setTitle(NetworkManager.sharedInstance.language(key: "continue"), for: .normal)
    }

    
    @IBAction func continueClick(_ sender: Any) {
        GlobalVariables.proceedToCheckOut = true
        self.dismiss(animated: true, completion: nil)

    }
    
    
   
}
