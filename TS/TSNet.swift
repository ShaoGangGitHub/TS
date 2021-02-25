//
//  TSNet.swift
//  TS
//
//  Created by shg on 2021/2/4.
//  Copyright © 2021 GR. All rights reserved.
//

import UIKit

class TSNet: NSObject {

    class func post(url:String,param:Dictionary<String,Any>,success:(@escaping((_ resp:Dictionary<String,Any>) -> Void)),faiuler:(@escaping((_ error:Error) -> Void))) {
        let session:URLSession = URLSession.shared;
        let baseurl = URL.init(string: "http://hope.wuqiongda8888.com")
        var req:URLRequest = URLRequest.init(url: URL.init(string: url, relativeTo: baseurl)!)
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        req.httpMethod = "POST"
        var data:Data?
        do {
            try data = JSONSerialization.data(withJSONObject: param, options: .fragmentsAllowed)
        } catch {
            
        }
        req.httpBody = data
        let task:URLSessionDataTask = session.dataTask(with: req) { (data:Data?, resp:URLResponse?, error:Error?) in
            DispatchQueue.main.async {
                if error != nil {
                    faiuler(error!)
                    return
                }
                if data == nil {
                    faiuler(NSError.init(domain: "数据为空", code: 1, userInfo: [NSLocalizedDescriptionKey:"数据为空"]) as Error)
                    return
                }
                var dic:Dictionary<String,Any>?
                do {
                    try dic = JSONSerialization.jsonObject(with: data!, options: .fragmentsAllowed) as? Dictionary<String, Any>
                } catch {
                    faiuler(NSError.init(domain: "数据为空", code: 1, userInfo: [NSLocalizedDescriptionKey:"数据为空"]) as Error)
                    return
                }
                let code:String = dic!["code"] as! String
                if code != "0000" {
                    let message:String = dic!["message"] as! String
                    faiuler(NSError.init(domain: message, code: 1, userInfo: [NSLocalizedDescriptionKey:message]) as Error)
                    return
                }
                success(dic!)
            }
        }
        task.resume()
    }
}
