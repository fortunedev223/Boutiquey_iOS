//
//  MyDownloadModel.swift
//  OpenCartApplication
//
//  Created by Kunal Parsad on 04/09/17.
//  Copyright © 2017 webkul. All rights reserved.
//

import UIKit

class MyDownloadModel: NSObject {
    var orderId:String!
    var name:String!
    var size:String!
    var date:String!
    var type:String = ""
    var file:String = ""
    var url:String = ""
    
    
    init(data:JSON) {
        self.orderId = data["order_id"].stringValue
        self.name = data["file"].stringValue
        self.size = data["size"].stringValue
        self.date = data["date_added"].stringValue
        self.file = data["file"].stringValue
        self.type = data["extension"].stringValue
        self.url = data["url"].stringValue
    }

}


class MyDownloadViewModel:NSObject{
    var myDownloadModel = [MyDownloadModel]()
    
    init(data:JSON) {
        if data["downloadData"].arrayObject != nil{
        let arrayData = data["downloadData"].arrayObject! as NSArray
        myDownloadModel =  arrayData.map({(value) -> MyDownloadModel in
            return  MyDownloadModel(data:JSON(value))
        })
        }
    }
    
    var getMyDownloadData:Array<MyDownloadModel>{
        return myDownloadModel;
    }
    
    
    
}

