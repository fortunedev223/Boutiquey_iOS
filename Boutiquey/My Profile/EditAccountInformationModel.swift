//
//  EditAccountInformationModel.swift
//  OpenCartApplication
//
//  Created by shobhit on 24/08/17.
//  Copyright © 2017 webkul. All rights reserved.
//

import UIKit

class EditAccountInformationModel: NSObject {

    var firstName:String!
    var lastName:String!
    var emailAddress:String!
    var telephone:String!
    var fax:String!
    
    
    init(data:JSON){
        firstName = data["firstname"].stringValue
        lastName = data["lastname"].stringValue
        emailAddress = data["email"].stringValue
        telephone = data["telephone"].stringValue
        fax = data["fax"].stringValue
        
    }

}


class EditAccountInformationViewModel{
    var addrerssReceivedModel:EditAccountInformationModel!
    
    
    init(data:JSON) {
        addrerssReceivedModel = EditAccountInformationModel(data:data)
        
    }
    
    var getEditAddressReceived:EditAccountInformationModel{
        return addrerssReceivedModel
    }
    

}
    
    

