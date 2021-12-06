//
//  PrivacyPolicy.swift
//  BroPhone
//
//  Created by kunal on 15/01/18.
//  Copyright © 2018 kunal. All rights reserved.
//

import UIKit

class PrivacyPolicy: UIViewController {
    
@IBOutlet weak var webview: UIWebView!
var privacyMessage:String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = NetworkManager.sharedInstance.language(key: "privacypolicytitle")
        
        self.webview.loadHTMLString(privacyMessage, baseURL: nil)
       
    }

   

}
