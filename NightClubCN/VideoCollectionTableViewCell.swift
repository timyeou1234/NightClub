//
//  VideoCollectionTableViewCell.swift
//  NightClubCN
//
//  Created by YeouTimothy on 2017/7/22.
//  Copyright © 2017年 Wework. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class VideoCollectionTableViewCell: UITableViewCell {
    
    var video:Video = Video(){
        didSet{
            refresh()
        }
    }
    
    
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var tagList: TagListView!
    @IBOutlet weak var titleLable: UILabel!
    @IBOutlet weak var adButton: UIButton!
    
    @IBOutlet weak var tagButton: UIButton!
    @IBAction func tagAction(_ sender: Any) {
        if User.user.id != nil{
            if tagButton.isSelected{
                tagButton.isSelected = false
            }else{
                addFavorite()
                tagButton.isSelected = true
            }
        }
    }
    
    func addFavorite(){
        
        let param:Parameters = [
            "userid":User.user.id!,
            "article_id":Int(video.id!) ?? 0,
            "type":1
        ]
        
        WebConfig.Manager.request("\(WebConfig.webUrl)favorite_add", method: .post, parameters: param, encoding: URLEncoding.default, headers: WebConfig.headers).response { response in
            if let data = response.data {
                let json: JSON = JSON(data: data)
                print(json)
                
                if let error = json["error"].bool{
                    if !error{
                        
                    }else{
                        
                    }
                }
                
            }
        }
    }

    
    @IBAction func shareAction(_ sender: Any) {
        
    }
    
    @IBAction func playAction(_ sender: Any) {
        if let urlString = video.video_embed_path{
            if let _ = URL(string: urlString){
                webView.isHidden = false
            }
        }
    }
    
    func refresh(){
        tagButton.setImage(#imageLiteral(resourceName: "X297_Bookmark_Active"), for: .selected)
        tagButton.setImage(#imageLiteral(resourceName: "X297_Bookmark_Normal"), for: .normal)
        if User.user.id == nil{
            
        }else{
            if let videos = User.user.videoFavorite{
                if videos.contains(video.id!){
                    tagButton.isSelected = true
                }else{
                    tagButton.isSelected = false
                }
            }
        }
        
        webView.stopLoading()
        webView.isHidden = true
        if let urlString = video.video_embed_path{
            if let url = URL(string: urlString){
                webView.loadRequest(URLRequest(url: url))
            }
        }
        if video.img != nil{
            ImageUtils.loadImage(imageView: self.mainImageView, name: video.img!, completionHandler: { (url, image) in
                
            })
        }
        tagList.removeAllTags()
        if video.tag != nil{
            tagList.addTags([video.tag!])
        }
        titleLable.text = video.title
        adButton.setTitle(video.ad_tag, for: .normal)
        
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
}
