//
//  NightClubFunc.swift
//  NightClubCN
//
//  Created by YeouTimothy on 2017/7/27.
//  Copyright © 2017年 Wework. All rights reserved.
//

import UIKit

class NightClubFunc: NSObject {

}

extension UIView{
    
    func clipBackground(color:UIColor){
        self.layer.drawsAsynchronously = true
        self.backgroundColor = color
        self.layer.cornerRadius = self.frame.height/2
        self.layer.masksToBounds = true
    }
    
    func clipBackgroundClear(){
        self.layer.drawsAsynchronously = true
        self.layer.cornerRadius = self.frame.height/2
        self.layer.masksToBounds = true
    }
    
    @IBInspectable var shadow: Bool {
        get {
            return layer.shadowOpacity > 0.0
        }
        set {
            if newValue == true {
                self.addShadows()
            }
        }
    }
    
    @IBInspectable var cornerRadiused: CGFloat {
        get {
            return self.layer.cornerRadius
        }
        set {
            self.layer.cornerRadius = newValue
            
            // Don't touch the masksToBound property if a shadow is needed in addition to the cornerRadius
            if shadow == false {
                self.layer.masksToBounds = true
            }
        }
    }
    
    func addShadows(shadowColor: CGColor = UIColor.black.cgColor,
                    shadowOffset: CGSize = CGSize(width: 1.0, height: 2.0),
                    shadowOpacity: Float = 0.4,
                    shadowRadius: CGFloat = 3.0) {
        self.layer.drawsAsynchronously = true
        layer.shadowColor = shadowColor
        layer.shadowOffset = shadowOffset
        layer.shadowOpacity = shadowOpacity
        layer.shadowRadius = shadowRadius
    }
    
}
