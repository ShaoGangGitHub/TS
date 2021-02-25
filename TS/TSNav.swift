//
//  TSNav.swift
//  TS
//
//  Created by shg on 2021/2/5.
//  Copyright © 2021 GR. All rights reserved.
//

import UIKit

class TSNav: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationBar.tintColor = UIColor.label
        NotificationCenter.default.addObserver(self, selector: #selector(lightchange(sender:)), name: Notification.Name.init("UserInterfaceStyleNot"), object: nil)
        let light:UIUserInterfaceStyle = UIUserInterfaceStyle(rawValue: UserDefaults.standard.integer(forKey: "UserInterfaceStyle"))!
        self.overrideUserInterfaceStyle = light
    }
    
    @objc func lightchange(sender:Notification) {
        let info:Dictionary<String,UIUserInterfaceStyle> = sender.userInfo as! Dictionary<String,UIUserInterfaceStyle>
        let style:UIUserInterfaceStyle = info["UserInterfaceStyle"]!
        self.overrideUserInterfaceStyle = style
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
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
