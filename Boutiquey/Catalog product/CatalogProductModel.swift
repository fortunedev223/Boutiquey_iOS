//
//  CatalogProductModel.swift
//  Magento2MobikulNew
//
//  Created by Kunal Parsad on 12/08/17.
//  Copyright © 2017 Kunal Parsad. All rights reserved.
//

import UIKit

class CatalogProductModel: NSObject {
    var productName:String!
    var descriptionData:String!
    var stock:String!
    var textInStockTxt:String!
    var stockAvailabilityTxt:String!
    var price:String!
    var exTaxTxt:String!
    var taxAmount:String!
    var rewardsPointsTxt:String!
    var rewardsPoints:String!
    var manufacturerTxt:String!
    var reviews:String!
    var productCodeTxt:String!
    var model:String!
    var shareUrl:String!
    var writeReviewTxt:String!
    var previousProductDict:[String:AnyObject]!
    var nextProductDict:[String:AnyObject]!
    var option:Array<Any>!
    var href:String!
    var quantity:Int = 0
    var specialPrice:Float = 0
    var formatted_special:String = ""
    var rating:String = ""
    var ratingValue:Float = 0
    var review_status:Int = 0
    var review_guest:Int = 0
    var wishlist_status:Int = 0
    var minimum:Int = 0
    
    init(data: JSON) {
        self.productName = data["name"].stringValue
        self.descriptionData = data["description"].stringValue
        self.stock = data["name"].stringValue
        self.textInStockTxt = data["stock"].stringValue
        self.stockAvailabilityTxt = "Availability "
        self.price = data["price"].stringValue
        self.exTaxTxt = data["langArray"]["text_tax"].stringValue
        self.taxAmount = data["tax"].stringValue
        self.rewardsPointsTxt = data["langArray"]["text_points"].stringValue
        self.rewardsPoints = data["points"].stringValue
        self.manufacturerTxt = data["langArray"]["text_manufacturer"].stringValue
        self.reviews = data["reviews"].stringValue
        self.productCodeTxt = data["langArray"]["text_model"].stringValue
        self.model = data["model"].stringValue
        self.shareUrl = data["popup"].stringValue
        self.writeReviewTxt = data["langArray"]["button_write"].stringValue
        self.option = data["options"].arrayObject
        self.href = data["href"].stringValue
        self.quantity = data["quantity"].intValue
        self.specialPrice = data["special"].floatValue
        self.rating = data["rating"].stringValue
        self.ratingValue = data["rating"].floatValue
        self.review_guest = data["review_guest"].intValue
        self.review_status = data["review_status"].intValue
        self.formatted_special = data["formatted_special"].stringValue
        self.wishlist_status = data["wishlist_status"].intValue
        self.minimum =  data["minimum"].intValue
    }

}

class Productimages:NSObject{
    var imageURL:String = ""
    var dominant:String = ""
    
    init(data:JSON) {
            self.imageURL = data["popup"].stringValue
            self.dominant = data["dominant_color"].stringValue
    }
    
}


class RelatedProducts:NSObject{
    var name:String!
    var imageURL:String!
    var price:String!
    var productId:String!
    var hasOption:Int = 0
    var wishlist_status:Int = 0
    var specialPrice:Int = 0
    var formatted_special:String = ""
    
    
    init(data:JSON) {
        self.name = data["name"].stringValue
        self.imageURL = data["thumb"].stringValue
        self.price = data["price"].stringValue
        self.productId = data["product_id"].stringValue
        self.hasOption  = data["hasOption"].intValue
        self.wishlist_status = data["wishlist_status"].intValue
        self.specialPrice = data["special"].intValue
        self.formatted_special = data["formatted_special"].stringValue
        
    }
    
    
    
}



class ReviewsData:NSObject{
    var name:String!
    var text:String!
    var rating:CGFloat!
    var date_added:String!
    
    init(data:JSON){
        name = data["author"].stringValue
        text = data["text"].stringValue
        rating  = CGFloat(data["rating"].floatValue)
        date_added = data["date_added"].stringValue
        
    }

}

struct DiscountData {
    var price:String = ""
    var quantity:String = ""
    
