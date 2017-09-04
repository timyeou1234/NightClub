//
//  VideoSubStreamCollectionViewCell.swift
//  NightClubCN
//
//  Created by YeouTimothy on 2017/7/28.
//  Copyright © 2017年 Wework. All rights reserved.
//

import UIKit

class VideoSubStreamCollectionViewCell: UICollectionViewCell {

    var video:Video = Video(){
        didSet{
            refresh()
        }
    }
    
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var descLable: UILabel!
    
    func refresh(){
        if video.img != nil{
            ImageUtils.loadImage(imageView: self.mainImageView, name: video.img!, completionHandler: { (url, image) in
                
            })
        }
        descLable.text = video.show_time
    }

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
