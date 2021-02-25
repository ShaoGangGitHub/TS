//
//  TSHisVC.swift
//  TS
//
//  Created by shg on 2021/2/23.
//  Copyright © 2021 GR. All rights reserved.
//

import UIKit

class TSHisVC: TSBaseVC ,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "播放历史"
        self.tableView.register(UINib.init(nibName: "TSMainDetialCell", bundle: Bundle.main), forCellReuseIdentifier: "TSMainDetialCell")
        self.getData()
    }
    
    lazy var array: Array<TSMainDetialModel> = {
        let arr = Array<TSMainDetialModel>.init()
        return arr
    }()
    func getData() {
        let arr:Array<Dictionary<String,String>> = TSarchiver.uar(Array.init()) as Array<Dictionary<String, String>>
        for dic:Dictionary<String,String> in arr {
            let model = TSMainDetialModel.init()
            model.iconName = dic["title"]!
            model.playUrl = dic["playUrl"]!
            model.iconUrl = dic["iconUrl"]!
            self.array.append(model)
        }
        self.tableView.reloadData()
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
        if self.array.count != 0 {
            return 100
        }
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if self.array.count != 0 {
            let view = UIView.init(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 100))
            let btn:UIButton = UIButton.init(type: .custom)
            btn.frame = CGRect(x: 0, y: 35, width: view.bounds.size.width, height: 30)
            btn.setTitle("清除播放历史", for: .normal)
            btn.setTitleColor(.red, for: .normal)
            btn.addTarget(self, action: #selector(clear(sender:)), for: .touchUpInside)
            view.addSubview(btn)
            return view
        }
        return UIView.init()
    }
    
    @objc func clear(sender:UIButton) {
        TSarchiver.ar([])
        self.array.removeAll()
        self.tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
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
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "删除"
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        self.array.remove(at: indexPath.row)
        tableView.reloadData()
        DispatchQueue.global().async {
            var array:Array<Dictionary<String,String>> = Array<Dictionary<String,String>>.init()
            for model:TSMainDetialModel in self.array {
                array.append(["playUrl":model.playUrl,"title":model.iconName,"iconUrl":model.iconUrl])
            }
            TSarchiver.ar(array)
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
