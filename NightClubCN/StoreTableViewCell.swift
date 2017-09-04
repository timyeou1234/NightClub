//
//  StoreTableViewCell.swift
//  NightClubCN
//
//  Created by YeouTimothy on 2017/8/16.
//  Copyright © 2017年 Wework. All rights reserved.
//

import UIKit

class StoreTableViewCell: UITableViewCell {

    var store:Store = Store(){
        didSet{
            refresh()
        }
    }
    
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var titleLable: UILabel!
    @IBOutlet weak var addrlable: UILabel!
    @IBOutlet weak var timeLable: UILabel!
    @IBOutlet weak var phoneButton: UIButton!
    @IBOutlet weak var adButton: UIButton!
    
    @IBAction func callAction(_ sender: Any) {
        
    }
    
    func refresh(){
        if store.list_img != nil{
            ImageUtils.loadImage(imageView: mainImageView, name: store.list_img!, completionHandler:{ (url, image) in
                
            })
        }
        titleLable.text = store.store_name
        addrlable.text = store.store_addr
        timeLable.text = store.open_hours
        phoneButton.setTitle("電話 \(store.tel ?? "")", for: .normal)
        if store.list_ad_tag != nil{
            adButton.isHidden = true
            adButton.setTitle(store.list_ad_tag , for: .normal)
        }else{
            adButton.isHidden = false
        }
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
