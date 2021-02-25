//
//  TSMainVC.swift
//  TS
//
//  Created by shg on 2021/2/5.
//  Copyright © 2021 GR. All rights reserved.
//

import UIKit

class TSMainVC: TSBaseVC ,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    @IBOutlet weak var conllectionView: UICollectionView!
    var array:Array<TSMainModel> = Array<TSMainModel>.init()
    var myLayout:TSCollectionViewLayout = TSCollectionViewLayout.init()
    var arrmHeight:Array<NSNumber> = Array.init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.conllectionView.register(UINib.init(nibName: "TSMainCell", bundle: Bundle.main), forCellWithReuseIdentifier: "TSMainCell")
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
        guard let data:Array<Dictionary<String,Any>> = UserDefaults.standard.object(forKey: "TSMainData") as? Array<Dictionary<String, Any>> else {
            let hud:UIActivityIndicatorView = TSTool.loading()
            TSNet.post(url: "source/sources", param: ["categoryName":"tangshiqimeng"]) {[self] (resp) in
                let data:Array<Dictionary<String,Any>> = resp["data"] as! Array<Dictionary<String,Any>>
                UserDefaults.standard.set(data, forKey: "TSMainData")
                UserDefaults.standard.synchronize()
                for dic:Dictionary<String,Any> in data {
                    let model:TSMainModel = TSMainModel.init()
                    model.collectionView = self.conllectionView
                    model.setValuesForKeys(dic)
                    self.array.append(model)
                }
                hud.stopAnimating()
                self.conllectionView.reloadData()
            } faiuler: { (error) in
                hud.stopAnimating()
                print(error)
            }
            return
        }
        for dic:Dictionary<String,Any> in data {
            let model:TSMainModel = TSMainModel.init()
            model.collectionView = self.conllectionView
            model.setValuesForKeys(dic)
            self.array.append(model)
        }
        self.conllectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 10, bottom: 10, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.array.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:TSMainCell = collectionView.dequeueReusableCell(withReuseIdentifier: "TSMainCell", for: indexPath) as! TSMainCell
        let model:TSMainModel = self.array[indexPath.item]
        let imageUrl:String = model.iconUrl
        cell.imageView.sd_setImage(with: URL.init(string: imageUrl), placeholderImage: UIImage.init(named: "pl"), options: .delayPlaceholder) { (image, error, type, url) in
            
        }
        cell.despLB.text = model.sourceName
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let model:TSMainModel = self.array[indexPath.item]
        return CGSize(width: model.width, height: model.hetght)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model:TSMainModel = self.array[indexPath.item]
        let detialVC:TSMainDetialVC = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(identifier: "TSMainDetialVC") as! TSMainDetialVC
        detialVC.hidesBottomBarWhenPushed = true
        detialVC.title = model.sourceName
        detialVC.sourceId = String.init(format: "%@", _:model.rid as! CVarArg)
        self.navigationController?.pushViewController(detialVC, animated: true)
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
