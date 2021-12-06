//
//  RewardPointModel.swift
//  BroPhone
//
//  Created by kunal on 15/01/18.
//  Copyright © 2018 kunal. All rights reserved.
//

import Foundation

struct RewardPointModel{
    var date_added:String!
    var descriptionValue:String!
    var points:String!
    
    init(data:JSON) {
        self.date_added = data["date_added"].stringValue
        self.descriptionValue = data["description"].stringValue
        self.points = data["points"].stringValue
    }

}



class RewardPointViewModel{
     var headerMessage:String!
     var totalCount:Int!
     var rewardCollectionModel = [RewardPointModel]()
    
    init(data:JSON) {
        if var arrayData = data["rewardData"].arrayObject {
            arrayData = (data["rewardData"].arrayObject! as NSArray) as! [Any]
        rewardCollectionModel =  arrayData.map({(value) -> RewardPointModel in
            return  RewardPointModel(data:JSON(value))
        })
        }
        headerMessage = data["rewardText"].stringValue
        totalCount = data["rewardsTotal"].intValue
        
    }
    
    func setRewardCollectionData(data:JSON){
            let arrayData = data["rewardData"].arrayObject! as NSArray
            rewardCollectionModel = rewardCollectionModel + arrayData.map({(value) -> RewardPointModel in
                return  RewardPointModel(data:JSON(value))
            })
    }
}



