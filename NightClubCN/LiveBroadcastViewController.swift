//
//  LiveBroadcastViewController.swift
//  NightClubCN
//
//  Created by YeouTimothy on 2017/7/6.
//  Copyright © 2017年 Wework. All rights reserved.
//

import UIKit

class LiveBroadcastViewController: UIViewController {

    @IBOutlet weak var broadcastWebView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        broadcastWebView.loadRequest(URLRequest(url: URL(string: "http://new.yizhibo.com/l/4JcW2028DcwRxhtZ.html?p_from=Phome_HotAnchorRecommand")!))
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
