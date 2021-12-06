//
//  BannerTableViewCell.swift
//  WooCommerce
//
//  Created by Kunal Parsad on 04/11/17.
//  Copyright © 2017 Kunal Parsad. All rights reserved.
//

@objc protocol bannerViewControllerHandlerDelegate: class {
    func bannerProductClick(type:String,image:String,id:String,title:String)
}






import UIKit
import FSPagerView



class BannerTableViewCell: UITableViewCell {
var delegate:bannerViewControllerHandlerDelegate!
var bannerCollectionModel = [BannerData]()
var index:Int = 0
@IBOutlet var pagerView: FSPagerView!
@IBOutlet var pagerControl: FSPageControl!
    
    
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.pagerView.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cell")
        self.pagerView.dataSource = self
        self.pagerView.delegate = self
        self.pagerView.interitemSpacing = CGFloat(10)
        self.pagerView.itemSize = .zero
        self.pagerView.reloadData()
        self.pagerView.transformer = FSPagerViewTransformer(type:.zoomOut)
        
       
    }
    override func layoutSubviews() {
        self.pagerView.itemSize = self.pagerView.frame.size.applying(CGAffineTransform(scaleX: 0.9, y: 0.9))
        self.pagerControl.numberOfPages = self.bannerCollectionModel.count
        self.pagerControl.contentHorizontalAlignment = .center
        self.pagerControl.contentInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        self.pagerView.automaticSlidingInterval = 3.0
    }
    
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    static var nib:UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    static var identifier: String {
        return String(describing: self)
    }
    
}

extension BannerTableViewCell:FSPagerViewDataSource,FSPagerViewDelegate {
    
   
    public func numberOfItems(in pagerView: FSPagerView) -> Int {
         return bannerCollectionModel.count
    }
    
    public func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
        cell.imageView?.loadImageFrom(url:bannerCollectionModel[index].imageUrl , dominantColor: bannerCollectionModel[index].dominant_color)
        
        cell.imageView?.contentMode = .scaleAspectFill
        cell.imageView?.clipsToBounds = true
        cell.layer.cornerRadius = 10;
        cell.layer.masksToBounds = true
        
        return cell
    }
    
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        pagerView.deselectItem(at: index, animated: true)
        pagerView.scrollToItem(at: index, animated: true)
        
       delegate.bannerProductClick(type: bannerCollectionModel[index].bannerType, image: bannerCollectionModel[index].imageUrl, id: bannerCollectionModel[index].bannerLink,title:bannerCollectionModel[index].bannerName)
        
        self.pagerControl.currentPage = index
    }
    
    func pagerViewDidScroll(_ pagerView: FSPagerView) {
        guard self.pagerControl.currentPage != pagerView.currentIndex else {
            return
        }
        self.pagerControl.currentPage = pagerView.currentIndex // Or Use KVO with property "currentIndex"
    }
    
    
    
    
    
    
    
    
}
