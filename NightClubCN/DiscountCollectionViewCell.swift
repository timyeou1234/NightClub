//
//  DiscountCollectionViewCell.swift
//  NightClubCN
//
//  Created by YeouTimothy on 2017/8/14.
//  Copyright © 2017年 Wework. All rights reserved.
//

import UIKit

class DiscountCollectionViewCell: UICollectionViewCell {

    var discount:Discount = Discount(){
        didSet{
            refresh()
        }
    }
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLable: UILabel!
    
    func refresh(){
        
        ImageUtils.loadImage(imageView: self.imageView, name: discount.image!, completionHandler: { (url, image) in
            
        })
        titleLable.text = discount.title
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
