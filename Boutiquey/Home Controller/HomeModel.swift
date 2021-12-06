//
//  HomeModel.swift
//  OpenCartMpV3
//
//  Created by kunal on 11/12/17.
//  Copyright © 2017 kunal. All rights reserved.
//

import Foundation

struct HomeModal {
    var bannerCollectionModel = [BannerData]()
    var cataegoriesCollectionModel = [Categories]()
    var latestProductCollectionModel = [Products]()
    var layeredProductCollectionModel = [LayerdProducts]()
    var brandProduct = [BrandProducts]()
    var currencyData  = [Currency]()
    var languageData = [Languages]()
    var footermenuData = [Footermenus]()
    
    var cartCount:Int = 0
    
    var guestCheckOut:Bool!
    
    init?(data : JSON) {
        if let arrayData = data["banners"].array{
        bannerCollectionModel =  arrayData.map({(value) -> BannerData in
            return  BannerData(data:value)
        })
        }
        
        if let arrayData1 = data["categories"].array{
        cataegoriesCollectionModel =  arrayData1.map({(value) -> Categories in
            return  Categories(data:value)
        })
        }
        
        if let arrayData2 = data["latestProducts"]["products"].array{
        latestProductCollectionModel =  arrayData2.map({(value) -> Products in
            return  Products(data:value)
        })
        }
        
        if let arrayData3 = data["modules"].array{
        layeredProductCollectionModel =  arrayData3.map({(value) -> LayerdProducts in
            return  LayerdProducts(data:value)
        })
        }
        
        if let arrayData4 = data["carousel"].array{
        brandProduct =  arrayData4.map({(value) -> BrandProducts in
            return  BrandProducts(data:value)
        })
        }
        
        
        if let arrayData5 = data["currencies"]["currencies"].array{
        currencyData =  arrayData5.map({(value) -> Currency in
            return  Currency(data:value)
        })
        }
        
        if let arrayData6 = data["languages"]["languages"].array{
        languageData =  arrayData6.map({(value) -> Languages in
            return  Languages(data:value)
        })
        }
        
        if let arrayData7 = data["footerMenu"].array{
            footermenuData = arrayData7.map({(value) -> Footermenus in
                return Footermenus(data:value)
            })
        }
        
        guestCheckOut =  data["guest_status"].boolValue
        sharedPrefrence.set(data["languages"]["code"].stringValue, forKey: "language")
        sharedPrefrence.set(data["currencies"]["code"].stringValue, forKey: "currency")
        sharedPrefrence.synchronize()
        cartCount = data["cart"].intValue
        
        
    }
    
}




struct LayerdProducts{
    var link:String = ""
    var title:String = ""
    
    
    var productCollectionModel = [Products]()
    
    init(data:JSON) {
        if let arrayData = data["products"].array{
            productCollectionModel =  arrayData.map({(value) -> Products in
                return  Products(data:value)
            })
        }
        self.link = data["id"].stringValue
        self.title = data["name"].stringValue
    }
    
}



struct BannerData{
    var bannerType:String!
    var imageUrl:String!
    var bannerLink:String!
    var bannerName:String!
    var dominant_color:String = ""
    
    
    init(data:JSON){
        bannerType = data["type"].stringValue
        imageUrl  = data["image"].stringValue
        bannerLink = data["link"].stringValue
        bannerName = data["title"].stringValue
        self.dominant_color = data["dominant_color"].stringValue
    }
}

struct Categories{
    var id:String!
    var name:String!
    var image:String!
    var thumbnail:String!
    var dominant_color:String = ""
    var dominant_color_icon:String = ""
    var isChild:Bool = false
    
    
    init(data:JSON){
        name  = data["name"].stringValue.html2String
        id = data["path"].stringValue
        image = data["icon"].stringValue
        self.thumbnail = data["image"].stringValue
        self.dominant_color = data["dominant_color"].stringValue
        self.dominant_color_icon = data["dominant_color_icon"].stringValue
        isChild = data["child_status"].boolValue
    }
}

