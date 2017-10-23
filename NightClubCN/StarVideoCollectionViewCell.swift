//
//  StarVideoCollectionViewCell.swift
//  NightClubCN
//
//  Created by YeouTimothy on 2017/8/14.
//  Copyright © 2017年 Wework. All rights reserved.
//

import UIKit

class StarVideoCollectionViewCell: UICollectionViewCell {
    
    var star = Star()
    var index = 0

    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLable: UILabel!
    
    @IBAction func playAction(_ sender: Any) {
        if let urlString = star.videolink?[index]{
            if let _ = URL(string: urlString){
                webView.isHidden = false
                imageView.isHidden = true
            }
        }
    }
    
    func refresh(){
        webView.stopLoading()
        webView.isHidden = true
        if let urlString = star.videolink?[index]{
            if let url = URL(string: urlString){
                webView.loadRequest(URLRequest(url: url))
            }
        }
        
        if star.videoimage?[index] != nil{
            ImageUtils.loadImage(imageView: self.imageView, name: (star.videoimage?[index])!, completionHandler: { (url, image) in
                
            })
        }
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
