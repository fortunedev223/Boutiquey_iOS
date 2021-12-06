//
//  CategoriesController.swift
//  OpenCartMpV3
//
//  Created by kunal on 12/12/17.
//  Copyright © 2017 kunal. All rights reserved.
//

import UIKit
import LMCSideMenu

class CategoriesController: UIViewController, LMCSideMenuCenterControllerProtocol, UITableViewDelegate, UITableViewDataSource {
   
    var interactor: MenuTransitionInteractor = MenuTransitionInteractor()
    
    @IBOutlet weak var categoriesTableView: UITableView!
    
    var cataegoriesCollectionModel = [Categories]()
    var arrayForBool :NSMutableArray = [];
    var categoryName:String = ""
    var categoryId:String = ""
    var categoryDict :NSDictionary = [:]
    var subCategory:NSArray = []
    var subId:String = ""
    var subName:String = ""
    
    
    var catnotificationButton = SSBadgeButton()
    let defaults = UserDefaults.standard
    
    @IBAction func openSideMenu(_ sender: Any) {
        if(self.defaults.object(forKey: "language") as! String != "ar"){
            presentLeftMenu()
        }else {
            presentRightMenu()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let leftMenuController = storyboard.instantiateViewController(withIdentifier: String(describing: LeftMenuController.self)) as! LeftMenuController
        let rightMenuController = storyboard.instantiateViewController(withIdentifier: String(describing: RightMenuController.self)) as! RightMenuController
        
        //Setup menu
        setupMenu(leftMenu: leftMenuController, rightMenu: rightMenuController)
        //        MenuHelper.set(menuWidth: 0.8)
        
        //enable screen edge gestures if needed
        if(self.defaults.object(forKey: "language") as! String != "ar"){
            enableLeftMenuGesture()
            disableRightMenuGesture()
        }else {
            disableLeftMenuGesture()
            enableRightMenuGesture()
        }
        
        self.navigationItem.title = NetworkManager.sharedInstance.language(key: "categories")
        let paymentViewNavigationController = self.tabBarController?.viewControllers?[0]
        let nav1 = paymentViewNavigationController as! UINavigationController;
        let paymentMethodViewController = nav1.viewControllers[0] as! ViewController
        cataegoriesCollectionModel = paymentMethodViewController.homeViewModel.cataegoriesCollectionModel
        categoriesTableView.register(UINib(nibName: "CategoryCellTableViewCell", bundle: nil), forCellReuseIdentifier: "CategoryCellTableViewCell")
        self.categoriesTableView.separatorStyle = .none
        categoriesTableView.delegate = self;
        categoriesTableView.dataSource = self;
        categoriesTableView.separatorColor = UIColor.clear
        
        

    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if(ViewController.selfVC.countofcart != ""){
        catnotificationButton.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
        catnotificationButton.setImage(UIImage(named: "ic_cart")?.withRenderingMode(.alwaysTemplate), for: .normal)
        catnotificationButton.badgeEdgeInsets = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 10)
        catnotificationButton.addTarget(self, action: #selector(self.gotoAddToCart(_:)), for: .touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: catnotificationButton)
         
        self.catnotificationButton.badge = ViewController.selfVC.countofcart
    }
    }
    
    @IBAction func gotoAddToCart(_ sender:Any!) {
        // do cool stuff here
        print("gotoAddToCart")
        
        performSegue(withIdentifier: "mycart", sender: self)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat{
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return SCREEN_WIDTH / 2;
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.white
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cataegoriesCollectionModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        categoriesTableView.register(UINib(nibName: "CategoryCellTableViewCell", bundle: nil), forCellReuseIdentifier: "CategoryCellTableViewCell")
        let cell:CategoryCellTableViewCell = tableView.dequeueReusableCell(withIdentifier: "CategoryCellTableViewCell") as! CategoryCellTableViewCell
        cell.image1.loadImageFrom(url:cataegoriesCollectionModel[indexPath.row].thumbnail , dominantColor: cataegoriesCollectionModel[indexPath.row].dominant_color)
        cell.nameLabel.text = cataegoriesCollectionModel[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let isChild = cataegoriesCollectionModel[indexPath.row].isChild
        if isChild{
            subId = cataegoriesCollectionModel[indexPath.row].id
            subName = cataegoriesCollectionModel[indexPath.row].name
            self.performSegue(withIdentifier: "subcategory", sender: self)
        }
        else{
            categoryId = cataegoriesCollectionModel[indexPath.row].id
            categoryName = cataegoriesCollectionModel[indexPath.row].name
            self.performSegue(withIdentifier: "productCategorySegue", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "productCategorySegue") {
            let viewController:Productcategory = segue.destination as UIViewController as! Productcategory
            viewController.categoryType = ""
            viewController.categoryName = self.categoryName
            viewController.categoryId = self.categoryId
        }else if (segue.identifier == "subcategory") {
            let viewController:subCategory = segue.destination as UIViewController as! subCategory
            viewController.subName = subName
            viewController.subId = subId
            
        }
    }
}
