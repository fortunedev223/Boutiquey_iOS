//
//  CartModel.swift
//  OpenCartApplication
//
//  Created by shobhit on 25/08/17.
//  Copyright © 2017 webkul. All rights reserved.
//

import UIKit

class CartModel: NSObject {

    var productName:String = ""
    var option:String = ""
    var price:String = ""
    var subTotal:String = ""
    var productImgUrl:String = ""
    var priductId:String = ""
    var optionData:Array<JSON>
    var quantity:String!
    var key:String!
    var isAnimate:Bool = false
    var stock:Int = 0
    
    init(data: JSON) {
        self.productName = data["name"].stringValue
        self.option = data["model"].stringValue
        self.price = data["price"].stringValue
        self.subTotal = data["total"].stringValue
        self.productImgUrl = data["thumb"].stringValue
        self.priductId = data["product_id"].stringValue
        self.optionData = data["option"].arrayValue
        self.quantity = data["quantity"].stringValue
        self.key = data["key"].stringValue
        self.isAnimate = false
        self.stock = data["stock"].intValue
        
    }
    
}


class TotalAmount:NSObject{
    var text:String!
    var title:String!
    
    init(data:JSON) {
        self.text = data["text"].stringValue
        self.title = data["title"].stringValue
        
    }
    
}


class CartViewModel{
    var cartproductDataModel = [CartModel]()
    var totalProducts:String!
    var amountTotal = [TotalAmount]()
    var checkout:Int = 0
    var errorMessage:String = ""
    var coupon_status:Bool = false
    var voucher_status:Bool = false
    
    
    init(data:JSON) {
        for i in 0..<data["cart"]["products"].count{
            let dict = data["cart"]["products"][i];
            cartproductDataModel.append(CartModel(data: dict))
        }
        
        for i in 0..<data["cart"]["totals"].count{
            let dict = data["cart"]["totals"][i];
            amountTotal.append(TotalAmount(data: dict))
        }
        
        if data["cart"]["guest_status"].boolValue{
            sharedPrefrence.set("true", forKey: "guest");
        }else{
            sharedPrefrence.set("false", forKey: "guest");
        }
        sharedPrefrence.synchronize()
        totalProducts = data["cart"]["total_products"].stringValue;
        
        self.checkout = data["cart"]["checkout_eligible"].intValue
        self.errorMessage = data["cart"]["error_warning"].stringValue
        self.coupon_status = data["cart"]["coupon_status"].boolValue
        self.voucher_status = data["cart"]["voucher_status"].boolValue
        
        
    }
    
    var getProductData:Array<CartModel>{
        return cartproductDataModel
    }
    
    var getTotalProducts:String{
        return totalProducts;
    }
    
    var getTotalAmount:Array<TotalAmount>{
        return amountTotal;
    }
    
    func setDataToCartModel(data:String,pos:Int){
        cartproductDataModel[pos].quantity = data;
    }
    
    
}
