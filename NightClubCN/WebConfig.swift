//
//  WebConfig.swift
//  NightClubCN
//
//  Created by YeouTimothy on 2017/7/3.
//  Copyright © 2017年 Wework. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class WebConfig: NSObject {
    
    static let webUrl = "https://128.199.184.200/nightclub/v1/"
    static let headers: HTTPHeaders = [
        "Content-Type": "application/x-www-form-urlencoded",
        "Authorization": "8ef6de6ae47874a859b339b4126dde88",
        "Accept": "application/json"
    ]
    
    static var Manager: Alamofire.SessionManager = {
        
        // Create the server trust policies
        let serverTrustPolicies: [String: ServerTrustPolicy] = [
            "128.199.184.200": .disableEvaluation
        ]
        
        
        
        // Create custom manager
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = Alamofire.SessionManager.defaultHTTPHeaders
        let manager = Alamofire.SessionManager(
            configuration: URLSessionConfiguration.default,
            serverTrustPolicyManager: ServerTrustPolicyManager(policies: serverTrustPolicies)
        )
        
        return manager
    }()
    
}
