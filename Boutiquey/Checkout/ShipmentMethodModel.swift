//
//  ShipmentMethodModel.swift
//  OpenCartApplication
//
//  Created by Kunal Parsad on 01/09/17.
//  Copyright © 2017 webkul. All rights reserved.
//

import UIKit

class ShipmentMethodModel: NSObject {
    var shipmentCode:String!
    var shipmentTitle:String!
    var shipmentCost:String!
    
    init(data:JSON) {
       

        shipmentCode = data["code"].stringValue
        shipmentTitle = data["title"].stringValue
        shipmentCost = data["text"].stringValue
    }


}


class ShipmentMethodViewModel:NSObject{
    
    var shipmentMethodModel = [ShipmentMethodModel]()
    var  commentMessage:String = ""
    
    init(data:JSON) {
        
//        for i in 0..<data["shippingMethods"]["shipping_methods"].count{
//            var dict = data["shippingMethods"]["shipping_methods"][i]
//            for (key,_):(String,JSON) in dict["quote"]{
//                shipmentMethodModel.append(ShipmentMethodModel(data:dict["quote"][key]))
//            }
//        }
        
        for i in 0..<data["shippingMethods"]["shipping_methods"].count{
            var dict = data["shippingMethods"]["shipping_methods"][i]
            for j in 0..<dict["quote"].count{
                shipmentMethodModel.append(ShipmentMethodModel(data:dict["quote"][j]))
            }
        }
        
    }
 
    var getShipmentMethod:Array<ShipmentMethodModel>{
        
        return shipmentMethodModel
    }
    
    
    
}

