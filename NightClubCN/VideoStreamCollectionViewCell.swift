//
//  VideoStreamCollectionViewCell.swift
//  NightClubCN
//
//  Created by YeouTimothy on 2017/7/28.
//  Copyright © 2017年 Wework. All rights reserved.
//

import UIKit

class VideoStreamCollectionViewCell: UICollectionViewCell {
    
    var video:Video = Video(){
        didSet{
            refresh()
        }
    }
    
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var liveImageView: UIImageView!
    @IBOutlet weak var comingSoonImageView: UIImageView!
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var titleLable: UILabel!
    @IBOutlet weak var descLable: UILabel!
    
    
    func refresh(){
        webView.stopLoading()
        webView.isHidden = true
        comingSoonImageView.isHidden = true
        liveImageView.isHidden = true
//        if let urlString = video.video_embed_path{
//            if let url = URL(string: urlString){
//                webView.loadRequest(URLRequest(url: url))
//            }
//        }
        if video.img != nil{
            ImageUtils.loadImage(imageView: self.mainImageView, name: video.img!, completionHandler: { (url, image) in
                
            })
        }
        titleLable.text = video.title
        if video.status_tag != nil{
            if video.status_tag == "即將播出"{
                comingSoonImageView.isHidden = false
            }else{
                liveImageView.isHidden = false
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
}
