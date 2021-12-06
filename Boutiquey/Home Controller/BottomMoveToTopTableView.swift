//
/**
Mobikul_Magento2V3_App
@Category Webkul
@author Webkul <support@webkul.com>
FileName: BottomMoveToTopTableView.swift
Copyright (c) 2010-2018 Webkul Software Private Limited (https://webkul.com)
@license https://store.webkul.com/license.html ASL Licence
@link https://store.webkul.com/license.html

*/

import UIKit
import WebKit
import SafariServices
import MessageUI

class BottomMoveToTopTableView: UIView, MFMailComposeViewControllerDelegate {
    @IBOutlet weak var bottomLabelMessage: UILabel!
    @IBOutlet weak var bottomtext1: UILabel!
    @IBOutlet weak var bottomtext2: UILabel!
    
    @IBOutlet weak var phonenumber: UIButton!
    @IBOutlet weak var maillabel: UIButton!
    
    @IBOutlet weak var instagramimg: UIImageView!
    @IBOutlet weak var twitterimg: UIImageView!
    @IBOutlet weak var facebookimg: UIImageView!
    @IBOutlet weak var youtubeimg: UIImageView!
    @IBOutlet weak var snapchatimg: UIImageView!
    @IBOutlet weak var creditimg: UIImageView!
    var tableView: UITableView!
    @IBOutlet weak var backToTopButton: UIButton!

    override func layoutSubviews() {
        bottomLabelMessage.text = "bottommessgae".localized
        bottomLabelMessage.textColor = UIColor().HexToColor(hexString: LIGHTGREY)
        bottomtext1.text = "bottomtext1".localized
        bottomtext1.textColor = UIColor().HexToColor(hexString: LIGHTGREY)
        bottomtext2.text = "bottomtext2".localized
        bottomtext2.textColor = UIColor().HexToColor(hexString: LIGHTGREY)
        backToTopButton.setTitleColor(UIColor().HexToColor(hexString: BUTTON_COLOR), for: .normal)
        backToTopButton.setTitle("backtotop".localized, for: .normal)
        
        let tapGestureRecognizer1 = UITapGestureRecognizer(target: self, action: #selector(instagramTapped(tapGestureRecognizer:)))
        instagramimg.isUserInteractionEnabled = true
        instagramimg.addGestureRecognizer(tapGestureRecognizer1)
        
        let tapGestureRecognizer2 = UITapGestureRecognizer(target: self, action: #selector(twitterTapped(tapGestureRecognizer:)))
        twitterimg.isUserInteractionEnabled = true
        twitterimg.addGestureRecognizer(tapGestureRecognizer2)
        
        let tapGestureRecognizer3 = UITapGestureRecognizer(target: self, action: #selector(facebookTapped(tapGestureRecognizer:)))
        facebookimg.isUserInteractionEnabled = true
        facebookimg.addGestureRecognizer(tapGestureRecognizer3)
        
        let tapGestureRecognizer4 = UITapGestureRecognizer(target: self, action: #selector(youtubeTapped(tapGestureRecognizer:)))
        youtubeimg.isUserInteractionEnabled = true
        youtubeimg.addGestureRecognizer(tapGestureRecognizer4)
        
        let tapGestureRecognizer5 = UITapGestureRecognizer(target: self, action: #selector(snapchatTapped(tapGestureRecognizer:)))
        snapchatimg.isUserInteractionEnabled = true
        snapchatimg.addGestureRecognizer(tapGestureRecognizer5)
    }

    @IBAction func backToTopButtonAction(_ sender: Any) {
        scrollToFirstRow()
    }

    func scrollToFirstRow() {
        let indexPath = NSIndexPath(row: 0, section: 0)
        self.tableView.scrollToRow(at: indexPath as IndexPath, at: .top, animated: true)
    }
    
    @IBAction func onClickPhone(_ sender: Any) {
                
        guard let number = URL(string: "tel://" + "phonenumber".localized) else { return }
        UIApplication.shared.open(number)
        
    }

    
    @IBAction func onClickMail(sender: AnyObject) {
        print("onClickMail")
                let mailComposeViewController = configuredMailComposeViewController()
               if MFMailComposeViewController.canSendMail() {
                       ViewController.selfVC.present(mailComposeViewController, animated: true, completion: nil)
                  } else {
                       self.showSendMailErrorAlert()
                 }
          }
    
        func configuredMailComposeViewController() -> MFMailComposeViewController {
                let mailComposerVC = MFMailComposeViewController()
                mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
        
                mailComposerVC.setToRecipients(["sales@boutiquey.net"])
                mailComposerVC.setSubject("Feedback") 
                return mailComposerVC
            }
    
        func showSendMailErrorAlert() {
                let sendMailErrorAlert = UIAlertView(title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", delegate: self, cancelButtonTitle: "OK")
                sendMailErrorAlert.show()
            }
    
        // MARK: MFMailComposeViewControllerDelegate Method
        func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
                controller.dismiss(animated: true, completion: nil)
            }
    
    @objc func instagramTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        startWithSafari( sUrl: "instagramurl".localized)
    }
    @objc func twitterTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        startWithSafari( sUrl: "twitterurl".localized)
    }
    @objc func facebookTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        startWithSafari( sUrl: "whatsappurl".localized)
    }
    @objc func youtubeTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        startWithSafari( sUrl: "youtubeurl".localized)
    }
    @objc func snapchatTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        startWithSafari( sUrl: "snapchaturl".localized)
    }
    
    func startWithSafari(sUrl: String) {
        let url = NSURL(string:sUrl)
        UIApplication.shared.open(url! as URL, options: [:], completionHandler: nil)
    }
}
