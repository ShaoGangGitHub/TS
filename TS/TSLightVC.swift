//
//  TSLightVC.swift
//  TS
//
//  Created by shg on 2021/2/22.
//  Copyright © 2021 GR. All rights reserved.
//

import UIKit

class TSLightVC: TSBaseVC ,UITableViewDelegate,UITableViewDataSource{

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        self.title = "显示与亮度"
        super.viewDidLoad()
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellID")
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
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
        let light:UIUserInterfaceStyle = UIUserInterfaceStyle(rawValue: UserDefaults.standard.integer(forKey: "UserInterfaceStyle"))!
        switch indexPath.section {
        case 0:
            do {
                cell.textLabel?.text = "高亮模式"
                cell.textLabel?.textAlignment = .left
                let btn:UISwitch = UISwitch.init(frame: CGRect(x: 0, y: 0, width: 60, height: 30))
                btn.addTarget(self, action: #selector(btn(sender:)), for: .valueChanged)
                cell.accessoryView = btn
                btn.setOn(light == .light, animated: true)
            }
            break
        case 1:
            do {
                cell.textLabel?.text = "暗黑模式"
                cell.textLabel?.textAlignment = .left
                let btn:UISwitch = UISwitch.init(frame: CGRect(x: 0, y: 0, width: 60, height: 30))
                btn.addTarget(self, action: #selector(btn1(sender:)), for: .valueChanged)
                cell.accessoryView = btn
                btn.setOn(light == .dark, animated: true)
            }
            break
        case 2:
            do {
                cell.textLabel?.text = "跟随系统"
                cell.textLabel?.textAlignment = .left
                let btn:UISwitch = UISwitch.init(frame: CGRect(x: 0, y: 0, width: 60, height: 30))
                btn.addTarget(self, action: #selector(btn2(sender:)), for: .valueChanged)
                cell.accessoryView = btn
                btn.setOn(light == .unspecified, animated: true)
            }
            break
        default:
            break
        }
        return cell
    }
    
    @objc func btn(sender:UISwitch) {
        UserDefaults.standard.set(UIUserInterfaceStyle.light.rawValue, forKey: "UserInterfaceStyle")
        UserDefaults.standard.synchronize()
        self.tableView.reloadData()
        NotificationCenter.default.post(name: Notification.Name.init("UserInterfaceStyleNot"), object: nil, userInfo: ["UserInterfaceStyle":UIUserInterfaceStyle.light])
    }
    @objc func btn1(sender:UISwitch) {
        UserDefaults.standard.set(UIUserInterfaceStyle.dark.rawValue, forKey: "UserInterfaceStyle")
        UserDefaults.standard.synchronize()
        self.tableView.reloadData()
        NotificationCenter.default.post(name: Notification.Name.init("UserInterfaceStyleNot"), object: nil, userInfo: ["UserInterfaceStyle":UIUserInterfaceStyle.dark])
    }
    @objc func btn2(sender:UISwitch) {
        UserDefaults.standard.set(UIUserInterfaceStyle.unspecified.rawValue, forKey: "UserInterfaceStyle")
        UserDefaults.standard.synchronize()
        self.tableView.reloadData()
        NotificationCenter.default.post(name: Notification.Name.init("UserInterfaceStyleNot"), object: nil, userInfo: ["UserInterfaceStyle":UIUserInterfaceStyle.unspecified])
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
