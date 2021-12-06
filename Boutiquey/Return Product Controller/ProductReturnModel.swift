//
//  ProductReturnModel.swift
//  Boutiquey
//
//  Created by kunal on 08/06/18.
//  Copyright © 2018 yogesh. All rights reserved.
//

import Foundation



struct ProductReturnModel{
    var date_ordered:String = ""
    var email:String = ""
    var firstname:String = ""
    var lastname:String = ""
    var model:String = ""
    var order_id:String = ""
    var product:String = ""
    var telephone:String = ""
    var isOpened:Bool = false
    var faultMessage:String = ""
    var qty:String = "1"
    
    init(data:JSON) {
        self.date_ordered = data["date_ordered"].stringValue
        self.email = data["email"].stringValue
        self.firstname = data["firstname"].stringValue
        self.lastname = data["lastname"].stringValue
        self.model = data["model"].stringValue
        self.order_id = data["order_id"].stringValue
        self.product = data["product"].stringValue
        self.telephone = data["telephone"].stringValue
        self.isOpened = false
        self.faultMessage = ""
        
    }

    
}


struct  Return_reasons{
    var name:String = ""
    var return_reason_id:String = ""
    var isCheck:Bool!
    
    
    init(data:JSON) {
        self.name = data["name"].stringValue
        self.return_reason_id = data["return_reason_id"].stringValue
        self.isCheck = false
    }

}


class ProductReturnViewModel{
    var return_reasons = [Return_reasons]()
    var productReturnModel:ProductReturnModel!
    
    
    init(data:JSON) {
        if let arrayData = data["return_reasons"].arrayObject{
        return_reasons =  arrayData.map({(value) -> Return_reasons in
            return  Return_reasons(data:JSON(value))
        })
        }
        
        productReturnModel = ProductReturnModel(data:data)
    }
    
    
    
    
    
    
}









