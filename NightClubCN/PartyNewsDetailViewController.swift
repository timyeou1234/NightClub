//
//  PartyNewsDetailViewController.swift
//  NightClubCN
//
//  Created by YeouTimothy on 2017/7/11.
//  Copyright © 2017年 Wework. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class PartyNewsDetailViewController: UIViewController, BackDelegate{
    
    var id = ""
    var party = Party()
    
    @IBOutlet weak var navigation: CustomNavigationView!
    
    @IBOutlet weak var sliderCountLable: UILabel!
    @IBOutlet weak var mainImagView: UIImageView!
    @IBOutlet weak var tagList: TagListView!
    @IBOutlet weak var titleLable: UILabel!
    @IBOutlet weak var adButton: UIButton!
    @IBOutlet weak var contentLable: UILabel!
    @IBOutlet weak var adImage: UIImageView!
    @IBOutlet weak var sliderCollectionView: UICollectionView!
    
    func refresh(){
        ImageUtils.loadImage(imageView: self.adImage, name: party.img_ad!, completionHandler: { (url, image) in
            
        })
        sliderCountLable.text = "1/\(party.imgSlider?.count ?? 1)"
        tagList.removeAllTags()
        tagList.addTags(party.tag!)
        tagList.addTagsWithAttribute(party.location_tag!)
        adButton.setTitle(party.ad_tag, for: .normal)
        titleLable.text = party.title
        contentLable.text = party.content
        
    }
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigation.backDelegate = self
        
        sliderCollectionView.dataSource = self
        sliderCollectionView.delegate = self
        
        sliderCollectionView.register(UINib(nibName: "SliderImageCollectionViewCell", bundle:nil), forCellWithReuseIdentifier: "Cell")
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if User.user.id != nil{
            if let party = User.user.newsFavorite{
                if party.contains(id){
                    navigation.bookMarkButton.isSelected = true
                }else{
                    navigation.bookMarkButton.isSelected = false
                }
            }
        }
        sliderCountLable.text = "1/1"
        getDetail(id: id)
    }
    
    func favorite() {
        if User.user.id == nil{
            return
        }
        if navigation.bookMarkButton.state == .selected{
            
            User.user.newsFavorite?.remove(at: (User.user.newsFavorite?.index(of: id))!)
            navigation.bookMarkButton.isSelected = false
        }else{
            addFavorite()
            User.user.newsFavorite?.append(id)
            navigation.bookMarkButton.isSelected = true
        }
    }
    
    func addFavorite(){
        let param: Parameters = [
            "userid":User.user.id!,
            "article_id":Int(id) ?? 0,
            "type":2
        ]
        WebConfig.Manager.request("\(WebConfig.webUrl)favorite_add", method: .post, parameters: param, encoding: URLEncoding.default, headers: WebConfig.headers).response { response in
            if let data = response.data {
                let json: JSON = JSON(data: data)
                print(json)
                
                if let error = json["error"].bool{
                    if error{
                        return
                    }
                }
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func share(){
        if let share = party.shareinfo{
            let myWebsite = NSURL(string: share)
            
            guard let url = myWebsite else {
                print("nothing found")
                return
            }
            
            let shareItems:Array = [url]
            let activityViewController:UIActivityViewController = UIActivityViewController(activityItems: shareItems, applicationActivities: nil)
            activityViewController.excludedActivityTypes = [UIActivityType.print, UIActivityType.postToWeibo, UIActivityType.copyToPasteboard, UIActivityType.addToReadingList, UIActivityType.postToVimeo]
            activityViewController.popoverPresentationController?.sourceView = self.view
            self.present(activityViewController, animated: true, completion: nil)
        }
    }
    
    func back() {
        self.dismiss(animated: false, completion: nil)
    }
    
    func search() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "SearchViewController") as! SearchViewController
        present(vc, animated: true, completion: nil)
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

extension PartyNewsDetailViewController:UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate{
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let cell = sliderCollectionView.visibleCells[0]
        let index = sliderCollectionView.indexPath(for: cell)?.item
        
        sliderCountLable.text = "\(index! + 1)/\(collectionView(sliderCollectionView, numberOfItemsInSection: 0))"
        
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout
        collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 0
    }
    
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.bounds.width, height: collectionView.bounds.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if party.imgSlider == nil{
            return 0
        }
        return (party.imgSlider?.count)!
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! SliderImageCollectionViewCell
        ImageUtils.loadImage(imageView: cell.imageView, name: party.imgSlider![indexPath.item], completionHandler: { (url, image) in
            
        })
        
        return cell
    }
    
    func getDetail(id:String){
        WebConfig.Manager.request("\(WebConfig.webUrl)actiondesc", method: .post, parameters: ["id":id], encoding: URLEncoding.default, headers: WebConfig.headers).response { response in
            if let data = response.data {
                let json: JSON = JSON(data: data)
                print(json)
                
                if let error = json["error"].bool{
                    if error{
                        return
                    }
                }
                
                if let data = json["data"].array{
                    for party in data{
                        let partyDetail = Party()
                        if let id = party["id"].string{
                            partyDetail.id = id
                        }
                        if let tag = party["tag"].string{
                            partyDetail.tag = tag.components(separatedBy: ",")
                        }
                        if let location_tag = party["location_tag"].string{
                            var locationList = [String]()
                            for location in location_tag.components(separatedBy: ","){
                                locationList.append(location)
                            }
                            partyDetail.location_tag = locationList
                        }
                        if let ad_tag = party["ad_tag"].string{
                            partyDetail.ad_tag = ad_tag
                        }
                        if let title = party["title"].string{
                            partyDetail.title = title
                        }
                        if let shareinfo = party["shareinfo"].string{
                            partyDetail.shareinfo = shareinfo
                        }
                        if let img = party["imageArray"].array{
                            if partyDetail.imgSlider == nil{
                                partyDetail.imgSlider = [String]()
                            }
                            for imgHere in img{
                                if let imgString = imgHere["img"].string{
                                    if imgString != ""{
                                        partyDetail.imgSlider?.append(imgString)
                                    }
                                }
                            }
                        }
                        if let created_at = party["created_at"].string{
                            partyDetail.created_at = created_at
                        }
                        if let content = party["content"].string{
                            partyDetail.content = content
                        }
                        if let content_tag = party["content_tag"].string{
                            partyDetail.content_tag = content_tag.components(separatedBy: ",")
                        }
                        if let img_ad = party["img_ad"].string{
                            partyDetail.img_ad = img_ad
                        }
                        if let ad_link = party["ad_link"].string{
                            partyDetail.ad_link = ad_link
                        }
                        if let source = party["source"].string{
                            partyDetail.source = source
                        }
                        self.party = partyDetail
                    }
                    self.refresh()
                    self.sliderCollectionView.reloadData()
                }
                
            }
        }
    }
    
}