struct Footermenus {
    var status: String!
    var information_id: String!
    var title: String!
    var sort_order: String!
    
    init(data:JSON){
        status = data["status"].stringValue
        information_id = data["information_id"].stringValue
        title = data["title"].stringValue
        sort_order = data["sort_order"].stringValue
    }
}

struct Products{
    var hasOption:Int!
    var name:String!
    var price:String!
    var productID:String!
    var rating:String!
    var ratingValue:Double!
    var specialPrice:Float!
    var image:String!
    var formatted_special:String = ""
    var isInWishList:Int = 0
    var dominant_color:String = ""
    
    init(data:JSON) {
        self.hasOption = data["hasOption"].intValue
        self.name = data["name"].stringValue
        self.price = data["price"].stringValue
        self.productID = data["product_id"].stringValue
        self.rating = data["rating"].stringValue
        self.ratingValue = data["rating"].doubleValue
        self.specialPrice = data["special"].floatValue
        self.image = data["thumb"].stringValue
        self.formatted_special = data["formatted_special"].stringValue
        self.isInWishList = data["wishlist_status"].intValue
        self.dominant_color = data["dominant_color"].stringValue
    }
}


struct BrandProducts{
    var image:String!
    var  link:String!
    var title:String!
    var dominant_color:String = ""
    
    init(data:JSON) {
        self.image = data["image"].stringValue
        self.link = data["link"].stringValue
        self.title = data["title"].stringValue
        self.dominant_color = data["dominant_color"].stringValue
    }
}


struct Currency {
    var code:String!
    var title:String!
    init(data:JSON) {
        self.code = data["code"].stringValue
        self.title = data["title"].stringValue
    }
}


struct Languages {
    var code:String!
    var title:String!
    
    init(data:JSON){
        self.code = data["code"].stringValue
        self.title = data["name"].stringValue
    }
}


enum HomeViewModelItemType {
    
    case Category
    case Banner
    case LatestProduct
    case RecentViewData
    case Brand
    case Footermenu
    
}

protocol HomeViewModelItem {
    var type: HomeViewModelItemType { get }
    var sectionTitle: String { get }
    var rowCount: Int { get }
}

class HomeViewModelBannerItem: HomeViewModelItem {
    var type: HomeViewModelItemType {
        return .Banner
    }
    
    var sectionTitle: String {
        return ""
    }
    
    var rowCount: Int {
        return bannerCollectionModel.count
    }
    
    var bannerCollectionModel = [BannerData]()
    
    init(categories: [BannerData]) {
        self.bannerCollectionModel = categories
    }
    
}


class HomeViewModelLatestItem: HomeViewModelItem {
    var type: HomeViewModelItemType {
        return .LatestProduct
    }
    
    var sectionTitle: String {
        return ""
    }
    
    var rowCount: Int {
        return productCollectionModel.count
    }
    
    var link:String = ""
    var title:String = ""
    var productCollectionModel = [Products]()
    
    init(categories: LayerdProducts) {
        self.productCollectionModel = categories.productCollectionModel
        self.link = categories.link
        self.title = categories.title
    }
    
}
//
//class HomeViewModelFeatureItem: HomeViewModelItem {
//    var type: HomeViewModelItemType {
//        return .FeatureProduct
//    }
//
//    var sectionTitle: String {
//        return ""
//    }
//
//    var rowCount: Int {
//        return featuredProductCollectionModel.count
//    }
//
//    var featuredProductCollectionModel = [Products]()
//
//    init(categories: [Products]) {
//        self.featuredProductCollectionModel = categories
//    }
//
//}

class HomeViewModelRecentViewItem: HomeViewModelItem    {
    var type: HomeViewModelItemType {
        return .RecentViewData
    }
    
    var sectionTitle: String {
        return ""
    }
    
    var rowCount: Int {
        return recentViewProductData.count
    }
    
    var recentViewProductData = [Productcollection]()
    
    init(categories: [Productcollection]) {
        self.recentViewProductData = categories
    }
    
}

