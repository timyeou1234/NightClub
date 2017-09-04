//
//  PartyNewsViewController.swift
//  NightClubCN
//
//  Created by YeouTimothy on 2017/7/3.
//  Copyright © 2017年 Wework. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import Alamofire
import SwiftyJSON
import SDWebImage

class PartyNewsViewController: UIViewController, IndicatorInfoProvider{

    var itemInfo: IndicatorInfo = "活動訊息"
    var partyList = [Party]()
    var isLoaded = false
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var stickyView: UIView!
    @IBOutlet weak var tagList: TagListView!
    @IBOutlet weak var titleLable: UILabel!
    @IBOutlet weak var adButton: UIButton!
    
    @IBAction func cell1Action(_ sender: Any) {
        performSegue(withIdentifier: "detailSegue", sender: partyList[0].id)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "PartyTableViewCell", bundle: nil), forCellReuseIdentifier: "Cell")
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 200
       
    }
    
    override func viewDidAppear(_ animated: Bool) {
        isLoaded = false
        stickyView.isHidden = true
        getData()
    }
    
    func reFresh(){
        isLoaded = true
        if partyList.count > 0{
            let party = partyList[0]
            if party.tag != nil{
                tagList.removeAllTags()
                tagList.addTags(party.tag!)
            }
            if party.location_tag != nil{
                tagList.addTagsWithAttribute(party.location_tag!)
            }
            adButton.setTitle(party.ad_tag, for: .normal)
            titleLable.text = party.title
        }
    }
    
    // MARK: - IndicatorInfoProvider
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return self.itemInfo
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if let destinationController = segue.destination as? PartyNewsDetailViewController{
            destinationController.id = sender as! String
        }
    }
 

}

extension PartyNewsViewController: UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate{
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if !isLoaded{
            return
        }
        if scrollView.contentOffset.y + 10 >= self.view.bounds.width * (229/375){
            stickyView.isHidden = false
        }else{
            stickyView.isHidden = true
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "detailSegue", sender: partyList[indexPath.row].id)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return partyList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! PartyTableViewCell
        let party = partyList[indexPath.row]
        cell.party = party
        cell.titleLable.text = party.title
        cell.tagList.removeAllTags()
        cell.tagList.addTags(party.tag!)
        cell.tagList.addTagsWithAttribute(party.location_tag!)
        cell.adButton.setTitle(party.ad_tag, for: .normal)
        cell.selectionStyle = .none
        
        return cell
    }
    
}

extension PartyNewsViewController{
    
    func getData(){
        WebConfig.Manager.request("\(WebConfig.webUrl)actionlist", method: .post, parameters: [:], encoding: URLEncoding.default, headers: WebConfig.headers).response { response in
            if let data = response.data {
                let json: JSON = JSON(data: data)
                print(json)
                
                if let error = json["error"].bool{
                    if error{
                        return
                    }
                }
                
                if let data = json["data"].array{
                    var partyList = [Party]()
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
                        if let img = party["img"].string{
                            partyDetail.img = img
                        }
                        if let created_at = party["created_at"].string{
                            partyDetail.created_at = created_at
                        }
                        partyList.append(partyDetail)
                    }
                    if self.partyList.count != partyList.count{
                        self.partyList = partyList
                        self.tableView.reloadData()
                        self.reFresh()
                    }else{
                        self.isLoaded = true
                    }
                }
            }
        }
        
        
    }
    
    
}

