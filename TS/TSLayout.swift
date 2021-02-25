//
//  TSLayout.swift
//  TS
//
//  Created by shg on 2021/2/23.
//  Copyright © 2021 GR. All rights reserved.
//

import UIKit

class TSLayout: UICollectionViewFlowLayout {

    func reload(source:Array<TSMainModel>) {
        self.source = source
        self.collectionView?.reloadData()
    }
    var source:Array<TSMainModel> = Array<TSMainModel>.init()
    var arrAttributes:Array<UICollectionViewLayoutAttributes> = Array<UICollectionViewLayoutAttributes>.init()
    
    override func prepare() {
        super.prepare()
        
        if self.source.count == 0 {
            return
        }
        self.arrAttributes.removeAll()
        for i:Int in 0 ..< self.source.count {
            let model:TSMainModel = self.source[i]
            model.index = i
            let indexPath = IndexPath.init(item: model.index, section: 0)
            if let arrt = self.layoutAttributesForItem(at: indexPath) {
                var frame = arrt.frame
                frame.size.width = model.width
                frame.size.height = model.hetght
                self.arrAttributes.append(arrt)
            }
        }
//        self.itemSize = CGSize(width: 200, height: 200)
        /*
        for i:Int in 0 ..< self.source.count {
            let model:TSMainModel = self.source[i]
            model.index = i
            DispatchQueue.global().async {[self] in
                var data:Data?
                do {
                    try data = Data.init(contentsOf: URL.init(string: model.iconUrl)!)
                } catch {
                    
                }
                if data != nil {
                    if let image:UIImage = UIImage.init(data: data!) {
                        let scale = image.size.height/image.size.width
                        model.hetght = model.width * scale + 30
                        let indexPath = IndexPath.init(item: model.index, section: 0)
                        if let arrt = self.layoutAttributesForItem(at: indexPath) {
                            var frame = arrt.frame
                            frame.size.width = model.width
                            frame.size.height = model.hetght
                            DispatchQueue.main.async {[self] in
                                self.arrAttributes.remove(at: model.index)
                                self.arrAttributes.insert(arrt, at: model.index)
                                self.itemSize = CGSize(width: model.width, height: model.hetght)
                                self.collectionView?.reloadData()
                            }
                        }
                    }
                }
            }
        }
 */
    }
    
//    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
//        return self.arrAttributes
//    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        
        let arr:UICollectionViewLayoutAttributes = UICollectionViewLayoutAttributes.init(forCellWith: indexPath)
        return arr
    }
}
