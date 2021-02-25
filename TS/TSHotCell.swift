//
//  TSHotCell.swift
//  TS
//
//  Created by shg on 2021/2/22.
//  Copyright © 2021 GR. All rights reserved.
//

import UIKit

class TSHotCell: UITableViewCell {

    
    @IBOutlet weak var desLB: UILabel!
    @IBOutlet weak var titleLB: UILabel!
    @IBOutlet weak var headerImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.headerImageView.layer.cornerRadius = 10
        self.headerImageView.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
