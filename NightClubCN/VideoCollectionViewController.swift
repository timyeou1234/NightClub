//
//  VideoCollectionViewController.swift
//  NightClubCN
//
//  Created by YeouTimothy on 2017/7/22.
//  Copyright © 2017年 Wework. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import Alamofire
import SwiftyJSON

class VideoCollectionViewController: UIViewController, IndicatorInfoProvider {
    
    var itemInfo: IndicatorInfo = "平台影音"
    var videoList = [Video]()

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "VideoCollectionTableViewCell", bundle: nil), forCellReuseIdentifier: "Cell")
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 200
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(playended), name: .UIWindowDidBecomeHidden, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(playStarted), name: .UIWindowDidBecomeVisible, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    
    func playStarted(){
        AppUtility.lockOrientation(.landscape)
    }
    
    func playended(){
        
        AppUtility.lockOrientation(.portrait, andRotateTo: .portrait)
        
    }


    // MARK: - IndicatorInfoProvider
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return self.itemInfo
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationController = segue.destination as? VideoDetailViewController{
            destinationController.url = (sender as! Video).video_embed_path
        }
    }
    

}

extension VideoCollectionViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //performSegue(withIdentifier: "detailSegue", sender: videoList[indexPath.row].id)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return videoList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! VideoCollectionTableViewCell
        let video = videoList[indexPath.row]
        cell.video = video
        cell.selectionStyle = .none
        
        return cell
    }
    
}

extension VideoCollectionViewController{
    
    func getData(){
        WebConfig.Manager.request("\(WebConfig.webUrl)videolist", method: .post, parameters: [:], encoding: URLEncoding.default, headers: WebConfig.headers).response { response in
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
                    for video in data{
                        let videoDetail = Video()
                        if let id = video["id"].string{
                            videoDetail.id = id
                        }
                        if let tag = video["tag"].string{
                            videoDetail.tag = tag
                        }
                        if let ad_tag = video["ad_tag"].string{
                            videoDetail.ad_tag = ad_tag
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
                        if let video_embed_path = video["video_embed_path"].string{
                            videoDetail.video_embed_path = video_embed_path
                        }
                        videoList.append(videoDetail)
                    }
                    if self.videoList.count != videoList.count{
                        self.videoList = videoList
                        self.tableView.reloadData()
                    }
                }
            }
        }
        
        
    }
}

struct AppUtility {
    
    // This method will force you to use base on how you configure.
    static func lockOrientation(_ orientation: UIInterfaceOrientationMask) {
        
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            delegate.orientationLock = orientation
        }
    }
    
    // This method done pretty well where we can use this for best user experience.
    static func lockOrientation(_ orientation: UIInterfaceOrientationMask, andRotateTo rotateOrientation:UIInterfaceOrientation) {
        
        self.lockOrientation(orientation)
        
        UIDevice.current.setValue(rotateOrientation.rawValue, forKey: "orientation")
    }
    
}

