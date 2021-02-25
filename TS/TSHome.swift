//
//  ViewController.swift
//  TS
//
//  Created by shg on 2021/2/4.
//

import UIKit

class TSHome: TSBaseVC , UITableViewDataSource,UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    var array:Array<TSMainModel> = Array<TSMainModel>.init()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UINib.init(nibName: "TSHotCell", bundle: Bundle.main), forCellReuseIdentifier: "TSHotCell")
        self.getData()
        NotificationCenter.default.addObserver(self, selector: #selector(netChange(sender:)), name: NSNotification.Name.AFNetworkingReachabilityDidChange, object: nil)
    }
    @objc func netChange(sender:Notification) {
        let userinfo = sender.userInfo
        let status:AFNetworkReachabilityStatus = AFNetworkReachabilityStatus(rawValue: userinfo![AFNetworkingReachabilityNotificationStatusItem] as! Int)!
        if status == .notReachable {
            
        }
        if status == .reachableViaWWAN {
            if self.array.count == 0 {
                self.getData()
            }
        }
        if status == .reachableViaWiFi {
            if self.array.count == 0 {
                self.getData()
            }
        }
        if status == .unknown {
            
        }
    }
    func getData() {
        guard let data:Array<Dictionary<String,Any>> = UserDefaults.standard.object(forKey: "TSMainHomeData") as? Array<Dictionary<String, Any>> else {
            let hud:UIActivityIndicatorView = TSTool.loading()
            TSNet.post(url: "source/sources", param: ["categoryName":"tangshiqimeng56"]) {[self] (resp) in
                print(resp)
                let data:Array<Dictionary<String,Any>> = resp["data"] as! Array<Dictionary<String,Any>>
                UserDefaults.standard.set(data, forKey: "TSMainHomeData")
                UserDefaults.standard.synchronize()
                for dic:Dictionary<String,Any> in data {
                    let model:TSMainModel = TSMainModel.init()
                    model.setValuesForKeys(dic)
                    self.array.append(model)
                }
                hud.stopAnimating()
                self.tableView.reloadData()
            } faiuler: { (error) in
                hud.stopAnimating()
                print(error)
            }
            return
        }
        for dic:Dictionary<String,Any> in data {
            let model:TSMainModel = TSMainModel.init()
            model.setValuesForKeys(dic)
            self.array.append(model)
        }
        self.tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.array.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:TSHotCell = tableView.dequeueReusableCell(withIdentifier: "TSHotCell") as! TSHotCell
        let model:TSMainModel = self.array[indexPath.row]
        let imageUrl:String = model.iconUrl
        cell.headerImageView.sd_setImage(with: URL.init(string: imageUrl), placeholderImage: UIImage.init(named: "pl"), options: .delayPlaceholder) { (image, error, type, url) in
            
        }
        cell.titleLB.text = model.sourceName
        cell.desLB.text = model.descriptionV
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model:TSMainModel = self.array[indexPath.row]
        let detialVC:TSMainDetialVC = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(identifier: "TSMainDetialVC") as! TSMainDetialVC
        detialVC.hidesBottomBarWhenPushed = true
        detialVC.title = model.sourceName
        detialVC.sourceId = String.init(format: "%@", _:model.rid as! CVarArg)
        self.navigationController?.pushViewController(detialVC, animated: true)
    }
}

