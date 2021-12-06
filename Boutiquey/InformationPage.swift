//
//  InformationPage.swift
//  Boutiquey
//
//  Created by Alex on 04/08/2019.
//  Copyright © 2019 yogesh. All rights reserved.
//

import UIKit
class InformationPage: UIViewController,UIWebViewDelegate {
var descriptionData:String!
@IBOutlet weak var webView: UIWebView!
    let defaults = UserDefaults.standard;

override func viewDidLoad() {
    super.viewDidLoad()
    descriptionData = ViewController.selfVC.footer_description
    
    self.navigationItem.title = NetworkManager.sharedInstance.language(key: "description")
//    print(descriptionData)
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


