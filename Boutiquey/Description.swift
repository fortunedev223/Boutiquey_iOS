//
//  Description.swift
//  OpenCartApplication
//
//  Created by Kunal Parsad on 30/08/17.
//  Copyright © 2017 webkul. All rights reserved.
//

import UIKit
class Description: UIViewController,UIWebViewDelegate {
var descriptionData:String!
@IBOutlet var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = NetworkManager.sharedInstance.language(key: "description")
        webView.loadHTMLString(descriptionData, baseURL: nil)
        webView.delegate = self
    }
    
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        NetworkManager.sharedInstance.showLoader()
        
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        NetworkManager.sharedInstance.dismissLoader()
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        NetworkManager.sharedInstance.dismissLoader()
    }
    
    
    
}
