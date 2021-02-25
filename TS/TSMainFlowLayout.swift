//
//  TSMainFlowLayout.swift
//  TS
//
//  Created by shg on 2021/2/13.
//  Copyright © 2021 GR. All rights reserved.
//

import UIKit

class TSMainFlowLayout: UICollectionViewFlowLayout {

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return []
    }
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return UICollectionViewLayoutAttributes.init()
    }
}
