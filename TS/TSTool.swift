//
//  TSTool.swift
//  TS
//
//  Created by shg on 2021/2/5.
//  Copyright © 2021 GR. All rights reserved.
//

import UIKit

class TSTool: NSObject {

    class func window() -> UIWindow {
        let window = UIApplication.shared.connectedScenes.filter({ $0.activationState == .foregroundActive }).map({ $0 as? UIWindowScene }).compactMap({ $0 }).last?.windows.filter({ $0.isKeyWindow }).last
        return window!
    }
    
    static var hud:UIActivityIndicatorView {
        get {
            let loading:UIActivityIndicatorView = UIActivityIndicatorView.init(style: .large)
            loading.frame = CGRect(x: UIScreen.main.bounds.width/2 - 50, y: UIScreen.main.bounds.size.height/2 - 50, width: 100, height: 100)
            loading.color = UIColor.label
            loading.hidesWhenStopped = true
            loading.startAnimating()
            self.window().addSubview(loading)
            return loading
        }
    }
    
    class func loading() -> UIActivityIndicatorView {
        return self.hud
    }
}