class HomeViewModelBrandItem: HomeViewModelItem {
    var type: HomeViewModelItemType {
        return .Brand
    }
    
    var sectionTitle: String {
        return ""
    }
    
    var rowCount: Int {
        return brandProduct.count
    }
    
    var brandProduct = [BrandProducts]()
    
    init(categories: [BrandProducts]) {
        self.brandProduct = categories
    }
    
}



class HomeViewModelCategoryItem: HomeViewModelItem {
    var type: HomeViewModelItemType {
        
        return .Category
    }
    
    var sectionTitle: String {
        return ""
    }
    
    var rowCount: Int {
        return cataegoriesCollectionModel.count
    }
    
    var cataegoriesCollectionModel = [Categories]()
    
    init(categories: [Categories]) {
        self.cataegoriesCollectionModel = categories
    }
    
}

class HomeViewModelFootermenuItem: HomeViewModelItem{
    var type: HomeViewModelItemType{
        return .Footermenu
    }
    
    var sectionTitle: String{
        return ""
    }
    
    var rowCount: Int{
        return footermenuData.count
    }
    
    var footermenuData = [Footermenus]()
    
    init(footermenus: [Footermenus]){
        self.footermenuData = footermenus
    }
}

class HomeViewModel : NSObject {
    var items = [HomeViewModelItem]()
    var cataegoriesCollectionModel = [Categories]()
    //var featuredProductCollectionModel = [Products]()
    var latestProductCollectionModel = [Products]()
    var brandProduct = [BrandProducts]()
    var currencyData  = [Currency]()
    var languageData = [Languages]()
    var footermenuData = [Footermenus]()
    var homeViewController:ViewController!
    var guestCheckOut:Bool!
     var cartCount:Int = 0
    
    
    func getData(data : JSON  , recentViewData : [Productcollection] , completion:(_ data: Bool) -> Void) {
        guard let data = HomeModal(data: data) else {
            return
        }
        
        items.removeAll()
        
        if !data.bannerCollectionModel.isEmpty {
            let bannerDataCollectionItem = HomeViewModelBannerItem(categories: data.bannerCollectionModel)
            items.append(bannerDataCollectionItem)
        }
        
        if !data.cataegoriesCollectionModel.isEmpty {
            let categoryCollectionItem = HomeViewModelCategoryItem(categories: data.cataegoriesCollectionModel)
            cataegoriesCollectionModel = data.cataegoriesCollectionModel;
            items.append(categoryCollectionItem)
        }

        
//        for i in 0..<data.layeredProductCollectionModel.count{
//            print("herheh", data.layeredProductCollectionModel.count)
//            let bannerCollectionItem = HomeViewModelLatestItem(categories: data.layeredProductCollectionModel[i])
//
            items.append(HomeViewModelLatestItem(categories: data.layeredProductCollectionModel[2]))
            items.append(HomeViewModelLatestItem(categories: data.layeredProductCollectionModel[0]))
            items.append(HomeViewModelLatestItem(categories: data.layeredProductCollectionModel[1]))
            items.append(HomeViewModelLatestItem(categories: data.layeredProductCollectionModel[3]))
//        }
       
        
        if !recentViewData.isEmpty {
            let recentViewCollectionItem = HomeViewModelRecentViewItem(categories: recentViewData)
            items.append(recentViewCollectionItem)
        }
        
        if !data.brandProduct.isEmpty {
            let brandCollectionItem = HomeViewModelBrandItem(categories: data.brandProduct)
            items.append(brandCollectionItem)
            brandProduct = data.brandProduct
        }
        
        if !data.footermenuData.isEmpty {
            let footermenuItem = HomeViewModelFootermenuItem(footermenus: data.footermenuData)
            items.append(footermenuItem)
            footermenuData = data.footermenuData
        }
        
        if !data.currencyData.isEmpty{
            currencyData = data.currencyData
        }
        if !data.languageData.isEmpty{
            languageData = data.languageData
        }
        
        guestCheckOut = data.guestCheckOut
        cartCount = data.cartCount
        
        completion(true)
    }
}


