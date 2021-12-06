//
//  OrderReviewModel.swift
//  OpenCartApplication
//
//  Created by Kunal Parsad on 01/09/17.
//  Copyright © 2017 webkul. All rights reserved.
//

import UIKit

class OrderReviewModel: NSObject {
    var productName:String!
    var model:String!
    var price:String!
    var quantity:String!
    var option:Array<JSON>!
    var tax:String!
    var subTotal:String = ""
    var image:String = ""
    
    
    init(data:JSON){
        self.productName = data["name"].stringValue
        self.model = data["model"].stringValue
        self.price = data["price_text"].stringValue
        self.quantity = data["quantity"].stringValue
        self.option = data["option"].arrayValue
        self.tax = data["tax"].stringValue
        self.subTotal = data["total_text"].stringValue
        self.image = data["image"].stringValue
    }

}

class OrderTotalAmount:NSObject{
    var title:String!
    var value:String!
    var text:String!
    
    init(data:JSON) {
        self.title = data["title"].stringValue
        self.value = data["value"].stringValue
        self.text = data["text"].stringValue
        
    }
 
}



class OrderReviewViewModel:NSObject{
   var orderReviewModel = [OrderReviewModel]()
   var orderTotalAmount = [OrderTotalAmount]()
   var billingAddress:String!
   var shippingAddress:String!
   var paymentMethod:String!
   var shipmentMethod:String!
   var paymentURL:String = ""
    
    var pt_address_billing:String = ""
    var pt_address_shipping:String = ""
    var pt_amount:Float = 0
    var pt_billing_country_id:String = ""
    var pt_city_billing:String = ""
    var pt_city_shipping:String = ""
    var pt_country_billing:String = ""
    var pt_country_shipping:String = ""
    var pt_currency_code:String = ""
    var pt_customer_email:String = ""
    var pt_customer_phone_number:String = ""
    var pt_merchant_email:String = ""
    var pt_order_id:String = ""
    var pt_payment_iso_code_3:String = ""
    var pt_postal_code_billing:String = ""
    var pt_postal_code_shipping:String = ""
    var pt_product_name:String = ""
    var pt_secret_key:String = ""
    var pt_shipping_country_id:String = ""
    var pt_shipping_iso_code_3:String = ""
    var pt_state_billing:String = ""
    var pt_state_shipping:String = ""
    var pt_timeout_in_seconds:String = ""
    var pt_transaction_title:String = ""
    var order_id:String = ""
    
    
    
    
    init(data:JSON){
        for i in 0..<data["continue"]["order_details"]["products"].count{
            let dict = data["continue"]["order_details"]["products"][i];
            orderReviewModel.append(OrderReviewModel(data: dict))
        }
        
        for i in 0..<data["continue"]["totals"].count{
            let dict = data["continue"]["totals"][i];
            orderTotalAmount.append(OrderTotalAmount(data: dict))
        }
        
        billingAddress = data["continue"]["order_details"]["firstname"].stringValue+" "+data["continue"]["order_details"]["lastname"].stringValue+"\n"+data["continue"]["order_details"]["payment_company"].stringValue+"\n"+data["continue"]["order_details"]["payment_address_1"].stringValue+","+data["continue"]["order_details"]["payment_postcode"].stringValue+","+data["continue"]["order_details"]["payment_city"].stringValue+"\n"+data["continue"]["order_details"]["payment_zone"].stringValue+","+data["continue"]["order_details"]["payment_country"].stringValue
        
        paymentMethod = data["continue"]["order_details"]["payment_method"].stringValue
        
        shippingAddress = data["continue"]["order_details"]["shipping_firstname"].stringValue+" "+data["continue"]["order_details"]["shipping_lastname"].stringValue+"\n"+data["continue"]["order_details"]["shipping_company"].stringValue+"\n"+data["continue"]["order_details"]["shipping_address_1"].stringValue+","+data["continue"]["order_details"]["shipping_postcode"].stringValue+","+data["continue"]["order_details"]["shipping_city"].stringValue+"\n"+data["continue"]["order_details"]["shipping_zone"].stringValue+","+data["continue"]["order_details"]["shipping_country"].stringValue
        
        shipmentMethod = data["continue"]["order_details"]["shipping_method"].stringValue
        
        self.paymentURL = data["continue"]["apgsenangpay"]["apgsenangpay_url"].stringValue
        
        
        pt_address_billing = data["continue"]["paytabs"]["pt_address_billing"].stringValue
        pt_address_shipping = data["continue"]["paytabs"]["pt_address_shipping"].stringValue
        pt_amount = data["continue"]["paytabs"]["pt_amount"].floatValue
        pt_billing_country_id = data["continue"]["paytabs"]["pt_billing_country_id"].stringValue
        pt_city_billing = data["continue"]["paytabs"]["pt_city_billing"].stringValue
        pt_city_shipping = data["continue"]["paytabs"]["pt_city_shipping"].stringValue
        pt_country_billing = data["continue"]["paytabs"]["pt_country_billing"].stringValue
        pt_country_shipping = data["continue"]["paytabs"]["pt_country_shipping"].stringValue
        pt_currency_code = data["continue"]["paytabs"]["pt_currency_code"].stringValue
        pt_customer_email = data["continue"]["paytabs"]["pt_customer_email"].stringValue
        pt_customer_phone_number = data["continue"]["paytabs"]["pt_customer_phone_number"].stringValue
        pt_merchant_email = data["continue"]["paytabs"]["pt_merchant_email"].stringValue
        pt_order_id = data["continue"]["paytabs"]["pt_order_id"].stringValue
        pt_payment_iso_code_3 = data["continue"]["paytabs"]["pt_payment_iso_code_3"].stringValue
        pt_postal_code_billing = data["continue"]["paytabs"]["pt_postal_code_billing"].stringValue
        pt_postal_code_shipping = data["continue"]["paytabs"]["pt_postal_code_shipping"].stringValue
        pt_product_name = data["continue"]["paytabs"]["pt_product_name"].stringValue
        pt_secret_key = data["continue"]["paytabs"]["pt_secret_key"].stringValue
        pt_shipping_country_id = data["continue"]["paytabs"]["pt_shipping_country_id"].stringValue
        pt_shipping_iso_code_3 = data["continue"]["paytabs"]["pt_shipping_iso_code_3"].stringValue
        pt_state_billing = data["continue"]["paytabs"]["pt_state_billing"].stringValue
        pt_state_shipping = data["continue"]["paytabs"]["pt_state_shipping"].stringValue
        pt_timeout_in_seconds = data["continue"]["paytabs"]["pt_timeout_in_seconds"].stringValue
        pt_transaction_title = data["continue"]["paytabs"]["pt_transaction_title"].stringValue
        self.order_id = data["continue"]["order_id"].stringValue
        
    }
    
    
    var getTotalProducts:Array<OrderReviewModel>{
        return orderReviewModel
    }
    
    var getTotalAmount:Array <OrderTotalAmount>{
        return orderTotalAmount
    }
    
    var getBillingAddress:String{
        return billingAddress
    }
    var getShippingAdress:String{
        return shippingAddress
    }
    
    var getPaymentMethodData:String{
        return paymentMethod
    }
    var getShipmentMethodData:String{
        return shipmentMethod
    }
    
    
}

