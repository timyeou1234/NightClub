//
//  StoreTableViewCell.swift
//  NightClubCN
//
//  Created by YeouTimothy on 2017/8/16.
//  Copyright © 2017年 Wework. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class StoreTableViewCell: UITableViewCell {

    var sourceViewController: UIViewController = UIViewController()
    
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
    @IBOutlet weak var tagButton: UIButton!
    
    @IBAction func callAction(_ sender: Any) {
        guard let number = URL(string: "tel://" + (store.tel ?? "")) else { return }
        UIApplication.shared.openURL(number)
    }
    
    @IBAction func adAction(_ sender: Any) {
        if let url = store.ad_tag{
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
    
    @IBAction func favoriteAction(_ sender: Any) {
        let param:Parameters = [
            "userid":User.user.id!,
            "article_id":Int(store.id!) ?? 0,
            "type":4
        ]
        
        WebConfig.Manager.request("\(WebConfig.webUrl)favorite_add", method: .post, parameters: param, encoding: URLEncoding.default, headers: WebConfig.headers).response { response in
            if let data = response.data {
                let json: JSON = JSON(data: data)
                print(json)
                
                if let error = json["error"].bool{
                    if !error{
                        
                    }else{
                        
                    }
                }
                
            }
        }
    }
    @IBAction func shareAction(_ sender: Any) {
        let text = store.store_name
        
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
        tagButton.setImage(#imageLiteral(resourceName: "X297_Bookmark_Normal-1"), for: .selected)
        tagButton.setImage(#imageLiteral(resourceName: "X297_Bookmark_Normal"), for: .normal)
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
