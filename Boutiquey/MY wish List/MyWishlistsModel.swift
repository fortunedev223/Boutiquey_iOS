//
//  MyWishlistsModel.swift
//  OpenCartApplication
//
//  Created by shobhit on 24/08/17.
//  Copyright © 2017 webkul. All rights reserved.
//

import UIKit

class MyWishlistsModel: NSObject {

    var name:String = ""
    var price:String = ""
    var productId:String = ""
    var stockAvailability:String = ""
    var imageUrl:String = ""
    var productModel:String = ""
    var hasOption:Int = 0
    var specialPrice:Int = 0
     var formatted_special:String = ""
    
    init(data: JSON) {
        self.name = data["name"].stringValue
        self.price = data["price"].stringValue
        self.productId = data["product_id"].stringValue
        self.stockAvailability = data["stock"].stringValue
        self.imageUrl = data["thumb"].stringValue
        self.productModel = data["model"].stringValue
        self.hasOption = data["hasOption"].intValue
        self.specialPrice = data["special"].intValue
        self.formatted_special = data["formatted_special"].stringValue
    }

}


class MyWishlistsViewModel{
    var myWishlistsDataModel = [MyWishlistsModel]()
    
    init(data:JSON) {
        for i in 0..<data["wishlistData"].count{
            let dict = data["wishlistData"][i];
            myWishlistsDataModel.append(MyWishlistsModel(data: dict))
        }
        
    }
    
    var getWishlistsData:Array<MyWishlistsModel>{
        return myWishlistsDataModel
    }
    
    
}
