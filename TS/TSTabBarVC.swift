//
//  TSTabBarVC.swift
//  TS
//
//  Created by shg on 2021/2/5.
//  Copyright © 2021 GR. All rights reserved.
//

import UIKit

class TSTabBarVC: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let item:UITabBarItem = self.tabBar.selectedItem!
        item.imageInsets = UIEdgeInsets(top: -6, left: -6, bottom: -6, right: -6)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        _ = onceCode
    }
    
    lazy var onceCode: Void = {
        let pass = UserDefaults.standard.object(forKey: "SHpassword")
        if pass != nil {
            let vc = MBAShouShiVC.init(nibName: "MBAShouShiVC", bundle: Bundle.main)
            vc.funcType = .login
            TSTool.window().rootViewController?.present(vc, animated: false, completion: nil)
        }
    }()
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        for allitem:UITabBarItem in self.tabBar.items! {
            if allitem.imageInsets != .zero {
                allitem.imageInsets = UIEdgeInsets.zero
                break
            }
        }
        item.imageInsets = UIEdgeInsets(top: -6, left: -6, bottom: -6, right: -6)
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
