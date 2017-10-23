//
//  PartyMainViewController.swift
//  NightClubCN
//
//  Created by YeouTimothy on 2017/7/3.
//  Copyright © 2017年 Wework. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import Alamofire
import SwiftyJSON

class PartyMainViewController: UIViewController, BackDelegate {

    @IBOutlet weak var navigetionView: CustomNavigationView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigetionView.backDelegate = self
        if User.user.id != nil{
            getFavorite()
        }
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        
    }
    
    func back() {
        
    }
    
    func search() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "SearchViewController") as! SearchViewController
        present(vc, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    func getFavorite(){
        WebConfig.Manager.request("\(WebConfig.webUrl)favorite_list", method: .post, parameters: ["userid":User.user.id!], encoding: URLEncoding.default, headers: WebConfig.headers).response { response in
            if let data = response.data {
                let json: JSON = JSON(data: data)
                print(json)
                
                if let error = json["error"].bool{
                    if error{
                        return
                    }
                }
                
                if let data = json["data"].array{
                    for favorite in data{
                        if let type = favorite["type"].string{
                            switch Int(type)!{
                            case 1:
                                if let id = favorite["id"].string{
                                    if User.user.newsFavorite == nil{
                                        User.user.newsFavorite = [id]
                                    }else{
                                        User.user.newsFavorite?.append(id)
                                    }
                                }
                            case 2:
                                if let id = favorite["id"].string{
                                    if User.user.partyFavorite == nil{
                                        User.user.partyFavorite = [id]
                                    }else{
                                        User.user.partyFavorite?.append(id)
                                    }
                                }
                            case 3:
                                if let id = favorite["id"].string{
                                    if User.user.videoFavorite == nil{
                                        User.user.videoFavorite = [id]
                                    }else{
                                        User.user.videoFavorite?.append(id)
                                    }
                                }
                            default:
                                break
                            
                            }
                            
                        }
                
                    }
                }
                
            }
        }
    

    }
}


