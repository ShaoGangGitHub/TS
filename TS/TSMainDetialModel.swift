//
//  TSMainDetialModel.swift
//  TS
//
//  Created by shg on 2021/2/16.
//  Copyright © 2021 GR. All rights reserved.
//

import UIKit

class TSMainDetialModel: NSObject {

    @objc var addTime:String = ""
    @objc var iconName:String = ""
    var iconUrlT = ""
    @objc var iconUrl:String {
        set {
            self.iconUrlT = newValue
        }
        get {
            return self.iconUrlT.replacingOccurrences(of: "\n", with: "").replacingOccurrences(of: "\r", with: "")
        }
    }
    @objc var isDeleted:Any?
    @objc var modifyTime:String = ""
    @objc var number:Any?
    @objc var playUrl:String = ""
    @objc var remark:String = ""
    @objc var rid:Any?
    @objc var sourceId:Any?
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
}
