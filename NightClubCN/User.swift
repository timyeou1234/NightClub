//
//  User.swift
//  NightClubCN
//
//  Created by YeouTimothy on 2017/8/26.
//  Copyright © 2017年 Wework. All rights reserved.
//

import UIKit

class User: NSObject {
    
    static let user = User()
    
    var id:String?
    var platform:Int?
    var accesstoken:String?
    var expire_in:String?
    var inCn:Bool?
    
    var partyFavorite:[String]?
    var newsFavorite:[String]?
    var videoFavorite:[String]?

}
