//
//  TouchId.swift
//  Opencart
//
//  Created by kunal on 04/08/18.
//  Copyright © 2018 kunal. All rights reserved.
//

import Foundation
import LocalAuthentication


class TouchID{
    let kMsgShowReason = "🌛 Try to dismiss this screen 🌜"
    var errorMessage:String = ""
    var NotAgainCallTouchId :Bool = false
    var context = LAContext()
    var policy: LAPolicy?
    var view:UIViewController?
    
    
    init(view:UIViewController) {
        self.view = view
        if defaults.object(forKey: "touchIdFlag") == nil{
            defaults.set("0", forKey: "touchIdFlag");
            defaults.synchronize()
        }
    }
    
    
    func isSupportedTouchID()->Bool{
        var err: NSError?
        guard context.canEvaluatePolicy(policy!, error: &err) else {
            return false
        }
        return true
    }
    
    func checkUserAuthentication(taskCallback: @escaping (Bool) -> Void) {
        
        
        if #available(iOS 9.0, *) {
            // iOS 9+ users with Biometric and Passcode verification
            policy = .deviceOwnerAuthentication
        } else {
            // iOS 8+ users with Biometric and Custom (Fallback button) verification
            context.localizedFallbackTitle = ""
            policy = .deviceOwnerAuthenticationWithBiometrics
        }
        
        if self.isSupportedTouchID(){
        // Start evaluation process with a callback that is executed when the user ends the process successfully or not
        context.evaluatePolicy(policy!, localizedReason: kMsgShowReason, reply: { (success, error) in
            DispatchQueue.main.async {
                
                
                guard success else {
                    guard let error = error else {
                        let  AC = UIAlertController(title: NetworkManager.sharedInstance.language(key: "error"), message: NetworkManager.sharedInstance.language(key: "erroroccured"), preferredStyle: .alert)
                        let okBtn = UIAlertAction(title: NetworkManager.sharedInstance.language(key: "ok"), style:.default, handler: {(_ action: UIAlertAction) -> Void in
                            taskCallback(false)
                        })
                        AC.addAction(okBtn)
                        self.view?.present(AC, animated: true, completion: {  })
                        return
                    }
                    switch(error) {
                    case LAError.authenticationFailed:
                        self.errorMessage = NetworkManager.sharedInstance.language(key: "therewasaproblemverifyingyouridentity")
                    case LAError.userCancel:
                        self.errorMessage = NetworkManager.sharedInstance.language(key: "authenticationwascanceledbyuser")
                    default:
                        self.errorMessage = NetworkManager.sharedInstance.language(key: "touchidmaynotbeconfigured")
                        break
                    }
                    
                    let  AC = UIAlertController(title: NetworkManager.sharedInstance.language(key: "error"), message: self.errorMessage, preferredStyle: .alert)
                    let okBtn = UIAlertAction(title: NetworkManager.sharedInstance.language(key: "ok"), style:.default, handler: {(_ action: UIAlertAction) -> Void in
                             taskCallback(false)
                        
                    })
                    AC.addAction(okBtn)
                    self.view?.present(AC, animated: true, completion: {  })
                    return
                }
                taskCallback(true)
            }
        })
        }else{
            let  AC = UIAlertController(title: NetworkManager.sharedInstance.language(key: "error"), message: NetworkManager.sharedInstance.language(key: "touchidmaynotbeconfigured"), preferredStyle: .alert)
            let okBtn = UIAlertAction(title: NetworkManager.sharedInstance.language(key: "ok"), style:.default, handler: {(_ action: UIAlertAction) -> Void in
                taskCallback(false)
            })
            AC.addAction(okBtn)
            self.view?.present(AC, animated: true, completion: {  })
        }
       
        
    }
    
    
    
    
}
