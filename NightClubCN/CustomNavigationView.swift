//
//  CustomNavigationView.swift
//  NightClubCN
//
//  Created by YeouTimothy on 2017/7/3.
//  Copyright © 2017年 Wework. All rights reserved.
//

import UIKit

@objc protocol BackDelegate: class {
    func back()
    @objc optional func search()
    @objc optional func favorite()
    
}

@IBDesignable class CustomNavigationView: UIView {
    
    //該View
    var view:UIView!;
    //返回代理
    var backDelegate: BackDelegate?
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var titleLable: UILabel!
    @IBOutlet weak var bookMarkButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var searchButton: UIButton!
    
    //返回鍵
    @IBAction func backAction(_ sender: AnyObject) {
        backDelegate?.back()
    }
    
    @IBAction func searchAction(_ sender: Any) {
        backDelegate?.search!()
    }
    
    @IBAction func favoriteAction(_ sender: Any) {
        backDelegate?.favorite!()
    }
    
    @IBInspectable var lblTitleText : String?
        {
        get{
            return titleLable.text;
        }
        set(lblTitleText)
        {
            titleLable.text = lblTitleText!;
        }
    }
    
    @IBInspectable var bookMarkButtonIsHid: Bool{
        get{
            return bookMarkButton.isHidden
        }set(bookMarkButtonIsHid){
            bookMarkButton.isHidden = bookMarkButtonIsHid
        }
    }
    
    @IBInspectable var searchButtonIsHid: Bool{
        get{
            return searchButton.isHidden
        }set(searchButtonIsHid){
            searchButton.isHidden = searchButtonIsHid
        }
    }
    
    @IBInspectable var shareButtonIsHid: Bool{
        get{
            return shareButton.isHidden
        }set(shareButtonIsHid){
            shareButton.isHidden = shareButtonIsHid
        }
    }
    
    @IBInspectable var backButtonIsHid: Bool{
        get{
            return backButton.isHidden
        }set(backButtonIsHid){
            backButton.isHidden = backButtonIsHid
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib ()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadViewFromNib ()
    }
    
    //做出View的Func
    func loadViewFromNib() {
        
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "CustomNavigationView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//        backIcon.frame = CGRect(x: backIcon.frame.origin.x , y: backIcon.frame.origin.y , width:  self.tittleImage.frame.height, height: self.tittleImage.frame.width)
        self.addSubview(view);
        bookMarkButton.setImage(#imageLiteral(resourceName: "X297_Bookmark_Active"), for: .selected)
        bookMarkButton.setImage(#imageLiteral(resourceName: "X297_Bookmark_Normal"), for: .normal)
        
        
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
