//
//  TSMainCell.swift
//  TS
//
//  Created by shg on 2021/2/13.
//  Copyright © 2021 GR. All rights reserved.
//

import UIKit

class TSMainCell: UICollectionViewCell {

    @IBOutlet weak var despLB: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 8
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.separator.cgColor
        self.layer.masksToBounds = true
    }

}
