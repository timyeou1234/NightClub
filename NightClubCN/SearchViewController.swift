//
//  SearchViewController.swift
//  NightClubCN
//
//  Created by YeouTimothy on 2017/8/22.
//  Copyright © 2017年 Wework. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class SearchViewController: UIViewController {
    
    var keywordList = [String]()
    var partyList = [Any]()
    var buttonList = [UIButton]()
    
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var resultTableView: UITableView!
    
    @IBOutlet weak var keywordButton1: UIButton!
    @IBOutlet weak var keywordButton2: UIButton!
    @IBOutlet weak var keywordButton3: UIButton!
    @IBOutlet weak var keywordButton4: UIButton!
    @IBOutlet weak var keywordButton5: UIButton!
    @IBOutlet weak var keywordButton6: UIButton!
    @IBOutlet weak var keywordButton7: UIButton!
    @IBOutlet weak var keywordButton8: UIButton!
    @IBOutlet weak var keywordButton9: UIButton!
    @IBOutlet weak var keywordButton10: UIButton!
    
    @IBAction func cancelAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchTextField.delegate = self
        resultTableView.delegate = self
        resultTableView.dataSource = self
        resultTableView.register(UINib(nibName: "SearchTableViewCell", bundle: nil), forCellReuseIdentifier: "Cell")
        resultTableView.register(UINib(nibName: "VideoCollectionTableViewCell", bundle: nil), forCellReuseIdentifier: "Cell2")
        
        resultTableView.estimatedRowHeight = 150
        resultTableView.rowHeight = UITableViewAutomaticDimension
        
        buttonList = [keywordButton1, keywordButton2, keywordButton3, keywordButton4, keywordButton5, keywordButton6, keywordButton7, keywordButton8, keywordButton9, keywordButton10]
        
        for button in buttonList{
            button.setTitle("", for: .normal)
            button.addTarget(self, action: #selector(SearchViewController.keywordSearch(sender:)), for: .touchUpInside)
        }
        // Do any additional setup after loading the view.
    }
    
    func keywordSearch(sender:UIButton){
        if let keyword = sender.titleLabel?.text{
            getResult(keyword: keyword)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        resultTableView.isHidden = true
        getKeywordList()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func reFresh(){
        resultTableView.isHidden = false
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

extension SearchViewController:UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.text != ""{
            if let key = textField.text{
                getResult(keyword:key)
            }
        }
        self.view.endEditing(true)
        return true
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if partyList[indexPath.row] is Party{
            if let party = partyList[indexPath.row] as? Party{
                if party.type == "1"{
                    let viewController = storyboard?.instantiateViewController(withIdentifier: "PartyDetailViewController") as! PartyDetailViewController
                    viewController.id = party.id!
                    self.navigationController?.pushViewController(viewController, animated: true)
                }else{
                    let viewController = storyboard?.instantiateViewController(withIdentifier: "PartyNewsDetailViewController") as! PartyNewsDetailViewController
                    viewController.id = party.id!
                    self.navigationController?.pushViewController(viewController, animated: true)
                }
            }else{
                
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return partyList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if partyList[indexPath.row] is Party{
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SearchTableViewCell
        
            cell.party = partyList[indexPath.row] as! Party
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell2", for: indexPath) as! VideoCollectionTableViewCell
        let video = partyList[indexPath.row] as! Video
        cell.video = video
        cell.selectionStyle = .none
        
        return cell
    }
    
    func getResult(keyword:String){
        addKeyword(keyword: keyword)
        WebConfig.Manager.request("\(WebConfig.webUrl)search_result", method: .post, parameters: ["keywords":keyword], encoding: URLEncoding.default, headers: WebConfig.headers).response { response in
            if let data = response.data {
                let json: JSON = JSON(data: data)
                print(json)
                
                if let error = json["error"].bool{
                    if error{
                        self.showAlert(title: "查無結果", Message: "")
                        return
                    }
                }
                
                /*
                 type
                 1->最新
                 2->活動訊息
                 3->平台影音
                 */
                
                if let data = json["data"].array{
                    var partyList = [Any]()
                    for party in data{
                        var _type = 0
                        if let type = party["type"].string{
                            /*
                             type
                             1->最新
                             2->活動訊息
                             3->平台影音
                             */
                            _type = Int(type)!
                        }
                        
                        if _type != 3{
                            
                            let partyDetail = Party()
                            partyDetail.type = "\(_type)"
                            if let id = party["id"].string{
                                partyDetail.id = id
                            }
                            
                            
                            if let tag = party["tag"].string{
                                partyDetail.tag = tag.components(separatedBy: ",")
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
                            if let video_embed_path = party["video_embed_path"].string{
                                partyDetail.video_embed_path = video_embed_path
                            }
                            partyList.append(partyDetail)
                        }else{
                            let videoDetail = Video()
                            if let id = party["id"].string{
                                videoDetail.id = id
                            }
                            if let tag = party["tag"].string{
                                videoDetail.tag = tag
                            }
                            if let ad_tag = party["ad_tag"].string{
                                videoDetail.ad_tag = ad_tag
                            }
                            if let title = party["title"].string{
                                videoDetail.title = title
                            }
                            if let shareinfo = party["shareinfo"].string{
                                videoDetail.shareinfo = shareinfo
                            }
                            if let img = party["img"].string{
                                videoDetail.img = img
                            }
                            if let created_at = party["created_at"].string{
                                videoDetail.created_at = created_at
                            }
                            if let video_embed_path = party["video_embed_path"].string{
                                videoDetail.video_embed_path = video_embed_path
                            }
                            partyList.append(videoDetail)
                        }
                    }
                    
                    self.partyList = partyList
                    self.resultTableView.reloadData()
                    self.reFresh()
                    
                }
            }
        }
    }
    
    func getKeywordList(){
        
        WebConfig.Manager.request("\(WebConfig.webUrl)search_list", method: .post, parameters: [:], encoding: URLEncoding.default, headers: WebConfig.headers).response { response in
            if let data = response.data {
                let json: JSON = JSON(data: data)
                print(json)
                
                if let error = json["error"].bool{
                    if error{
                        return
                    }
                }
                
                if let data = json["data"].array{
                    print(data)
                    var _keywordList = [String]()
                    
                    for keyword in data{
                        if let key = keyword.string{
                            _keywordList.append(key)
                        }
                    }
                    self.keywordList = _keywordList
                    self.refreshKeyword()
                }
            }
        }
    }
    
    func addKeyword(keyword:String){
        
        WebConfig.Manager.request("\(WebConfig.webUrl)search_add", method: .post, parameters: ["keywords":keyword], encoding: URLEncoding.default, headers: WebConfig.headers).response { response in
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
    
    
    func refreshKeyword(){
        for button in buttonList{
            if buttonList.index(of: button) != nil{
                button.setTitle(keywordList[buttonList.index(of: button)!], for: .normal)
            }
        }
    }
    
    func showAlert(title:String, Message:String?){
        let alert = UIAlertController(title: title, message: Message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "確認", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
}
