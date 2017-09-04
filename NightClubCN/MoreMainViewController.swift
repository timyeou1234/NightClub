//
//  MoreMainViewController.swift
//  NightClubCN
//
//  Created by YeouTimothy on 2017/8/9.
//  Copyright © 2017年 Wework. All rights reserved.
//

import UIKit

class MoreMainViewController: UIViewController {
    
    var actionList = ["我的書籤", "在 App Store 給好評", "開啟通知", "語言（簡中，繁中，英文）", "回報錯誤", "清除緩存", "聯絡我們"]
    
    @IBOutlet weak var actionTableView: UITableView!

    @IBAction func discountAction(_ sender: Any) {
    }
    
    @IBAction func storeAction(_ sender: Any) {
    }
    
    @IBAction func starAction(_ sender: Any) {
    }
    
    @IBAction func fbAction(_ sender: Any) {
    }
    
    @IBAction func weiboAction(_ sender: Any) {
    }
    
    @IBAction func wechatAction(_ sender: Any) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        actionTableView.dataSource = self
        actionTableView.delegate = self
        
        actionTableView.register(UINib(nibName: "ActionTableViewCell", bundle: nil), forCellReuseIdentifier: "Cell")
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        actionTableView.reloadData()
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
    }
    

}

extension MoreMainViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.actionTableView.bounds.height / 7
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            if let id = User.user.id{
                self.performSegue(withIdentifier: "favoriteSegue", sender: id)
            }
        case 1:
        break
        case 2:
        break
        case 3:
            self.performSegue(withIdentifier: "langSegue", sender: nil)
        case 4:
            break
        case 5:
            break
        case 6:
            break
        default:
            break
        }
        if indexPath.row == 0{
            if let id = User.user.id{
                self.performSegue(withIdentifier: "favoriteSegue", sender: id)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ActionTableViewCell
        
        cell.detailLable.text = actionList[indexPath.row]
        cell.selectionStyle = .none
        return cell
    }
    
}
