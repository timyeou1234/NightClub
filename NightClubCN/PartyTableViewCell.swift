//
//  PartyTableViewCell.swift
//  NightClubCN
//
//  Created by YeouTimothy on 2017/7/3.
//  Copyright © 2017年 Wework. All rights reserved.
//

import UIKit


class PartyTableViewCell: UITableViewCell {

    var party:Party = Party(){
        didSet{
            refresh()
        }
    }
    
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var tagList: TagListView!
    @IBOutlet weak var titleLable: UILabel!
    @IBOutlet weak var adButton: UIButton!
    @IBAction func shareAction(_ sender: Any) {
        
    }
    
    func refresh(){
        
        ImageUtils.loadImage(imageView: self.mainImageView, name: party.img!, completionHandler: { (url, image) in
           
        })
        mainImageView.contentMode = .scaleAspectFit
        self.backgroundView?.layoutIfNeeded()
        self.mainImageView.layoutIfNeeded()
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.contentView.layoutIfNeeded()
        tagList.textFont = titleLable.font.withSize(12)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
