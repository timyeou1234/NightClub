//
//  VideoStreamDetailViewController.swift
//  NightClubCN
//
//  Created by YeouTimothy on 2017/7/28.
//  Copyright © 2017年 Wework. All rights reserved.
//

import UIKit

class VideoStreamDetailViewController: UIViewController , BackDelegate{
    
    var video = Video()

    @IBOutlet weak var navigationBar: CustomNavigationView!
    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.backDelegate = self
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        NotificationCenter.default.addObserver(self, selector: #selector(playended), name: .UIWindowDidBecomeHidden, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(playStarted), name: .UIWindowDidBecomeVisible, object: nil)
        webView.allowsLinkPreview = true
        webView.allowsPictureInPictureMediaPlayback = true
        webView.allowsInlineMediaPlayback = true
        webView.stopLoading()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let urlString = video.video_embed_path{
            if let url = URL(string: urlString){
                webView.loadRequest(URLRequest(url: url))
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    
    func playStarted(){
        AppUtility.lockOrientation(.allButUpsideDown)
    }
    
    func playended(){
        
        AppUtility.lockOrientation(.portrait, andRotateTo: .portrait)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func back() {
        AppUtility.lockOrientation(.portrait, andRotateTo: .portrait)
        self.navigationController?.popViewController(animated: false)
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
