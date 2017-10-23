//
//  StarViewController.swift
//  NightClubCN
//
//  Created by YeouTimothy on 2017/8/14.
//  Copyright © 2017年 Wework. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class StarViewController: UIViewController, BackDelegate{
    
    var starList = [Star]()

    @IBOutlet weak var navigationBar: CustomNavigationView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationBar.backDelegate = self
        
        collectionView.register(UINib(nibName: "StarCollectionViewCell", bundle:nil), forCellWithReuseIdentifier: "Cell")
        collectionView.delegate = self
        collectionView.dataSource = self
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        starList = [Star]()
        getDetail(id: "")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func back() {
        self.navigationController?.popViewController(animated: false)
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if let destinationViewController = segue.destination as? StarDetailViewController{
            destinationViewController.star = sender as! Star
        }
    }
    
}

extension StarViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "showDetail", sender: starList[indexPath.item])
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
        return CGSize(width: self.view.bounds.width/3 - 10, height: self.view.bounds.width/3 + 30)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return starList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! StarCollectionViewCell
        cell.star = starList[indexPath.item]
        
        return cell
    }
    
    func getDetail(id:String){
        WebConfig.Manager.request("\(WebConfig.webUrl)artistlist", method: .post, parameters: [:], encoding: URLEncoding.default, headers: WebConfig.headers).response { response in
            if let data = response.data {
                let json: JSON = JSON(data: data)
                print(json)
                
                if let error = json["error"].bool{
                    if error{
                        return
                    }
                }
                
                if let data = json["data"].array{
                    for stars in data{
                        let star = Star()
                        
                        if let id = stars["id"].string{
                            star.id = id
                        }
                        
                        if let artist_name = stars["artist_name"].string{
                            star.artist_name = artist_name
                        }
                        
                        if let face_img = stars["face_img"].string{
                            star.face_img = face_img
                        }
                        
                        if let wb_link = stars["wb_link"].string{
                            star.wb_link = wb_link
                        }
                        self.starList.append(star)
                    }
                }
                
                self.collectionView.reloadData()
            }
            
        }
    }
    
    
    
}


class Star{
    
    var id:String?
    var artist_name:String?
    var face_img:String?
    var wb_link:String?
    var created_at:String?
    var icon_link1:String?
    var icon_link2:String?
    var icon_link3:String?
    
    var artist_desc:String?
    var imageArray:[String]?
    var videoimage:[String]?
    var videolink:[String]?
    
}
