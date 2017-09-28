//
//  PartyTableViewCell.swift
//  NightClubCN
//
//  Created by YeouTimothy on 2017/7/3.
//  Copyright © 2017年 Wework. All rights reserved.
//

import UIKit


class PartyTableViewCell: UITableViewCell {
    
    var sourceViewController: UIViewController = UIViewController()
    
    var party:Party = Party(){
        didSet{
            refresh()
        }
    }
    
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var tagList: TagListView!
    @IBOutlet weak var titleLable: UILabel!
    @IBOutlet weak var adButton: UIButton!
    @IBAction func adAction(_ sender: Any) {
        if let url = party.ad_link{
            guard let url = URL(string: url) else {
                return //be safe
            }
            
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    @IBAction func shareAction(_ sender: Any) {
        // text to share
        let text = party.shareinfo
        
        // set up activity view controller
        let textToShare = [ text ]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = sourceViewController.view // so that iPads won't crash
        
        // exclude some activity types from the list (optional)
        activityViewController.excludedActivityTypes = [ UIActivityType.airDrop, UIActivityType.postToFacebook ]
        
        // present the view controller
        sourceViewController.present(activityViewController, animated: true, completion: nil)
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
