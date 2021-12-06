//
/**
offers
@Category Webkul
@author Webkul <support@webkul.com>
FileName: ProductReviewModel.swift
Copyright (c) 2010-2018 Webkul Software Private Limited (https://webkul.com)
@license   https://store.webkul.com/license.html
*/

import Foundation


class ProductReviewViewModel{
    var reviewsData = [ReviewsData]()
    var total:Int = 0
    
    init(data:JSON) {
        if let result =  data["reviews"].array{
            self.reviewsData = result.map({ (value) -> ReviewsData in
                ReviewsData(data:value)
            })
        }
        self.total = data["total"].intValue
    }
    
    
    func setProductreviewData(data:JSON){
        if let result =  data["reviews"].array{
            self.reviewsData = self.reviewsData + result.map({ (value) -> ReviewsData in
                ReviewsData(data:value)
            })
        }
        
        
    }
    
    
}
