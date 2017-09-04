//
//  SearchTableViewCell.swift
//  NightClubCN
//
//  Created by YeouTimothy on 2017/8/22.
//  Copyright © 2017年 Wework. All rights reserved.
//

import UIKit

class SearchTableViewCell: UITableViewCell {

    var party:Party = Party(){
        didSet{
            refresh()
        }
    }
    
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var titleLable: UILabel!
    @IBOutlet weak var adButton: UIButton!
    @IBAction func shareAction(_ sender: Any) {
        
    }
    
    func refresh(){
        
        ImageUtils.loadImage(imageView: self.mainImageView, name: party.img!, completionHandler: { (url, image) in
            
        })
        self.titleLable.text = party.title
        adButton.setTitle(party.ad_tag, for: .normal)
        mainImageView.contentMode = .scaleAspectFit
        self.backgroundView?.layoutIfNeeded()
        self.mainImageView.layoutIfNeeded()
        
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
