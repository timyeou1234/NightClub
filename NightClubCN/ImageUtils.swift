//
//  Image.swift
//  NightClubCN
//
//  Created by YeouTimothy on 2017/7/7.
//  Copyright © 2017年 Wework. All rights reserved.
//

import UIKit
import Kingfisher

class ImageUtils
{
    static let placeholder = UIImage(named: "thumbnail_460x460")
    static func loadImage (imageView: UIImageView, name: String, completionHandler: @escaping (_ url : String, _ image : UIImage?) -> Void)
    {
        ImageDownloader.default.trustedHosts = ["128.199.184.200"]
        
        if let nameUrl = name.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed){
            let resource = ImageResource(downloadURL: URL(string: "\(nameUrl)")!)
            imageView.kf.setImage(with: resource, placeholder: placeholder, options: [.transition(ImageTransition.fade(0.35))], progressBlock: nil){
                (image, error, cacheType, imageURL) -> () in
                completionHandler(name, image)
                
            }
        }
    }
}


