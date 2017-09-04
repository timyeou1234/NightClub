//
//  LangViewController.swift
//  NightClubCN
//
//  Created by YeouTimothy on 2017/9/3.
//  Copyright © 2017年 Wework. All rights reserved.
//

import UIKit

class LangViewController: UIViewController, BackDelegate{

    var langString:String?
    var langList = ["簡體中文", "繁體中文", "英文"]
    
    @IBOutlet weak var navigation: CustomNavigationView!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "LangTableViewCell", bundle: nil), forCellReuseIdentifier: "Cell")
        
        navigation.backDelegate = self
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let langStr = Locale.current.languageCode
        langString = langStr
        print(langString)
        tableView.reloadData()
    }
    
    func back() {
        self.navigationController?.popViewController(animated: true)
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

}

extension LangViewController: UITableViewDataSource, UITableViewDelegate{

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var lang = ""
        switch indexPath.row {
        case 0:
            lang = "cn"
        case 1:
            lang = "zh"
        default:
            lang = "en"
        }
        if lang == langString{
            return
        }else{
            langString = lang
            tableView.reloadData()
            showAlert(title: "設定需重啟後生效", Message: nil)
        }
        UserDefaults.standard.set([lang], forKey: "AppleLanguages")
        UserDefaults.standard.synchronize()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! LangTableViewCell
        
        cell.detailLable.text = langList[indexPath.row]
        cell.detailImageView.isHidden = true
        
        switch indexPath.row {
        case 0:
            if langString == "cn"{
                cell.detailImageView.isHidden = false
            }
        case 1:
            if langString == "zh"{
                cell.detailImageView.isHidden = false
            }
        default:
            if langString != "cn" && langString != "zh"{
                cell.detailImageView.isHidden = false
            }
        }
        
        cell.selectionStyle = .none
        
        return cell
    }
    
    func showAlert(title:String, Message:String?){
        let alert = UIAlertController(title: title, message: Message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "確認", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
    }

}
