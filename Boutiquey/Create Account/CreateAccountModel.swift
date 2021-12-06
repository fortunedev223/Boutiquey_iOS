//
//  CreateAccountModel.swift
//  OpenCartApplication
//
//  Created by shobhit on 19/08/17.
//  Copyright © 2017 webkul. All rights reserved.
//

import UIKit

class CreateAccountModel: NSObject {
    var agreeText : String!
    var countryArray : Array<Any>
    var areeInfoDescription:String = ""
    var defaultCountryCode:String = ""
  
    init(data: JSON) {
        agreeText = data["agreeInfo"]["text"].stringValue
        countryArray = data["countryData"].arrayObject!
        areeInfoDescription = data["agreeInfo"]["data"]["description"].stringValue
        defaultCountryCode = data["store_country_id"].stringValue
    }
    
}

class CountryDataModel: NSObject {
    var countryId:String = ""
    var countryName:String = ""
    var zoneArr:Array<Any>!
    
    
    init(data: JSON) {
        self.countryId = data["country_id"].stringValue
        self.countryName = data["name"].stringValue
        self.zoneArr = data["zone"].arrayObject!       
        
    }

}


class CreateAccountViewModel {
    var createAccountModel:CreateAccountModel!
    var countryDataModel = [CountryDataModel]()

    init(data:JSON) {
        print(data["countryData"].count)
        for i in 0..<data["countryData"].count{
            let dict = data["countryData"][i];
            countryDataModel.append(CountryDataModel(data: dict))
        }
        createAccountModel = CreateAccountModel(data:data);
        
    }
   
    
    var getCountryData:Array<CountryDataModel>{
        return countryDataModel
    }
    
    var getAgreetext:String{
        return createAccountModel.agreeText;
    }
    
    var getAgreeDescription:String{
        return createAccountModel.areeInfoDescription
    }
    

}
