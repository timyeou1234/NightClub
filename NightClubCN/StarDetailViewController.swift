//
//  self.starViewController.swift
//  NightClubCN
//
//  Created by YeouTimothy on 2017/8/14.
//  Copyright © 2017年 Wework. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class StarDetailViewController: UIViewController, BackDelegate{
    
    var id = ""
    var star = Star()
    
    @IBOutlet weak var navigation: CustomNavigationView!
    @IBOutlet weak var sliderCountLable: UILabel!
    @IBOutlet weak var titleLable: UILabel!
    @IBOutlet weak var subTitleLable: UILabel!
    @IBOutlet weak var contentLable: UILabel!
    @IBOutlet weak var sliderCollectionView: UICollectionView!
    @IBOutlet weak var videoCollectionView: UICollectionView!
    
    func refresh(){
        sliderCountLable.text = "1/\(star.imageArray?.count ?? 1)"
        
        titleLable.text = star.artist_name
        contentLable.text = star.artist_desc
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigation.backDelegate = self
        sliderCollectionView.dataSource = self
        sliderCollectionView.delegate = self
        
        sliderCollectionView.register(UINib(nibName: "SliderImageCollectionViewCell", bundle:nil), forCellWithReuseIdentifier: "Cell")
        videoCollectionView.register(UINib(nibName: "SliderImageCollectionViewCell", bundle:nil), forCellWithReuseIdentifier: "Cell")
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getDetail(id: star.id!)
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

extension StarDetailViewController:UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate{
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let cell = sliderCollectionView.visibleCells[0]
        let index = sliderCollectionView.indexPath(for: cell)?.item
        
        sliderCountLable.text = "\(index! + 1)/\(collectionView(sliderCollectionView, numberOfItemsInSection: 0))"
        
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
        if collectionView == sliderCollectionView{
            if star.imageArray == nil{
                return 0
            }
            return (star.imageArray?.count)!
        }
        if star.videoimage == nil{
            return 0
        }
        return (star.videoimage?.count)!
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == sliderCollectionView{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! SliderImageCollectionViewCell
            ImageUtils.loadImage(imageView: cell.imageView, name: star.imageArray![indexPath.item], completionHandler: { (url, image) in
                
            })
            
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! StarVideoCollectionViewCell
            
            cell.titleLable.text = "影片\(indexPath.item)"
            cell.star = star
            cell.index = indexPath.item
            cell.refresh()
            return cell
        }
    }
    
    func getDetail(id:String){
        WebConfig.Manager.request("\(WebConfig.webUrl)artistdesc", method: .post, parameters: ["id":id], encoding: URLEncoding.default, headers: WebConfig.headers).response { response in
            if let data = response.data {
                let json: JSON = JSON(data: data)
                print(json)
                
                if let error = json["error"].bool{
                    if error{
                        return
                    }
                }
                
                if let data = json["data"].array{
                    for star in data{
                        
                        
                        if let img = star["imageArray"].array{
                            if self.star.imageArray == nil{
                                self.star.imageArray = [String]()
                            }
                            for imgHere in img{
                                if let imgString = imgHere["img"].string{
                                    if imgString != ""{
                                        self.star.imageArray?.append(imgString)
                                    }
                                }
                            }
                        }
                        if let videoimg = star["videoimg"].array{
                            if self.star.videoimage == nil{
                                self.star.videoimage = [String]()
                            }
                            for imgHere in videoimg{
                                if let imgString = imgHere["img"].string{
                                    if imgString != ""{
                                        self.star.videoimage?.append(imgString)
                                    }
                                }
                            }
                        }
                        if let videolink = star["videolink"].array{
                            if self.star.videolink == nil{
                                self.star.videolink = [String]()
                            }
                            for imgHere in videolink{
                                if let imgString = imgHere["img"].string{
                                    if imgString != ""{
                                        self.star.videolink?.append(imgString)
                                    }
                                }
                            }
                        }
                        if let created_at = star["created_at"].string{
                            self.star.created_at = created_at
                        }
                        if let artist_desc = star["artist_desc"].string{
                            self.star.artist_desc = artist_desc
                        }
                    }
                    self.refresh()
                    self.sliderCollectionView.reloadData()
                }
                
            }
        }
    }
    
    
    
}


