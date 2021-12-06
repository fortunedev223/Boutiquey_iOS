//
//  ProductCollectionModel.swift
//  Magento2MobikulNew
//
//  Created by Kunal Parsad on 09/08/17.
//  Copyright © 2017 Kunal Parsad. All rights reserved.
//

import UIKit

class ProductCollectionModel: NSObject {
    var productName:String = ""
    var productImage:String = ""
    var descriptionData:String = ""
    var id:String = ""
    var price:String = ""
    var ratingData:CGFloat = 0;
    var hasOption:Int = 0;
    var specialPrice:Float = 0
    var formatted_special:String = ""
    var isInWishList:Int = 0
    var dominant_color:String = ""
    
    init(data: JSON) {
        self.productImage = data["thumb"].stringValue
        self.descriptionData = data["description"].stringValue
        self.id = data["product_id"].stringValue
        self.price = data["price"].stringValue
        self.productName = data["name"].stringValue
        self.ratingData = CGFloat(data["rating"].floatValue)
        self.hasOption = data["hasOption"].intValue
        self.specialPrice = data["special"].floatValue
        self.formatted_special = data["formatted_special"].stringValue
        self.isInWishList = data["wishlist_status"].intValue
        self.dominant_color = data["dominant_color"].stringValue
    }

}

class SortCollectionData: NSObject{
    
    var order:String = ""
    var label:String = ""
    var value:String = ""
    
    init(data: JSON) {
        self.order = data["order"].stringValue
        self.label = data["text"].stringValue.html2String
        self.value = data["value"].stringValue
        
    }

}

class ExtraData:NSObject{
    var totalCount:Int = 0
    
     init(data: JSON) {
        totalCount = data["product_total"].intValue
    }
    
}


class LayeredData:NSObject{
    var code:String!
    var label:String!
    var option:Array<Any>!
    
    init(data:JSON){
        self.code = data["code"].stringValue
        self.label = data["label"].stringValue
        self.option = data["options"].arrayObject
    }
 
}



struct FilterAttriData{
    var filter_ID:String = ""
    var name:String = ""
    var isSelected:Bool!
    
    init(data:JSON) {
        self.filter_ID = data["filter_id"].stringValue
        self.name = data["name"].stringValue
        self.isSelected = false
        
    }
    
}



struct FilterData{
    var name:String = ""
    var filterAttriData = [FilterAttriData]()
    
    init(data:JSON) {
        self.name = data["name"].stringValue
        
        if let arrayData = data["filter"].arrayObject{
        filterAttriData =  arrayData.map({(value) -> FilterAttriData in
            return  FilterAttriData(data:JSON(value))
        })
        }
    }
    
    
}





class ProductCollectionViewModel {
    
    var productCollectionModel = [ProductCollectionModel]()
    var sortCollectionModel = [SortCollectionData]();
    var extraData:ExtraData!
    var filterData = [FilterData]()
    
    init(data:JSON , type:String){
        if type == "manufacture"{
            let arrayData = data["manufacturers"]["products"].arrayObject! as NSArray
            productCollectionModel =  arrayData.map({(value) -> ProductCollectionModel in
                return  ProductCollectionModel(data:JSON(value))
            })
            
            for i in 0..<data["manufacturers"]["sorts"].count{
                let dict = data["manufacturers"]["sorts"][i];
                sortCollectionModel.append(SortCollectionData(data: dict))
            }
            extraData = ExtraData(data: data["manufacturers"])
        }else if type == "search"{
            let arrayData = data["products"].arrayObject! as NSArray
            productCollectionModel =  arrayData.map({(value) -> ProductCollectionModel in
                return  ProductCollectionModel(data:JSON(value))
            })
            
            
            for i in 0..<data["sorts"].count{
                let dict = data["sorts"][i];
                sortCollectionModel.append(SortCollectionData(data: dict))
            }
        extraData = ExtraData(data: data)
        
        }else if type == "crousal"{
            if let arrayData = data["products"].arrayObject{
                productCollectionModel =  arrayData.map({(value) -> ProductCollectionModel in
                    return  ProductCollectionModel(data:JSON(value))
                })
            }
            
            for i in 0..<data["sorts"].count{
                let dict = data["sorts"][i];
                sortCollectionModel.append(SortCollectionData(data: dict))
            }
            extraData = ExtraData(data: data)
            
        }
        else{
        let arrayData = data["categoryData"]["products"].arrayObject! as NSArray
        productCollectionModel =  arrayData.map({(value) -> ProductCollectionModel in
            return  ProductCollectionModel(data:JSON(value))
        })
        
        
        if let arrayData = data["moduleData"]["filter_groups"].arrayObject{
           filterData =  arrayData.map({(value) -> FilterData in
            return  FilterData(data:JSON(value))
        })
        }
            
            
        for i in 0..<data["categoryData"]["sorts"].count{
            let dict = data["categoryData"]["sorts"][i];
            sortCollectionModel.append(SortCollectionData(data: dict))
        }
        extraData = ExtraData(data: data["categoryData"])
        }
    }
    
    var getProductCollectionData:Array<ProductCollectionModel>{
        return productCollectionModel
    }
    
    var getProductCollectionSortData:Array<SortCollectionData>{
        return sortCollectionModel
    }
    
    func setProductCollectionData(data:JSON,type:String){
        
        if type == "manufacture"{
        let arrayData = data["manufacturers"]["products"].arrayObject! as NSArray
        productCollectionModel = productCollectionModel + arrayData.map({(value) -> ProductCollectionModel in
            return  ProductCollectionModel(data:JSON(value))
        })
            
        }else if type == "search"{
            let arrayData = data["products"].arrayObject! as NSArray
            productCollectionModel = productCollectionModel + arrayData.map({(value) -> ProductCollectionModel in
                return  ProductCollectionModel(data:JSON(value))
            })
        
        }
        else if type == "crousal"{
            if let arrayData = data["products"].arrayObject{
                productCollectionModel =  productCollectionModel + arrayData.map({(value) -> ProductCollectionModel in
                    return  ProductCollectionModel(data:JSON(value))
                })
            }
        }
        else{
        let arrayData = data["categoryData"]["products"].arrayObject! as NSArray
        productCollectionModel = productCollectionModel + arrayData.map({(value) -> ProductCollectionModel in
            return  ProductCollectionModel(data:JSON(value))
        })
        }
    }
    
    
    var totalCount:Int{
        return extraData.totalCount
    }
    
    var getSortCollectionData:Array<SortCollectionData>{
        return sortCollectionModel;
    }
    
    
    
    
    
    
}



