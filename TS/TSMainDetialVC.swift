//
//  TSMainDetialVC.swift
//  TS
//
//  Created by shg on 2021/2/14.
//  Copyright © 2021 GR. All rights reserved.
//

import UIKit
import AVKit

class TSMainDetialVC: TSBaseVC ,UITableViewDelegate, UITableViewDataSource,UIScrollViewDelegate{

    var sourceId:String = ""
    lazy var array: Array<TSMainDetialModel> = {
        let arr = Array<TSMainDetialModel>.init()
        return arr
    }()
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UINib.init(nibName: "TSMainDetialCell", bundle: Bundle.main), forCellReuseIdentifier: "TSMainDetialCell")
        self.getData()
    }
    
    func getData() {
        let hud:UIActivityIndicatorView = TSTool.loading()
        TSNet.post(url: "source/sourceDetails", param: ["sourceId":self.sourceId]) {[self] (resp) in
            print(resp)
            let data:Array<Dictionary<String,Any>> = resp["data"] as! Array<Dictionary<String,Any>>
            for dic:Dictionary<String,Any> in data {
                let model:TSMainDetialModel = TSMainDetialModel.init()
                model.setValuesForKeys(dic)
                self.array.append(model)
            }
            hud.stopAnimating()
            self.tableView.reloadData()
        } faiuler: { (error) in
            hud.stopAnimating()
            print(error)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.array.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:TSMainDetialCell = tableView.dequeueReusableCell(withIdentifier: "TSMainDetialCell") as! TSMainDetialCell
        let model:TSMainDetialModel = self.array[indexPath.row]
        cell.headerImageView.sd_setImage(with: URL.init(string: model.iconUrl), placeholderImage: UIImage.init(named: "pl"), options: .delayPlaceholder) { (image, error, type, url) in
            
        }
        cell.titleLB.text = model.iconName
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let manger = AFNetworkReachabilityManager.shared()
        let net:String = manger.localizedNetworkReachabilityStatusString()
        if net == "Not Reachable" {
            let alert = UIAlertController.init(title: "提示", message: "网络连接中断，请检查网络连接", preferredStyle: .alert)
            let ok = UIAlertAction.init(title: "确定", style: .default) { (action) in
            }
            alert.addAction(ok)
            self.present(alert, animated: true) {
                
            }
            return
        }
        if net.contains("WWAN") {
            let ison:Bool = UserDefaults.standard.bool(forKey: "WLANON")
            if ison {
                self.play(indexPath: indexPath)
            } else {
                let alert = UIAlertController.init(title: "提示", message: "当前网络非wifi，播放会消耗数据流量，是否继续播放？", preferredStyle: .alert)
                let ok = UIAlertAction.init(title: "播放", style: .default) {[self] (action) in
                    self.play(indexPath: indexPath)
                }
                let calcle = UIAlertAction.init(title: "取消", style: .default) { (action) in
                    
                }
                alert.addAction(ok)
                alert.addAction(calcle)
                self.present(alert, animated: true, completion: nil)
            }
            return
        } else {
            self.play(indexPath: indexPath)
        }
    }
    
    func play(indexPath:IndexPath) {
        let playVC:TSPlayerVC = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(identifier: "TSPlayerVC") as! TSPlayerVC
        playVC.array = self.array
        playVC.index = indexPath.row
        self.present(playVC, animated: true, completion: nil)
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

