//
//  BillingAddressModel.swift
//  OpenCartApplication
//
//  Created by Kunal Parsad on 31/08/17.
//  Copyright © 2017 webkul. All rights reserved.
//

import UIKit

class BillingAddressModel: NSObject {
    var addressId:String!
    var addressData:String!
    
    
    init(data:JSON) {
        self.addressId = data["address_id"].stringValue
        self.addressData = data["address"]["firstname"].stringValue+" "+data["address"]["lastname"].stringValue+"\n"+data["address"]["company"].stringValue+"\n"+data["address"]["address_1"].stringValue+","+data["address"]["postcode"].stringValue+","+data["address"]["city"].stringValue+"\n"+data["address"]["zone"].stringValue+","+data["address"]["country"].stringValue
 
    }
    
    

}

class BillingCountryModel: NSObject {
    var countryId:String = ""
    var countryName:String = ""
    var zoneArr:Array<Any>!
    
    
    init(data: JSON) {
        self.countryId = data["country_id"].stringValue
        self.countryName = data["name"].stringValue
        self.zoneArr = data["zone"].arrayObject!
        
        
    }
}





class BillingAddressViewModel:NSObject{
    var biilingAddressModel = [BillingAddressModel]()
    var billingCountryData = [BillingCountryModel]()
    var isShippingRequired:Int = 1
     var countryID:String = ""
    
    init(data:JSON){
        for i in 0..<data["paymentAddress"]["addresses"].count{
            let dict = data["paymentAddress"]["addresses"][i];
            biilingAddressModel.append(BillingAddressModel(data: dict))
        }
        
        for i in 0..<data["guest"]["countryData"].count{
            let dict = data["guest"]["countryData"][i];
            billingCountryData.append(BillingCountryModel(data: dict))
        }
        
        isShippingRequired = data["shipping_required"].intValue
        self.countryID = data["guest"]["country_id"].stringValue
    }
    
    var getBillingAddressData:Array<BillingAddressModel>{
        return biilingAddressModel;
    }
    
    var getCountryData:Array<BillingCountryModel>{
        return billingCountryData
    }
    
}

