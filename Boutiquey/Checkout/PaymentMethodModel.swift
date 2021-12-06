//
//  PaymentMethodModel.swift
//  OpenCartApplication
//
//  Created by Kunal Parsad on 01/09/17.
//  Copyright © 2017 webkul. All rights reserved.
//

import UIKit

class PaymentMethodModel: NSObject {
    var paymentCode:String!
    var paymentTitle:String!
    
    
    init(data:JSON){
        self.paymentCode = data["code"].stringValue
        self.paymentTitle = data["title"].stringValue
        
    }
    

}

class PaymentMethodViewModel:NSObject{
   var paymentMethodModel = [PaymentMethodModel]()
    var termsAndConditionMessage:String = ""
    var commentMessage:String = ""
    
    init(data:JSON){
//        for (key,_):(String,JSON) in data["paymentMethods"]["payment_methods"]{
//            let dict = data["paymentMethods"]["payment_methods"][key]
//                paymentMethodModel.append(PaymentMethodModel(data:dict))
//
//        }
        
        for i in 0..<data["paymentMethods"]["payment_methods"].count{
            let dict = data["paymentMethods"]["payment_methods"][i]
            paymentMethodModel.append(PaymentMethodModel(data:dict))
        }
        
        termsAndConditionMessage = data["paymentMethods"]["text_agree_info"].stringValue
        
    }
    
    var getPaymentMethod:Array<PaymentMethodModel>{
        return paymentMethodModel
    }
    
    var getTermandCondition:String{
        return termsAndConditionMessage;
    }
    
    
}



