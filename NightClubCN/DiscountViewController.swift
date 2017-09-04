//
//  DiscountViewController.swift
//  NightClubCN
//
//  Created by YeouTimothy on 2017/8/9.
//  Copyright © 2017年 Wework. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class DiscountViewController: UIViewController, BackDelegate {
    
    var discountList = [Discount]()
    
    @IBOutlet weak var navigationBar: CustomNavigationView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationBar.backDelegate = self
        
        collectionView.register(UINib(nibName: "DiscountCollectionViewCell", bundle:nil), forCellWithReuseIdentifier: "Cell")
        collectionView.delegate = self
        collectionView.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        discountList = [Discount]()
        getDetail(id: "")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func back() {
        self.navigationController?.popViewController(animated: false)
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

extension DiscountViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout
        collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.bounds.width/2 - 10, height: self.view.bounds.width/2 + 30)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return discountList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! DiscountCollectionViewCell
        cell.discount = discountList[indexPath.item]
        
        return cell
    }
    
    func getDetail(id:String){
        WebConfig.Manager.request("\(WebConfig.webUrl)goodieslist", method: .post, parameters: [:], encoding: URLEncoding.default, headers: WebConfig.headers).response { response in
            if let data = response.data {
                let json: JSON = JSON(data: data)
                print(json)
                
                if let error = json["error"].bool{
                    if error{
                        return
                    }
                }
                
                if let data = json["data"].array{
                    for discounts in data{
                        let discount = Discount()
                        
                        if let id = discounts["id"].string{
                            discount.id = id
                        }
                        
                        if let title = discounts["title"].string{
                            discount.title = title
                        }
                        
                        if let img = discounts["img"].string{
                            discount.image = img
                        }
                        
                        if let link = discounts["link"].string{
                            discount.link = link
                        }
                        self.discountList.append(discount)
                    }
                }
                
                self.collectionView.reloadData()
            }
            
        }
    }
    
    
    
}

class Discount{
    
    var id:String?
    var image:String?
    var title:String?
    var link:String?
    
}
