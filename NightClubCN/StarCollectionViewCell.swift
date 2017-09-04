//
//  StarCollectionViewCell.swift
//  NightClubCN
//
//  Created by YeouTimothy on 2017/8/14.
//  Copyright © 2017年 Wework. All rights reserved.
//

import UIKit

class StarCollectionViewCell: UICollectionViewCell {
    
    var star:Star = Star(){
        didSet{
            refresh()
        }
    }
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLable: UILabel!
    
    func refresh(){
        if star.face_img != nil{
            ImageUtils.loadImage(imageView: self.imageView, name: star.face_img!, completionHandler: { (url, image) in
                self.imageView.cornerRadiused = self.imageView.bounds.height / 2
            })
        }
        titleLable.text = star.artist_name
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
}
