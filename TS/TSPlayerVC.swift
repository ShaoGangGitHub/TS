//
//  TSPlayerVC.swift
//  TS
//
//  Created by shg on 2021/2/18.
//  Copyright © 2021 GR. All rights reserved.
//

import UIKit
import AVKit

class TSPlayerVC: TSBaseVC {

    var array:Array<TSMainDetialModel>!
    var index:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
        var arr:Array<PlayModel> = Array<PlayModel>.init()
        for i:Int in 0 ..< self.array.count {
            let model:TSMainDetialModel = self.array[i]
            let playModel:PlayModel = PlayModel.init()
            playModel.title = model.iconName
            playModel.playUrl = model.playUrl
            playModel.imgUrl = model.iconUrl
            playModel.index = i
            arr.append(playModel)
        }
        let model:PlayModel = arr[self.index]
        let playerView:TSPlayerView = TSPlayerView.init(frame: UIScreen.main.bounds)
        playerView.source = arr
        playerView.play(with: model)
        playerView.closeBlock = {[self] in
            self.dismiss(animated: true, completion: nil)
        }
        self.view.addSubview(playerView)
    }
    
    override var modalPresentationStyle: UIModalPresentationStyle {
        set {
            
        }
        get {
            return .fullScreen
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        get {
            return true
        }
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
