//
//  AddNewAddressModel.swift
//  OpenCartApplication
//
//  Created by shobhit on 23/08/17.
//  Copyright © 2017 webkul. All rights reserved.
//

import UIKit

class AddNewAddressModel: NSObject {
    var countryId:String = ""
    var countryName:String = ""
    var zoneArr:Array<Any>!


    init(data: JSON) {
        self.countryId = data["country_id"].stringValue
        self.countryName = data["name"].stringValue
        self.zoneArr = data["zone"].arrayObject!
        
        
    }
    
}

class AddressReceiveModel:NSObject{
    var firstName:String!
    var lastName:String!
    var company:String!
    var address1:String!
    var address2:String!
    var city:String!
    var zip:String!
    var addressId:String!
    var country:String!
    var zoneVal:String!
    var country_Id:String!
    var zone_Id:String!
    var defaultAddString:Int!
    var defaultCountryCode:String!
    
    
    init(data:JSON){
        firstName = data["data"]["firstname"].stringValue
        lastName = data["data"]["lastname"].stringValue
        company = data["data"]["company"].stringValue
        address1 = data["data"]["address_1"].stringValue
        address2 = data["data"]["address_2"].stringValue
        city = data["data"]["city"].stringValue
        zip = data["data"]["postcode"].stringValue
        addressId = data["data"]["address_id"].stringValue
        country = data["data"]["country"].stringValue
        zoneVal = data["data"]["zone"].stringValue
        self.country_Id = data["data"]["country_id"].stringValue
        self.zone_Id = data["data"]["zone_id"].stringValue
        self.defaultAddString = data["default"].intValue
        self.defaultCountryCode = data["store_country_id"].stringValue
    }
    
    
    
    
}




class AddNewAddressViewModel{
    var newAddressDataModel = [AddNewAddressModel]()
    var addrerssReceiveModel:AddressReceiveModel!
    
    init(data:JSON) {
        for i in 0..<data["countryData"].count{
            let dict = data["countryData"][i];
            newAddressDataModel.append(AddNewAddressModel(data: dict))
        }
        addrerssReceiveModel = AddressReceiveModel(data:data)
        
    }
    
    var getCountryData:Array<AddNewAddressModel>{
        return newAddressDataModel
    }
    
    var getAddressReceiveModel:AddressReceiveModel{
        return addrerssReceiveModel
    }
    
    
}