extension HomeViewModel : UITableViewDelegate , UITableViewDataSource {
    public func numberOfSections(in tableView: UITableView) -> Int{
        return items.count-1 ;
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = items[indexPath.section]
        
        switch item.type {
        case .Banner:
            let cell:BannerTableViewCell = tableView.dequeueReusableCell(withIdentifier: BannerTableViewCell.identifier) as! BannerTableViewCell
            cell.delegate = homeViewController
            cell.bannerCollectionModel = ((item as? HomeViewModelBannerItem)?.bannerCollectionModel)!
            return cell;

            
        case .Category:
            let cell:TopCategoryTableViewCell = tableView.dequeueReusableCell(withIdentifier: TopCategoryTableViewCell.identifier) as! TopCategoryTableViewCell
            cell.featureCategoryCollectionModel = ((item as? HomeViewModelCategoryItem)?.cataegoriesCollectionModel)!
            cell.delegate = homeViewController
            cell.categoryCollectionView.reloadData()
            return cell;
            
        case .LatestProduct:
            let cell:ProductTableViewCell = tableView.dequeueReusableCell(withIdentifier: ProductTableViewCell.identifier) as! ProductTableViewCell
            cell.productCollectionModel = ((item as? HomeViewModelLatestItem)?.productCollectionModel)!
            cell.prodcutCollectionView.tag = indexPath.section
            cell.delegate = homeViewController
            cell.homeViewModel = homeViewController.homeViewModel
            cell.frame = tableView.bounds
            cell.layoutIfNeeded()
            cell.prodcutCollectionView.reloadData()
            cell.productCollectionViewHeight.constant = cell.prodcutCollectionView.collectionViewLayout.collectionViewContentSize.height
            cell.newProductLabel.text = ((item as? HomeViewModelLatestItem)?.title)!
            cell.viewAllID = ((item as? HomeViewModelLatestItem)?.link)!

            cell.items = self.items
            cell.controller = self.homeViewController
            cell.sectionValue = indexPath.section
            return cell;
          
            
        case .RecentViewData:
            let cell:RecentViewTableViewCell = tableView.dequeueReusableCell(withIdentifier: RecentViewTableViewCell.identifier) as! RecentViewTableViewCell
            cell.recentCollectionModel = ((item as? HomeViewModelRecentViewItem)?.recentViewProductData)!
            cell.recentViewCollectionView.reloadData()
            cell.delegate = homeViewController
            return cell
           
            
        case .Brand:
            let cell:BrandTableViewCell = tableView.dequeueReusableCell(withIdentifier: BrandTableViewCell.identifier) as! BrandTableViewCell
            cell.brandCollectionModel = ((item as? HomeViewModelBrandItem)?.brandProduct)!
            cell.delegate = homeViewController
            return cell;
            
            
        case .Footermenu:
            let cell:BrandTableViewCell = tableView.dequeueReusableCell(withIdentifier: BrandTableViewCell.identifier) as! BrandTableViewCell
            cell.brandCollectionModel = ((item as? HomeViewModelBrandItem)?.brandProduct)!
            cell.delegate = homeViewController
            return cell;
//            let cell:FootermenuCell = tableView.dequeueReusableCell(withIdentifier: FootermenuCell.identifier) as! FootermenuCell
//            cell.footermenu = ((item as? HomeViewModelFootermenuItem)?.footermenuData)!
//            cell.delegate = homeViewController
//            return cell;
          
            
       
        }
        
        //return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let item = items[indexPath.section]
        switch item.type {
        case .Banner:
            return SCREEN_WIDTH / 2
            
        case .Category:
            return 120
            
        case .LatestProduct:
            return UITableView.automaticDimension
            
        case .RecentViewData:
            return SCREEN_WIDTH / 2 + 140
            
        case .Brand:
            return SCREEN_WIDTH / 3 + 16
            
        case .Footermenu:
            return SCREEN_WIDTH / 3 + 16
            
        }
    }
    
    
    
}
