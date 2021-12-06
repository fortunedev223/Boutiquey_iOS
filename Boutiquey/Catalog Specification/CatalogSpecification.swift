//
//  CatalogSpecification.swift
//  Opencart
//
//  Created by kunal on 12/01/18.
//  Copyright © 2018 Kunal Parsad. All rights reserved.
//

import UIKit

class CatalogSpecification: UIViewController,UITableViewDelegate, UITableViewDataSource{

@IBOutlet weak var specificationTableView: UITableView!
var catalogProductViewModel:CatalogProductViewModel!
    
    
    override func viewDidLoad() {
    super.viewDidLoad()
     self.navigationItem.title = "specification".localized
     specificationTableView.register(UINib(nibName: "SpecificationCell", bundle: nil), forCellReuseIdentifier: "SpecificationCell")
        self.specificationTableView.rowHeight = UITableView.automaticDimension
     self.specificationTableView.estimatedRowHeight = 20
     self.specificationTableView.delegate = self
     self.specificationTableView.dataSource = self
     specificationTableView.separatorColor = UIColor.clear
        
    }
    
    
    
    public func numberOfSections(in tableView: UITableView) -> Int{
        return catalogProductViewModel.attributes_Data.count;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return catalogProductViewModel.attributes_Data[section].attributesDataArray.count
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:SpecificationCell = tableView.dequeueReusableCell(withIdentifier: "SpecificationCell") as! SpecificationCell
        cell.heading.text = catalogProductViewModel.attributes_Data[indexPath.section].attributesDataArray[indexPath.row].title
        cell.value.text = catalogProductViewModel.attributes_Data[indexPath.section].attributesDataArray[indexPath.row].value
    
        return cell
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return catalogProductViewModel.attributes_Data[section].name
    }
   
}
