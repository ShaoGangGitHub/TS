//
//  TSMainModel.swift
//  TS
//
//  Created by shg on 2021/2/13.
//  Copyright © 2021 GR. All rights reserved.
//

import UIKit

class TSMainModel: NSObject {

    @objc var addTime:Any?
    @objc var descriptionV:String = ""
    var iconUrlT = ""
    weak var collectionView:UICollectionView?
    
    @objc var iconUrl:String {
        set {
            self.iconUrlT = newValue
            DispatchQueue.global().async {[self] in
                var data:Data?
                do {
                    try data = Data.init(contentsOf: URL.init(string: self.iconUrlT)!)
                } catch {
                    
                }
                if data != nil {
                    if let image:UIImage = UIImage.init(data: data!) {
                        let scale = image.size.height/image.size.width
                        self.hetght = self.width * scale + 30
                        DispatchQueue.main.async {[self] in
                            self.collectionView?.reloadData()
                        }
                    }
                }
            }
        }
        get {
            return self.iconUrlT.replacingOccurrences(of: "\n", with: "").replacingOccurrences(of: "\r", with: "")
        }
    }
    @objc var isDeleted:Any?
    @objc var modifyTime:Any?
    @objc var remark:String = ""
    @objc var rid:Any?
    @objc var sourceName:String = ""
    @objc var status:String = ""
    @objc var tag:String = ""
    @objc var totalNumber:Any?
    @objc var type:String = ""
    @objc var hetght:CGFloat = (UIScreen.main.bounds.size.width - 30)/2
    @objc var width:CGFloat = (UIScreen.main.bounds.size.width - 20)
    @objc var index:Int = 0
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        if key == "description" {
            self.descriptionV = value as! String
        }
    }
    
    var imageLoadFinished:((_ size:CGSize) -> ())?
    
}
