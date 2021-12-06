//
//  MyDownloads.swift
//  OpenCartApplication
//
//  Created by Kunal Parsad on 04/09/17.
//  Copyright © 2017 webkul. All rights reserved.
//

import UIKit

class MyDownloads: UIViewController,UITableViewDelegate, UITableViewDataSource {
let defaults = UserDefaults.standard;
var pageNumber:Int = 1
    
@IBOutlet weak var emptyMessage: UILabel!
@IBOutlet weak var downloadTableView: UITableView!
var myDownloadViewModel:MyDownloadViewModel!
var documentPathUrl:NSURL!
var emptyView:EmptyNewAddressView!

    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.downloadTableView.separatorStyle = .none
        self.downloadTableView.backgroundColor = UIColor.clear
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.title = NetworkManager.sharedInstance.language(key: "downloads");
        let sessionId = defaults.object(forKey:"wk_token")
        emptyMessage.isHidden = true;
        if(sessionId == nil){
            loginRequest();
        }
        else{
            callingHttppApi();
        }

        emptyView = EmptyNewAddressView(frame: self.view.frame);
        self.view.addSubview(emptyView)
        emptyView.isHidden = true;
        emptyView.emptyImages.image = UIImage(named: "empty_downloads")!
        emptyView.addressButton.setTitle(NetworkManager.sharedInstance.language(key: "browsecategory"), for: .normal)
        emptyView.labelMessage.text = NetworkManager.sharedInstance.language(key: "emptydownloadmessgae")
        emptyView.addressButton.isHidden = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }

    func loginRequest(){
        var loginRequest = [String:String]();
        loginRequest["apiKey"] = API_USER_NAME;
        loginRequest["apiPassword"] = API_KEY.md5;
        if self.defaults.object(forKey: "language") != nil{
            loginRequest["language"] = self.defaults.object(forKey: "language") as? String;
        }
        if self.defaults.object(forKey: "currency") != nil{
            loginRequest["currency"] = self.defaults.object(forKey: "currency") as? String;
        }
        if self.defaults.object(forKey: "customer_id") != nil{
            loginRequest["customer_id"] = self.defaults.object(forKey: "customer_id") as? String;
        }
        NetworkManager.sharedInstance.callingHttpRequest(params:loginRequest, apiname:"common/apiLogin", cuurentView: self){val,responseObject in
            if val == 1{
                let dict = responseObject as! NSDictionary
                self.defaults.set(dict.object(forKey: "wk_token") as! String, forKey: "wk_token")
                self.defaults.set(dict.object(forKey: "language") as! String, forKey: "language")
                self.defaults.set(dict.object(forKey: "currency") as! String, forKey: "currency")
                self.defaults.synchronize();
                self.callingHttppApi()
            }else if val == 2{
             NetworkManager.sharedInstance.dismissLoader()
             self.loginRequest()
                
            }
        }
    }
    
    func callingHttppApi(){
            self.view.isUserInteractionEnabled = false
            NetworkManager.sharedInstance.showLoader()
            let sessionId = self.defaults.object(forKey:"wk_token");
            var requstParams = [String:Any]();
            requstParams["wk_token"] = sessionId;
            requstParams["page"] = "\(pageNumber)";
            NetworkManager.sharedInstance.callingHttpRequest(params:requstParams, apiname:"customer/getDownloadInfo", cuurentView: self){success,responseObject in
            if success == 1 {
                    NetworkManager.sharedInstance.dismissLoader()
                    let dict = responseObject as! NSDictionary;
                    if dict.object(forKey: "fault") != nil{
                        let fault = dict.object(forKey: "fault") as! Bool;
                        if fault == true{
                            self.loginRequest()
                        }
                    }else{
                    
                       self.view.isUserInteractionEnabled = true
                       self.myDownloadViewModel = MyDownloadViewModel(data:JSON(dict))
                       self.doFurtherProcessingWithResult()
                    }
                    
                }else if success == 2{
                    NetworkManager.sharedInstance.dismissLoader()
                    self.callingHttppApi();
                }
            }
    }
    
    
    

    
    func doFurtherProcessingWithResult(){
        
        if myDownloadViewModel.getMyDownloadData.count > 0{
          downloadTableView.delegate  = self
          downloadTableView.dataSource = self
          downloadTableView.reloadData()
          self.downloadTableView.isHidden = false
          self.emptyView.isHidden = true
        }else{
            self.downloadTableView.isHidden = true
            self.emptyView.isHidden = false
        }
        
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
      return 170
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int{
        return 1;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return myDownloadViewModel.getMyDownloadData.count
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let CellIdentifier: String = "cell"
        tableView.register(UINib(nibName: "DownloadTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        let cell:DownloadTableViewCell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier) as! DownloadTableViewCell
        cell.orderID.text = NetworkManager.sharedInstance.language(key: "orderid")+" : "+myDownloadViewModel.getMyDownloadData[indexPath.row].orderId
        cell.nameValue.text = myDownloadViewModel.getMyDownloadData[indexPath.row].name
        cell.sizeValue.text = myDownloadViewModel.getMyDownloadData[indexPath.row].size
        cell.dateValue.text = myDownloadViewModel.getMyDownloadData[indexPath.row].date
        
        cell.layer.borderWidth = 2.0
        cell.layer.borderColor = UIColor.gray.cgColor
        cell.downloadButton.tag = indexPath.row
        cell.downloadButton.addTarget(self, action: #selector(downloadClick(sender:)), for: .touchUpInside)
        return cell
    }
    
    @objc func downloadClick(sender: UIButton){
        NetworkManager.sharedInstance.showLoader()
        let fileName = myDownloadViewModel.getMyDownloadData[sender.tag].file
        let url = myDownloadViewModel.getMyDownloadData[sender.tag].url
        self.load(url: URL(string: url)!, name: fileName)
        
    }
    
    func load(url: URL, name:String){
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig)
        let request = try! URLRequest(url: url, method: .post)
        
        let task = session.downloadTask(with: request) { (tempLocalUrl, response, error) in
            if let tempLocalUrl = tempLocalUrl, error == nil {
                // Success
                NetworkManager.sharedInstance.dismissLoader()
                guard let statusCode = (response as? HTTPURLResponse)?.statusCode , statusCode != 404 else{
                    NetworkManager.sharedInstance.showWarningSnackBar(msg: "nofilefound".localized)
                    return
                }
                do{
                    let largeImageData = try Data(contentsOf: tempLocalUrl)
                    let documentsDirectoryURL = try! FileManager().url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
                    let fileURL = documentsDirectoryURL.appendingPathComponent(name);
                    
                    
                    if !FileManager.default.fileExists(atPath: fileURL.path) {
                        do {
                            try largeImageData.write(to: fileURL)
                            let AC = UIAlertController(title:NetworkManager.sharedInstance.language(key: "success"), message:NetworkManager.sharedInstance.language(key: "filesavemessage"), preferredStyle: .alert)
                            let okBtn = UIAlertAction(title: "open".localized, style: .default, handler: {(_ action: UIAlertAction) -> Void in
                                self.documentPathUrl = fileURL as NSURL;
                                let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ShowDownloadFile") as? ShowDownloadFile
                                vc?.documentUrl = self.documentPathUrl
                                self.navigationController?.pushViewController(vc!, animated: true)
                                
                            })
                            let noBtn = UIAlertAction(title: NetworkManager.sharedInstance.language(key: "cancel"), style: .destructive, handler: {(_ action: UIAlertAction) -> Void in
                                
                            })
                            AC.addAction(okBtn)
                            AC.addAction(noBtn)
                            self.present(AC, animated: true, completion: { })
                            
                        } catch {
                            print(error)
                        }
                    } else {
                        NetworkManager.sharedInstance.dismissLoader()
                        let AC = UIAlertController(title:NetworkManager.sharedInstance.language(key: "success"), message:NetworkManager.sharedInstance.language(key: "opensavefile"), preferredStyle: .alert)
                        let okBtn = UIAlertAction(title: "open".localized, style: .default, handler: {(_ action: UIAlertAction) -> Void in
                            self.documentPathUrl = fileURL as NSURL;
                            let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ShowDownloadFile") as? ShowDownloadFile
                            vc?.documentUrl = self.documentPathUrl
                            self.navigationController?.pushViewController(vc!, animated: true)
                            
                        })
                        let noBtn = UIAlertAction(title: NetworkManager.sharedInstance.language(key: "cancel"), style: .destructive, handler: {(_ action: UIAlertAction) -> Void in
                            
                        })
                        AC.addAction(okBtn)
                        AC.addAction(noBtn)
                        self.present(AC, animated: true, completion: { })
                        
                     
                    }
                    
                }catch{
                    print("error");
                }
                
                
                
                do {
                    
                } catch (let writeError) {
                    
                }
                
            } else {
                NetworkManager.sharedInstance.dismissLoader()
                print("Failure: %@", error?.localizedDescription);
            }
        }
        task.resume()
    }
   

    
    
    
    
    
}
