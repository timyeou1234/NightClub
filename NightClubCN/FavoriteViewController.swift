//
//  FavoriteViewController.swift
//  NightClubCN
//
//  Created by YeouTimothy on 2017/8/31.
//  Copyright © 2017年 Wework. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class FavoriteViewController: UIViewController, BackDelegate {

    var partyList = [Any]()
    
    @IBOutlet weak var navigation: CustomNavigationView!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "SearchTableViewCell", bundle: nil), forCellReuseIdentifier: "Cell")
        tableView.register(UINib(nibName: "VideoCollectionTableViewCell", bundle: nil), forCellReuseIdentifier: "Cell2")
        
        tableView.estimatedRowHeight = 150
        tableView.rowHeight = UITableViewAutomaticDimension
        
        navigation.backDelegate = self
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getResult()
    }
    
    func back() {
        self.navigationController?.popViewController(animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

extension FavoriteViewController: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if partyList[indexPath.row] is Party{
            if let party = partyList[indexPath.row] as? Party{
                if party.type == "1"{
                    let viewController = storyboard?.instantiateViewController(withIdentifier: "PartyDetailViewController") as! PartyDetailViewController
                    viewController.id = party.id!
                    self.navigationController?.pushViewController(viewController, animated: true)
                }else{
                    let viewController = storyboard?.instantiateViewController(withIdentifier: "PartyNewsDetailViewController") as! PartyNewsDetailViewController
                    viewController.id = party.id!
                    self.navigationController?.pushViewController(viewController, animated: true)
                }
            }else{
                
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return partyList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if partyList[indexPath.row] is Party{
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SearchTableViewCell
            
            cell.party = partyList[indexPath.row] as! Party
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell2", for: indexPath) as! VideoCollectionTableViewCell
        let video = partyList[indexPath.row] as! Video
        cell.video = video
        cell.selectionStyle = .none
        
        return cell

    }
    
    func getResult(){
    
        WebConfig.Manager.request("\(WebConfig.webUrl)favorite_list", method: .post, parameters: ["userid":User.user.id!], encoding: URLEncoding.default, headers: WebConfig.headers).response{ response in
            if let data = response.data {
                let json: JSON = JSON(data: data)
                print(json)
                
                if let error = json["error"].bool{
                    if error{
                        
                        return
                    }
                }
                
                /*
                 type
                 1->最新
                 2->活動訊息
                 3->平台影音
                 */
                
                if let data = json["data"].array{
                    var partyList = [Any]()
                    for party in data{
                        var _type = 0
                        if let type = party["type"].string{
                            /*
                             type
                             1->最新
                             2->活動訊息
                             3->平台影音
                             */
                            _type = Int(type)!
                            
                            switch _type{
                            case 1:
                                if let id = party["id"].string{
                                    if User.user.newsFavorite == nil{
                                        User.user.newsFavorite = [id]
                                    }else{
                                        if !(User.user.newsFavorite?.contains(id))!{
                                            User.user.newsFavorite?.append(id)
                                        }
                                    }
                                }
                            case 2:
                                if let id = party["id"].string{
                                    if User.user.partyFavorite == nil{
                                        User.user.partyFavorite = [id]
                                    }else{
                                        if !(User.user.partyFavorite?.contains(id))!{
                                            User.user.partyFavorite?.append(id)
                                        }
                                    }
                                }
                            case 3:
                                if let id = party["id"].string{
                                    if User.user.videoFavorite == nil{
                                        User.user.videoFavorite = [id]
                                    }else{
                                        if !(User.user.videoFavorite?.contains(id))!{
                                            User.user.videoFavorite?.append(id)
                                        }
                                    }
                                }
                            default:
                                break
                                
                            }

                        }
                        
                        if _type != 3{
                            
                            let partyDetail = Party()
                            if let id = party["id"].string{
                                partyDetail.id = id
                            }
                            
                            
                            if let tag = party["tag"].string{
                                partyDetail.tag = tag.components(separatedBy: ",")
                            }
                            if let ad_tag = party["ad_tag"].string{
                                partyDetail.ad_tag = ad_tag
                            }
                            if let title = party["title"].string{
                                partyDetail.title = title
                            }
                            if let shareinfo = party["shareinfo"].string{
                                partyDetail.shareinfo = shareinfo
                            }
                            if let img = party["img"].string{
                                partyDetail.img = img
                            }
                            if let created_at = party["created_at"].string{
                                partyDetail.created_at = created_at
                            }
                            if let video_embed_path = party["video_embed_path"].string{
                                partyDetail.video_embed_path = video_embed_path
                            }
                            partyList.append(partyDetail)
                        }else{
                            let videoDetail = Video()
                            if let id = party["id"].string{
                                videoDetail.id = id
                            }
                            if let tag = party["tag"].string{
                                videoDetail.tag = tag
                            }
                            if let ad_tag = party["ad_tag"].string{
                                videoDetail.ad_tag = ad_tag
                            }
                            if let title = party["title"].string{
                                videoDetail.title = title
                            }
                            if let shareinfo = party["shareinfo"].string{
                                videoDetail.shareinfo = shareinfo
                            }
                            if let img = party["img"].string{
                                videoDetail.img = img
                            }
                            if let created_at = party["created_at"].string{
                                videoDetail.created_at = created_at
                            }
                            if let video_embed_path = party["video_embed_path"].string{
                                videoDetail.video_embed_path = video_embed_path
                            }
                            partyList.append(videoDetail)
                        }
                    }
                    
                    self.partyList = partyList
                    self.tableView.reloadData()
                    
                }
            }
        }
    }

    
}