    init(data:JSON) {
        self.price = data["price"].stringValue
        self.quantity = data["quantity"].stringValue
    }
    
}



struct Attributes_Data{
    var name:String = ""
    var attributesDataArray = [AttributeValue]()
    
    
    init(data:JSON) {
        self.name = data["name"].stringValue
        if let arrayData = data["attribute"].arrayObject {
            attributesDataArray =  arrayData.map({(value) -> AttributeValue in
                return  AttributeValue(data:JSON(value))
            })
        }
    }
    
}

struct AttributeValue{
    var title:String = ""
    var value:String = ""
    
    init(data:JSON) {
        self.title = data["name"].stringValue
        self.value = data["text"].stringValue
    }
    
}




class CatalogProductViewModel:NSObject{
    var catalogProductModel:CatalogProductModel!
    var productImages = [Productimages]()
    var relatedProduct = [RelatedProducts]()
    var reviewsData = [ReviewsData]()
    var discountData = [DiscountData]()
    var attributes_Data = [Attributes_Data]()
    
    
    init(productData:JSON) {
        for i in 0..<productData["images"].count{
            let dict = productData["images"][i];
            productImages.append(Productimages(data: dict))
        }
        let arrayData = productData["relatedProducts"].arrayObject! as NSArray
        relatedProduct =  arrayData.map({(value) -> RelatedProducts in
            return  RelatedProducts(data:JSON(value))
        })

        if productData["reviewData"]["reviews"].arrayObject != nil{
            let arrayData = productData["reviewData"]["reviews"].arrayObject! as NSArray
            reviewsData =  arrayData.map({(value) -> ReviewsData in
                return  ReviewsData(data:JSON(value))
            })
        }
        
        if productData["discounts"].arrayObject != nil{
            let arrayData = productData["discounts"].arrayObject! as NSArray
            discountData =  arrayData.map({(value) -> DiscountData in
                return  DiscountData(data:JSON(value))
            })
            
        }
        if productData["attribute_groups"].arrayObject != nil{
            let arrayData = productData["attribute_groups"].arrayObject! as NSArray
            attributes_Data =  arrayData.map({(value) -> Attributes_Data in
                return  Attributes_Data(data:JSON(value))
            })
        }
        
        catalogProductModel = CatalogProductModel(data:productData)
        
        
    }
    

    init(catalogPageData: CatalogProductModel) {
        self.catalogProductModel = catalogPageData
    }
    
    var getProductImages:Array<Productimages>{
        return productImages
    }

    var getOption:Array<Any>{
        return catalogProductModel.option;
    }
    
    var getProductName: String {
        return catalogProductModel.productName;
    }

    var getStockAvailabilityTxt: String {
        return catalogProductModel.stockAvailabilityTxt;
    }

    var getStock: String {
        return catalogProductModel.textInStockTxt;
    }

    var getProductCodeTxt: String {
        return catalogProductModel.productCodeTxt;
    }

    var getPrice: String {
        return catalogProductModel.price;
    }

    var getExTaxTxt: String {
        return catalogProductModel.exTaxTxt;
    }

    var getTaxAmount: String {
        return catalogProductModel.taxAmount;
    }

    var getRewardsPointsTxt: String {
        return catalogProductModel.rewardsPointsTxt;
    }

    var getRewardsPoints: String {
        return catalogProductModel.rewardsPoints;
    }

    var getReviews: String {
        return catalogProductModel.reviews;
    }

    var getWriteReviewTxt: String {
        return catalogProductModel.writeReviewTxt;
    }

    var getProductCode: String {
        return catalogProductModel.model;
    }

    var getRelatedProduct:Array<RelatedProducts>{
        return relatedProduct;
    }
    
    
    var getdescriptionData:String{
        return catalogProductModel.descriptionData
    }
    
    var getHref:String{
        return catalogProductModel.href;
        
    }
    
    var getReviewsData:Array<ReviewsData>{
        return reviewsData;
    }
    
    var getQuantity:Int{
        return catalogProductModel.quantity
    }
    var getSpecialprice:Float{
        return catalogProductModel.specialPrice;
    }
    
    var getRating:String{
        return catalogProductModel.rating
    }
    
    
    
}





