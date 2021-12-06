//
//  OrderHistoryModel.swift
//  OpenCartApplication
//
//  Created by shobhit on 24/08/17.
//  Copyright © 2017 webkul. All rights reserved.
//

import UIKit

class OrderHistoryModel: NSObject {

    var status:String = ""
    var date:String = ""
    var noOfProducts:Int = 0
    var customer:String = ""
    var total:String = ""
    var orderId:String = ""
    
    
    init(data: JSON) {
        self.status = data["status"].stringValue
        self.date = data["dateAdded"].stringValue
        self.noOfProducts = data["products"].intValue
        self.customer = data["name"].stringValue
        self.total = data["total"].stringValue
        self.orderId = data["orderId"].stringValue

    }

}


class OrderHistoryViewModel{
    var orderHistorydataModel = [OrderHistoryModel]()
    var totalCount:Int = 0
    
    init(data:JSON) {
        for i in 0..<data["orderData"].count{
            let dict = data["orderData"][i];
            orderHistorydataModel.append(OrderHistoryModel(data: dict))
        }
        
        self.totalCount = data["orderTotals"].intValue
    }
    
    var getOrdersData:Array<OrderHistoryModel>{
        return orderHistorydataModel
    }
    
    
    func setOrderCollectionData(data:JSON){
        
        if let arrayData = data["orderData"].arrayObject{
            orderHistorydataModel = orderHistorydataModel + arrayData.map({(value) -> OrderHistoryModel in
                return  OrderHistoryModel(data:JSON(value))
            })
        }
    }
    
    
}
