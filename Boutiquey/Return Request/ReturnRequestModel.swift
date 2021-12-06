//
//  ReturnRequestModel.swift
//  OpenCartApplication
//
//  Created by Kunal Parsad on 05/09/17.
//  Copyright © 2017 webkul. All rights reserved.
//

import UIKit

class ReturnRequestModel: NSObject {
    var date:String!
    var name:String!
    var orderId:String!
    var returnId:String!
    var status:String!
    
    init(data:JSON) {
        self.date = data["date_added"].stringValue
        self.name = data["name"].stringValue
        self.orderId = data["order_id"].stringValue
        self.returnId = data["return_id"].stringValue
        self.status  = data["status"].stringValue
    }
    
    

}


class ReturnRequestViewModel:NSObject{
    var returnRequestModel = [ReturnRequestModel]()
    
    init(data:JSON){
        if let result =  data["returnData"].array{
            returnRequestModel =  result.map({(value) -> ReturnRequestModel in
                return  ReturnRequestModel(data:value)
            })
        }
        
        
    }
    
    
    var getMyReturnRequestData:Array<ReturnRequestModel>{
        return returnRequestModel;
    }
    
    
    
    
    
}
