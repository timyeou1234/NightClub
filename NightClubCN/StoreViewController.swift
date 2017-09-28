//
//  StoreViewController.swift
//  NightClubCN
//
//  Created by YeouTimothy on 2017/8/16.
//  Copyright © 2017年 Wework. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class StoreViewController: UIViewController, BackDelegate {

    var storeList = [Store]()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var navigation: CustomNavigationView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigation.backDelegate = self
        tableView.register(UINib(nibName: "StoreTableViewCell", bundle: nil), forCellReuseIdentifier: "Cell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 60
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getList()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func back() {
        self.navigationController?.popViewController(animated: true)
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if let destinationViewController = segue.destination as? StoreDetailViewController{
            destinationViewController.store = sender as! Store
        }
        
    }
    

}

extension StoreViewController: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showDetail", sender: storeList[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return storeList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! StoreTableViewCell
        
        cell.sourceViewController = self
        cell.store = storeList[indexPath.row]
        return cell
    }
    
    func getList(){
        WebConfig.Manager.request("\(WebConfig.webUrl)storelist", method: .post, parameters: [:], encoding: URLEncoding.default, headers: WebConfig.headers).response { response in
            if let data = response.data {
                let json: JSON = JSON(data: data)
                print(json)
                
                if let error = json["error"].bool{
                    if error{
                        return
                    }
                }
                
                if let data = json["data"].array{
                    self.storeList = [Store]()
                    for stores in data{
                        let store = Store()
                        
                        if let id = stores["id"].string{
                            store.id = id
                        }
                        
                        if let store_name = stores["store_name"].string{
                            store.store_name = store_name
                        }
                        
                        if let store_addr = stores["store_addr"].string{
                            store.store_addr = store_addr
                        }
                        
                        if let open_hours = stores["open_hours"].string{
                            store.open_hours = open_hours
                        }
                        
                        if let tel = stores["tel"].string{
                            store.tel = tel
                        }
                        
                        if let list_img = stores["list_img"].string{
                            store.list_img = list_img
                        }
                        
                        if let list_ad_tag = stores["list_ad_tag"].string{
                            store.list_ad_tag = list_ad_tag
                        }
                        
                        if let created_at = stores["created_at"].string{
                            store.created_at = created_at
                        }
                        self.storeList.append(store)
                    }
                    self.tableView.reloadData()
                }
                
                
            }
            
        }
    }
    
}

class Store{
    
    var id:String?
    var store_name:String?
    var store_addr:String?
    var open_hours:String?
    var tel:String?
    var list_img:String?
    var list_ad_tag:String?
    var created_at:String?
    var store_desc:String?
    var imageArray:[String]?
    var ad_tag:String?
    var lon:String?
    var lat:String?
    
}

