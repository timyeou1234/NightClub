//
//  StoreDetailViewController.swift
//  NightClubCN
//
//  Created by YeouTimothy on 2017/8/17.
//  Copyright © 2017年 Wework. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class StoreDetailViewController: UIViewController, BackDelegate{
    
    var store = Store()
    
    @IBOutlet weak var countLable: UILabel!
    @IBOutlet weak var navigation: CustomNavigationView!
    @IBOutlet weak var sliderCollectionView: UICollectionView!
    @IBOutlet weak var titleLable: UILabel!
    @IBOutlet weak var addrLable: UILabel!
    @IBOutlet weak var timeLable: UILabel!
    @IBOutlet weak var phoneButton: UIButton!
    @IBOutlet weak var adButton: UIButton!
    @IBOutlet weak var contentLable: UILabel!
    
    @IBAction func callAction(_ sender: Any) {
    }
    
    @IBAction func adAction(_ sender: Any) {
    }
    
    func refresh(){
        if let _ = store.tel{
            phoneButton.isEnabled = true
        }
        if let _ = store.ad_tag{
            adButton.isEnabled = true
        }
        contentLable.text = store.store_desc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigation.backDelegate = self
        sliderCollectionView.dataSource = self
        sliderCollectionView.delegate = self
        
        sliderCollectionView.register(UINib(nibName: "SliderImageCollectionViewCell", bundle:nil), forCellWithReuseIdentifier: "Cell")
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        phoneButton.isEnabled = false
        adButton.isEnabled = false
        getDetail(id: store.id!)
        titleLable.text = store.store_name
        addrLable.text = store.store_addr
        timeLable.text = store.open_hours
        
        phoneButton.setTitle("電話 \(store.tel ?? "")", for: .normal)
        
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

extension StoreDetailViewController:UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate{
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let cell = sliderCollectionView.visibleCells[0]
        let index = sliderCollectionView.indexPath(for: cell)?.item
        
        countLable.text = "\(index! + 1)/\(collectionView(sliderCollectionView, numberOfItemsInSection: 0))"
        
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout
        collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.bounds.width, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if store.imageArray == nil{
            return 0
        }
        return (store.imageArray?.count)!
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! SliderImageCollectionViewCell
        ImageUtils.loadImage(imageView: cell.imageView, name: store.imageArray![indexPath.item], completionHandler: { (url, image) in
            
        })
        
        return cell
    }
    
    func getDetail(id:String){
        WebConfig.Manager.request("\(WebConfig.webUrl)storedesc", method: .post, parameters: ["id":id], encoding: URLEncoding.default, headers: WebConfig.headers).response { response in
            if let data = response.data {
                let json: JSON = JSON(data: data)
                print(json)
                
                if let error = json["error"].bool{
                    if error{
                        return
                    }
                }
                
                if let data = json["data"].array{
                    for stores in data{
                        
                        
                        if let img = stores["imageArray"].array{
                            if self.store.imageArray == nil{
                                self.store.imageArray = [String]()
                            }
                            for imgHere in img{
                                if let imgString = imgHere["img"].string{
                                    if imgString != ""{
                                        self.store.imageArray?.append(imgString)
                                    }
                                }
                            }
                        }
                        
                        if let created_at = stores["created_at"].string{
                            self.store.created_at = created_at
                        }
                        if let store_desc = stores["store_desc"].string{
                            self.store.store_desc = store_desc
                        }
                        if let ad_tag = stores["ad_tag"].string{
                            self.store.ad_tag = ad_tag
                        }
                    }
                    self.refresh()
                    self.sliderCollectionView.reloadData()
                }
                
            }
        }
    }
    
    
    
    
    
}
