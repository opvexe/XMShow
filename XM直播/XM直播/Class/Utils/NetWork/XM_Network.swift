//
//  XM_Network.swift
//  XM直播
//
//  Created by GDBank on 2017/8/15.
//  Copyright © 2017年 com.GDBank.Company. All rights reserved.
//

import UIKit
import Alamofire

let NetworkTimeoutInterval:Double = 10

class XM_Network: NSObject {
    
    static var sessionManager:SessionManager?
    
    class func request(method:HTTPMethod, url:String, parameters:NSDictionary?, finishedCallback:  @escaping (_ result : AnyObject, _ error: Error?) -> ()){
        let config:URLSessionConfiguration = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = NetworkTimeoutInterval
        sessionManager = SessionManager(configuration: config)
        
        Alamofire.request(url, method: method, parameters: parameters as? Parameters).responseJSON
            { (response) in
                let data = response.result.value
                if (response.result.isSuccess)
                {
                    finishedCallback(data as AnyObject, nil)
                }
                else
                {
                    finishedCallback(data as AnyObject,response.result.error)
                }
        }
    }
}
