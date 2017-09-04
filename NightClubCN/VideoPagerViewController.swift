//
//  VideoPagerViewController.swift
//  NightClubCN
//
//  Created by YeouTimothy on 2017/7/22.
//  Copyright © 2017年 Wework. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class VideoPagerViewController: ButtonBarPagerTabStripViewController, PageChange {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.settings.style.buttonBarItemTitleColor = UIColor(colorLiteralRed: 107/255, green: 126/255, blue: 238/255, alpha: 1)
        self.settings.style.selectedBarBackgroundColor = UIColor(colorLiteralRed: 107/255, green: 126/255, blue: 238/255, alpha: 1)
        self.settings.style.selectedBarHeight = 2
        self.settings.style.buttonBarBackgroundColor = UIColor.white
        self.settings.style.buttonBarMinimumLineSpacing = 0
        settings.style.buttonBarItemBackgroundColor = .white
        super.viewDidLoad()
        
        buttonBarView.backgroundColor = UIColor.white
        // Do any additional setup after loading the view.
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        let videoCollectionViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "VideoCollectionViewController")
        
        let videoStreamViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "VideoStreamViewController")
        
        let childViewControllers:[UIViewController] = [videoCollectionViewController, videoStreamViewController]
        
        return childViewControllers
        
    }

    
    func pageChange(goto: String) {
        
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
