//
//  WelcomeViewController.swift
//  NightClubCN
//
//  Created by YeouTimothy on 2017/6/29.
//  Copyright © 2017年 Wework. All rights reserved.
//

protocol LoginDelegate {
    func loginSuccess(platform:Int, userid:String, accesstoken:String, remind_in:String, expires_in:String)
    func loginFail()
}


import UIKit
import WechatKit
import SwiftyJSON
import Alamofire

class LoginViewController: UIViewController, LoginDelegate {
    
    
    @IBAction func weiboLoginAction(_ sender: Any) {
        let request = WBAuthorizeRequest.request() as? WBAuthorizeRequest
        request?.redirectURI = "http://128.199.184.200"
        request?.scope = "all"
        
        WeiboSDK.send(request)
    }

    @IBAction func wechatLoginAction(_ sender: Any) {
        self.performSegue(withIdentifier: "showDetail", sender: nil)
//        WechatManager.shared.isInstalled()
//        WechatManager.shared.checkAuth { result in
//            switch result {
//            case .failure(let errCode)://登录失败
//                print(errCode)
//            case .success(let value)://登录成功 value为([String: String]) 从微信返回的openid access_token 以及 refresh_token
//                print(value)
//            }
//        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.loginDelegate = self
        // Do any additional setup after loading the view.
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        WechatManager.appid = "微信开放平台,注册的应用程序id"
        WechatManager.appSecret = "微信开放平台,注册的应用程序Secret"
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loginSuccess(platform: Int, userid: String, accesstoken: String, remind_in: String, expires_in: String) {
        login(platform: platform, userid: userid, accesstoken: accesstoken, remind_in: "", expires_in: expires_in)
    }
    
    func loginFail() {
        showAlert(title: "登入失敗", Message: "請重試")
    }
    
    func showAlert(title:String, Message:String?){
        let alert = UIAlertController(title: title, message: Message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "確認", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func login(platform: Int, userid: String, accesstoken: String, remind_in: String, expires_in: String){
        let param:Parameters = [
            "platform": platform,
            "userid":userid,
            "accesstoken":accesstoken,
            "expires_in":expires_in
        ]
        WebConfig.Manager.request("\(WebConfig.webUrl)login", method: .post, parameters: param, encoding: URLEncoding.default, headers: WebConfig.headers).response { response in
            if let data = response.data {
                let json: JSON = JSON(data: data)
                print(json)
                
                if let error = json["error"].bool{
                    if !error{
                        self.performSegue(withIdentifier: "showDetail", sender: nil)
                    }else{
                        self.loginFail()
                    }
                }
                
            }
        }
        
        
    }
    


}
