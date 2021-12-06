//
//  AddressBookModel.swift
//  OpenCartApplication
//
//  Created by shobhit on 23/08/17.
//  Copyright © 2017 webkul. All rights reserved.
//

import UIKit

class AddressBookModel: NSObject {
    var addressId:String = ""
    var addressValue:String = ""


    init(data: JSON) {
        self.addressId = data["address_id"].stringValue
        self.addressValue = data["value"].stringValue.html2String

    }


}


class AddressBookViewModel{
    var addressDataModel = [AddressBookModel]()
    var defaultAddress:String = ""
    
    init(data:JSON) {
        for i in 0..<data["addressData"].count{
            let dict = data["addressData"][i];
            addressDataModel.append(AddressBookModel(data: dict))
        }
    
        defaultAddress = data["default"].stringValue
        
    }
    
    
    
    
    
    var getAddressData:Array<AddressBookModel>{
        return addressDataModel
    }

    
}



