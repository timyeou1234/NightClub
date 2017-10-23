//
//  PartyPagerViewController.swift
//  NightClubCN
//
//  Created by YeouTimothy on 2017/7/3.
//  Copyright © 2017年 Wework. All rights reserved.
//

import UIKit
import XLPagerTabStrip

protocol PageChange {
    func pageChange(goto:String)
}

class PartyPagerViewController: ButtonBarPagerTabStripViewController, PageChange {

    override func viewDidLoad() {
        
        self.settings.style.buttonBarItemTitleColor = UIColor(colorLiteralRed: 154/255, green: 154/255, blue: 154/255, alpha: 1)
        
        self.settings.style.selectedBarBackgroundColor = UIColor(colorLiteralRed: 255/255, green: 255/255, blue: 255/255, alpha: 1)
        self.settings.style.selectedBarHeight = 2
        settings.style.buttonBarItemFont = UIFont.systemFont(ofSize: 14)
        self.settings.style.buttonBarBackgroundColor = UIColor.white
        self.settings.style.buttonBarMinimumLineSpacing = 0
        settings.style.buttonBarItemBackgroundColor = UIColor(colorLiteralRed: 24/255, green: 24/255, blue: 24/255, alpha: 1)
        settings.style.selectedBarBackgroundColor = .white
        super.viewDidLoad()
        
        buttonBarView.backgroundColor = UIColor.white
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        let partyTableViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PartyTableViewController")
        
        let partyNewsViewController: PartyNewsViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PartyNewsViewController") as! PartyNewsViewController
        
        let childViewControllers:[UIViewController] = [partyTableViewController, partyNewsViewController]
        
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
