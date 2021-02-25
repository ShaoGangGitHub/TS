//
//  TSAboutVC.swift
//  TS
//
//  Created by shg on 2021/2/22.
//  Copyright © 2021 GR. All rights reserved.
//

import UIKit

class TSAboutVC: TSBaseVC {

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var verLB: UILabel!
    @IBOutlet weak var nameLB: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.systemGroupedBackground
        self.title = "关于"
        let info = Bundle.main.infoDictionary
        let name:String = info!["CFBundleDisplayName"] as! String
        self.nameLB.text = name
        let version:String = info!["CFBundleShortVersionString"] as! String
        self.verLB.text = String.init(format: "当前版本：v %@", _:version)
        self.iconImageView.layer.cornerRadius = 20
        self.iconImageView.layer.masksToBounds = true
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
