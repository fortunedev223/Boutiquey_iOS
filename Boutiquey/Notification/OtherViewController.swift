//
//  OtherViewController.swift
//  jsluxuryfashion
//
//  Created by kunal on 30/08/18.
//

import UIKit

class OtherViewController: UIViewController {

    
@IBOutlet var webView: UIWebView!
    
    
var titleValue:String = ""
var message:String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = titleValue
        let htmlContent = "<html><body>"+message+"</body></html>";
        self.webView.loadHTMLString(htmlContent, baseURL: nil)
    
    }

  

}
