//
//  TSSetVC.swift
//  TS
//
//  Created by shg on 2021/2/5.
//  Copyright © 2021 GR. All rights reserved.
//

import UIKit

class TSSetVC: TSBaseVC ,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var isref:Bool = false
    
    lazy var hud: UIActivityIndicatorView = {
        let hud:UIActivityIndicatorView = UIActivityIndicatorView.init(style: .medium)
        return hud
    }()
    
    lazy var lb: UILabel = {
        let lb = UILabel.init()
        return lb
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellID")
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 8
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cellID")!
        cell.selectionStyle = .none
        cell.accessoryType = .disclosureIndicator
        switch indexPath.section {
        case 0:
            do {
                cell.textLabel?.text = "清除缓存"
                cell.textLabel?.textAlignment = .left
                self.lb.frame = CGRect(x: tableView.bounds.size.width - 200, y: 0, width: 155, height: 45)
                self.lb.textAlignment = .right
                self.lb.text = "0kb"
                cell.addSubview(self.lb)
                let size:UInt = SDImageCache.shared().getSize()
                if size < 1024 {
                    self.lb.text = String.init(format: "%dB", _:size)
                } else if size >= 1024 && size < 1024 * 1024 {
                    let sizekb = CGFloat(size)/1024
                    self.lb.text = String.init(format: "%.2fKB", _:sizekb)
                } else {
                    let sizemb = CGFloat(size)/1024/1024
                    self.lb.text = String.init(format: "%.2fMB", _:sizemb)
                }
                self.lb.isUserInteractionEnabled = true
                let tap:UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(tapAction(sender:)))
                self.lb.addGestureRecognizer(tap)
                if self.isref {
                    self.hud.color = .label
                    self.hud.startAnimating()
                    cell.accessoryView = self.hud
                } else {
                    self.hud.stopAnimating()
                    self.hud.removeFromSuperview()
                    cell.accessoryView = nil
                    cell.accessoryType = .disclosureIndicator
                }
            }
            break
        case 1:
            do {
                cell.textLabel?.text = "蜂窝网络播放"
                cell.textLabel?.textAlignment = .left
                let btn:UISwitch = UISwitch.init(frame: CGRect(x: 0, y: 0, width: 60, height: 30))
                btn.addTarget(self, action: #selector(btn(sender:)), for: .valueChanged)
                let ison:Bool = UserDefaults.standard.bool(forKey: "WLANON")
                btn.setOn(ison, animated: true)
                cell.accessoryView = btn
            }
            break
        case 2:
            do {
                cell.textLabel?.text = "关于儿童诗词"
                cell.textLabel?.textAlignment = .left
            }
            break
        case 3:
            do {
                cell.textLabel?.text = "播放历史"
                cell.textLabel?.textAlignment = .left
            }
            break
        case 4:
            do {
                cell.textLabel?.text = "显示与亮度"
                cell.textLabel?.textAlignment = .left
            }
            break
        case 5:
            do {
                cell.textLabel?.text = "本地视频播放"
                cell.textLabel?.textAlignment = .left
            }
            break
        case 6:
            do {
                cell.textLabel?.text = "设置手势"
                cell.textLabel?.textAlignment = .left
            }
            break
        case 7:
            do {
                let pass = UserDefaults.standard.object(forKey: "SHpassword")
                cell.textLabel?.text = "手势已关闭"
                cell.textLabel?.textAlignment = .left
                let btn:UISwitch = UISwitch.init(frame: CGRect(x: 0, y: 0, width: 60, height: 30))
                btn.addTarget(self, action: #selector(btn1(sender:)), for: .valueChanged)
                btn.setOn(pass == nil, animated: true)
                cell.accessoryView = btn
            }
            break
        default:
            break
        }
        return cell
    }
    
    @objc func btn(sender:UISwitch) {
        if sender.isOn {
            UserDefaults.standard.set(true, forKey: "WLANON")
            UserDefaults.standard.synchronize()
        } else {
            UserDefaults.standard.set(false, forKey: "WLANON")
            UserDefaults.standard.synchronize()
        }
    }
    @objc func btn1(sender:UISwitch) {
        if !sender.isOn {
            let pass = UserDefaults.standard.object(forKey: "SHpassword")
            if pass == nil {
                let alert = UIAlertController.init(title: "提示", message: "还未设置手势密码", preferredStyle: .alert)
                let ok = UIAlertAction.init(title: "确定", style: .default) { (action) in
                    sender.setOn(true, animated: true)
                }
                alert.addAction(ok)
                self.present(alert, animated: true, completion: nil)
            }
        } else {
            UserDefaults.standard.removeObject(forKey: "SHpassword")
            UserDefaults.standard.synchronize()
            self.tableView.reloadData()
        }
    }
    
    @objc func tapAction(sender:UITapGestureRecognizer) {
        let lb:UILabel = sender.view as! UILabel
        lb.removeFromSuperview()
        self.isref = true
        self.tableView.reloadRows(at: [IndexPath.init(row: 0, section: 0)], with: .none)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {[self] in
            SDImageCache.shared().clearDisk {[self] in
                self.isref = false
                self.tableView.reloadRows(at: [IndexPath.init(row: 0, section: 0)], with: .none)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 2:
            do {
                let vc:TSAboutVC = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(identifier: "TSAboutVC") as! TSAboutVC
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
                
            }
            break
        case 3:
            do {
                let vc:TSHisVC = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(identifier: "TSHisVC") as! TSHisVC
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
                
            }
            break
        case 4:
            do {
                let vc:TSLightVC = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(identifier: "TSLightVC") as! TSLightVC
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
            }
            break
        case 5:
            do {
                let videoVC = TSVideoVC.init()
                videoVC.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(videoVC, animated: true)
                videoVC.callBack = {[self] (url) in
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                        let model:TSMainDetialModel = TSMainDetialModel.init()
                        model.playUrl = url
                        model.iconName = "本地视频"
                        let playVC:TSPlayerVC = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(identifier: "TSPlayerVC") as! TSPlayerVC
                        playVC.array = [model]
                        playVC.index = 0
                        self.present(playVC, animated: true, completion: nil)
                    }
                }
            }
            break
        case 6:
            do {
                let vc = MBAShouShiVC.init(nibName: "MBAShouShiVC", bundle: Bundle.main)
                vc.hidesBottomBarWhenPushed = true
                vc.funcType = .regest
                self.navigationController?.pushViewController(vc, animated: true)
            }
            break
        default:
            break
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
