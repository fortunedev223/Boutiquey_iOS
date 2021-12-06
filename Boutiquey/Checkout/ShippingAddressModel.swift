//
//  ShippingAddressModel.swift
//  OpenCartApplication
//
//  Created by Kunal Parsad on 31/08/17.
//  Copyright © 2017 webkul. All rights reserved.
//

import UIKit

class ShippingAddressModel: NSObject {
    var addressId:String!
    var addressData:String!
    
    
    init(data:JSON) {
        self.addressId = data["address_id"].stringValue
        self.addressData = data["address"]["firstname"].stringValue+" "+data["address"]["lastname"].stringValue+"\n"+data["address"]["company"].stringValue+"\n"+data["address"]["address_1"].stringValue+","+data["address"]["postcode"].stringValue+","+data["address"]["city"].stringValue+"\n"+data["address"]["zone"].stringValue+","+data["address"]["country"].stringValue
        
    }

}


class ShippingCountryModel: NSObject {
    var countryId:String = ""
    var countryName:String = ""
    var zoneArr:Array<Any>!
    
    
    init(data: JSON) {
        self.countryId = data["country_id"].stringValue
        self.countryName = data["name"].stringValue
        self.zoneArr = data["zone"].arrayObject!
        
        
    }
}

class ShippingAddressViewModel:NSObject{
    var shippingAddressModel = [ShippingAddressModel]()
    var shippingCountryData = [ShippingCountryModel]()
    
    init(data:JSON){
        for i in 0..<data["shippingAddress"]["addresses"].count{
            let dict = data["shippingAddress"]["addresses"][i];
            shippingAddressModel.append(ShippingAddressModel(data: dict))
        }
        
        for i in 0..<data["shippingAddress"]["countryData"].count{
            let dict = data["shippingAddress"]["countryData"][i];
            shippingCountryData.append(ShippingCountryModel(data: dict))
        }
        
        
    }
    
    var getShippingAddressData:Array<ShippingAddressModel>{
        return shippingAddressModel;
    }
    
    var getCountryData:Array<ShippingCountryModel>{
        return shippingCountryData
    }
    
    
}
