//
//  VideoStreamViewController.swift
//  NightClubCN
//
//  Created by YeouTimothy on 2017/7/22.
//  Copyright © 2017年 Wework. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import Alamofire
import SwiftyJSON

class VideoStreamViewController: UIViewController, IndicatorInfoProvider {
    
    var itemInfo: IndicatorInfo = "直播"
    var videoList = [Video]()
    var videoList2 = [Video]()
    
    
    @IBOutlet weak var mainCollectionView: UICollectionView!
    @IBOutlet weak var subCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainCollectionView.delegate = self
        mainCollectionView.dataSource = self
        mainCollectionView.register(UINib(nibName: "VideoStreamCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "Cell")
        subCollectionView.delegate = self
        subCollectionView.dataSource = self
        subCollectionView.register(UINib(nibName: "VideoSubStreamCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "Cell")
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getDataMain()
    }
    
    // MARK: - IndicatorInfoProvider
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return self.itemInfo
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationController = segue.destination as? VideoStreamDetailViewController{
            destinationController.video = (sender as? Video)!
        }
    }
    

}

extension VideoStreamViewController:UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == mainCollectionView{
            self.performSegue(withIdentifier: "showDetail", sender: videoList[indexPath.item])
        }else{
            self.performSegue(withIdentifier: "showDetail", sender: videoList2[indexPath.item])
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == mainCollectionView{
            return CGSize(width: self.view.bounds.width * (270/375), height: mainCollectionView.bounds.height)
        }else{
            return CGSize(width: self.view.bounds.width / 2 - 2.5, height: subCollectionView.bounds.height)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == mainCollectionView{
            return videoList.count
        }else{
            return videoList2.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == mainCollectionView{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! VideoStreamCollectionViewCell
            cell.video = videoList[indexPath.item]
        
            return cell
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! VideoSubStreamCollectionViewCell
        
        cell.video = videoList2[indexPath.item]
        return cell
    }
    
    func getDataMain(){
        WebConfig.Manager.request("\(WebConfig.webUrl)livelist", method: .post, parameters: [:], encoding: URLEncoding.default, headers: WebConfig.headers).response { response in
            if let data = response.data {
                let json: JSON = JSON(data: data)
                print(json)
                
                if let error = json["error"].bool{
                    if error{
                        return
                    }
                }
                
                if let data = json["data"].array{
                    var videoList = [Video]()
                    var videoList2 = [Video]()
                    for video in data{
                        let videoDetail = Video()
                        if let id = video["id"].string{
                            videoDetail.id = id
                        }
                        if let tag = video["tag"].string{
                            videoDetail.tag = tag
                        }
                        if let status_tag = video["status_tag"].string{
                            videoDetail.status_tag = status_tag
                        }
                        if let title = video["title"].string{
                            videoDetail.title = title
                        }
                        if let shareinfo = video["shareinfo"].string{
                            videoDetail.shareinfo = shareinfo
                        }
                        if let img = video["img"].string{
                            videoDetail.img = img
                        }
                        if let created_at = video["created_at"].string{
                            videoDetail.created_at = created_at
                        }
                        if let video_embed_path = video["live_embed_path"].string{
                            videoDetail.video_embed_path = video_embed_path
                        }
                        if let show_time = video["show_time"].string{
                            videoDetail.show_time = show_time
                        }
                        if let position = video["position"].string{
                            if position == "1"{
                                videoList.append(videoDetail)
                            }else{
                                videoList2.append(videoDetail)
                            }
                        }
                        
                    }
                    if self.videoList.count != videoList.count || self.videoList2.count != videoList2.count{
                        self.videoList = videoList
                        self.videoList2 = videoList2
                        self.mainCollectionView.reloadData()
                        self.subCollectionView.reloadData()
                    }
                }
            }
        }
        
        
    }

    
    
}
