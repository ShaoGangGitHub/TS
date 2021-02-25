//
//  MBAShouShiVC.swift
//  MobileFourAOC
//
//  Created by shg on 2020/11/12.
//  Copyright © 2020 asiainfo. All rights reserved.
//

import UIKit
import CommonCrypto

class MBAShouShiVC: TSBaseVC {

    @IBOutlet weak var okBtn: UIButton!
    
    @IBOutlet weak var agingLB: UILabel!
    
    @IBOutlet weak var shouShiView: MBAShouShiView!
    
    @IBOutlet weak var userNameLB: UILabel!
    
    @objc var userName:String = ""
    
    lazy var hud:UIActivityIndicatorView = {
        let hud:UIActivityIndicatorView = UIActivityIndicatorView.init(style: .large)
        hud.frame = CGRect(x: self.view.bounds.size.width/2 - 50, y: self.view.bounds.size.height/2 - 50, width: 100, height: 100)
        hud.hidesWhenStopped = true
        hud.color = .label
        self.view.addSubview(hud)
        return hud
    }()
    @objc enum FunctionType:Int {
        case login  = 1
        case regest = 2
    }
    
    @objc var funcType:FunctionType = .regest
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "手势密码"
        self.okBtn.isHidden = true
        self.agingLB.isHidden = true
        weak var weakSelf = self
        self.shouShiView.callBack = { status, pass in
            if status == .chenggong {
                weakSelf?.agingLB.isHidden = true
                weakSelf?.okBtn.isHidden = false
                return
            }
            if status == .zaihuizhi {
                weakSelf?.agingLB.text = "请再绘制一次"
            }
            if status == .xiaoyusi {
                weakSelf?.agingLB.text = "至少绘制4个点"
            }
            if status == .diff {
                weakSelf?.agingLB.text = "两次绘制不相同"
            }
            weakSelf?.agingLB.isHidden = false
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
                weakSelf?.agingLB.isHidden = true
            }
        }
        self.shouShiView.funcType = self.funcType
        if self.funcType == .login {
            self.userNameLB.text = self.userName
        }
    }
    
    //MARK:--确认
    @IBAction func okAction(_ sender: UIButton) {
        
        if self.funcType == .regest {
            self.hud.startAnimating()
            self.view.isUserInteractionEnabled = false
            UserDefaults.standard.set(self.shouShiView.pass, forKey: "SHpassword")
            UserDefaults.standard.synchronize()
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {[self] in
                self.view.isUserInteractionEnabled = true
                self.hud.stopAnimating()
                let alert = UIAlertController.init(title: "提示", message: "设置成功", preferredStyle: .alert)
                let ok = UIAlertAction.init(title: "确定", style: .default) { (action) in
                    self.navigationController?.popViewController(animated: true)
                }
                alert.addAction(ok)
                self.present(alert, animated: true, completion: nil)
            }
        }
        if self.funcType == .login {
            let pass:String = UserDefaults.standard.object(forKey: "SHpassword") as! String
            if self.shouShiView.pass == pass {
                self.dismiss(animated: true, completion: nil)
            } else {
                let alert = UIAlertController.init(title: "提示", message: "手势密码错误", preferredStyle: .alert)
                let ok = UIAlertAction.init(title: "确定", style: .default) { (action) in
                    self.shouShiView.reset()
                }
                alert.addAction(ok)
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    override var modalPresentationStyle: UIModalPresentationStyle {
        set {
            
        }
        get {
            return .fullScreen
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

class MBAShouShiView: UIView {
    
    enum ShouShiStatus:Int {
        case xiaoyusi  = 1
        case chenggong = 2
        case diff      = 3
        case zaihuizhi = 4
    }
    
    var funcType:MBAShouShiVC.FunctionType = .regest
    
    let lineLayer = CAShapeLayer.init()
    let linePath:UIBezierPath = UIBezierPath.init()
    
    var array:Array<SSBtn> = []
    var btns:Array<SSBtn> = []
    var subs:Array<UIView> = []
    
    var callBack:((_ status:ShouShiStatus,_ password:String) -> (Void))?
    var pass:String = ""
    private var sucCount:Int = 1
    override func awakeFromNib() {
        super.awakeFromNib()
        for _:Int in 0..<9 {
            let sub:UIView = UIView.init()
            sub.backgroundColor = UIColor(red: 239.0/255.0, green: 239.0/255.0, blue: 239.0/255.0, alpha: 1.0)
            self.addSubview(sub)
            self.subs.append(sub)
        }
        for i:Int in 0..<9 {
            let btn:SSBtn = SSBtn.init(frame: .zero)
            btn.isSelected = false
            btn.pass = i
            self.addSubview(btn)
            self.btns.append(btn)
        }
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        self.setBtnFrame()
    }
    func setBtnFrame() {
        let count = self.btns.count
        let cols = 3
        var x: CGFloat = 0
        var y: CGFloat = 0
        let w: CGFloat = 70
        let h: CGFloat = 70
        let margin = (self.bounds.size.width - CGFloat(cols) * w) / (CGFloat(cols) + 1)
        var col: CGFloat = 0
        var row : CGFloat = 0
        for i in 0..<count {
            col = CGFloat(i % cols)
            row = CGFloat(i / cols)
            x = margin + (w + margin) * col
            y = margin + (w + margin) * row
            let btn = self.btns[i]
            btn.frame = CGRect(x: x, y: y, width: w, height: h)
            let sub = self.subs[i]
            sub.frame = CGRect(x: x, y: y, width: w, height: h)
            sub.layer.cornerRadius = w/2
            sub.layer.masksToBounds = true
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        let touch:UITouch = touches.randomElement()!
        let point:CGPoint = touch.location(in: self)
        for i:Int in 0..<self.btns.count {
            let btn:SSBtn = self.btns[i]
            if btn.frame.contains(point) {
                if !self.array.contains(btn) {
                    self.array.append(btn)
                    btn.isSelected = true
                    btn.setNeedsDisplay()
                    self.setNeedsDisplay()
                }
            }
        }
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        let touch:UITouch = touches.randomElement()!
        let point:CGPoint = touch.location(in: self)
        for i:Int in 0..<self.btns.count {
            let btn:SSBtn = self.btns[i]
            if btn.frame.contains(point) {
                if !self.array.contains(btn) {
                    self.array.append(btn)
                    btn.isSelected = true
                    btn.setNeedsDisplay()
                    self.setNeedsDisplay()
                } else {
                    let lasBtn:SSBtn = self.array.last!
                    if lasBtn.pass != btn.pass {
                        self.array.append(btn)
                        btn.isSelected = true
                        btn.setNeedsDisplay()
                        self.setNeedsDisplay()
                    }
                }
            }
        }
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        if self.array.count >= 4 {
            var pass:String = ""
            for i:Int in 0 ..< self.array.count {
                let btn = self.array[i]
                pass = pass + String(btn.pass)
            }
            if self.pass.count == 0 {
                self.pass = pass
                if self.funcType == .login {
                    self.isUserInteractionEnabled = false
                    self.pass = pass.md5
                    if self.callBack != nil {
                        self.callBack!(.chenggong,self.pass)
                    }
                    return
                }
                if self.funcType == .regest {
                    if self.callBack != nil {
                        self.callBack!(.zaihuizhi,"")
                    }
                }
            } else {
                if self.funcType == .regest {
                    if self.pass != pass {
                        if self.callBack != nil {
                            self.callBack!(.diff,"")
                        }
                    } else {
                        self.isUserInteractionEnabled = false
                        self.pass = pass.md5
                        if self.callBack != nil {
                            self.callBack!(.chenggong,self.pass)
                        }
                        return
                    }
                }
            }
            for i:Int in 0 ..< self.array.count {
                let btn = self.array[i]
                btn.isSelected = false
                btn.setNeedsDisplay()
            }
            self.array.removeAll()
            self.setNeedsDisplay()
            
        } else {
            for btn in self.array {
                btn.isSelected = false
                btn.setNeedsDisplay()
            }
            self.array.removeAll()
            if self.callBack != nil {
                self.callBack!(.xiaoyusi,"")
            }
            self.setNeedsDisplay()
        }
    }
    
    func reset() {
        self.isUserInteractionEnabled = true
        self.pass = ""
        for i:Int in 0 ..< self.array.count {
            let btn = self.array[i]
            btn.isSelected = false
            btn.setNeedsDisplay()
        }
        self.array.removeAll()
        self.setNeedsDisplay()
    }
    
    override func draw(_ rect: CGRect) {
        
        if self.array.count == 0 {
            self.linePath.removeAllPoints()
            self.lineLayer.removeFromSuperlayer()
        }else {
            for i:Int in 0 ..< self.array.count {
                let btn:SSBtn = self.array[i]
                let point = btn.center
                if i == 0 {
                    self.linePath.move(to: point)
                }else {
                    self.linePath.addLine(to: point)
                }
            }
        }
        self.lineLayer.removeFromSuperlayer()
        self.lineLayer.frame = self.bounds
        self.lineLayer.path = self.linePath.cgPath
        self.lineLayer.lineWidth = 2
        self.lineLayer.lineCap = .round
        self.lineLayer.lineJoin = .round
        self.lineLayer.fillColor = UIColor.clear.cgColor
        self.lineLayer.strokeColor = UIColor(red: 73.0/255.0, green: 198.0/255.0, blue: 250.0/255.0, alpha: 1.0).cgColor
        self.layer.insertSublayer(self.lineLayer, at: 9)
    }
}

class SSBtn: UIControl {
    
    var pass:Int = 0
    lazy var imageView: UIImageView = {
        let imageView = UIImageView.init(image: UIImage.init(named: "ssd"))
        imageView.frame = CGRect(x: 15, y: 15, width: 40, height: 40)
        imageView.isHidden = true
        return imageView
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
        self.isUserInteractionEnabled = false
        self.addSubview(self.imageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.bounds.size.width/2
        self.layer.masksToBounds = true
    }
    private var tp:Bool = false
    override var isSelected: Bool {
        set {
            self.tp = newValue
            self.imageView.isHidden = !self.tp
        }
        get {
            return self.tp
        }
    }
    /*
    var path:UIBezierPath = UIBezierPath.init()
    var shLayer:CAShapeLayer = CAShapeLayer.init()
    override func draw(_ rect: CGRect) {
        if self.isSelected {
            self.path.addArc(withCenter: CGPoint(x: self.bounds.size.width/2, y: self.bounds.size.height/2), radius: 20, startAngle: 0, endAngle: CGFloat(2 * Double.pi), clockwise: true)
            self.shLayer.removeFromSuperlayer()
            self.shLayer.path = self.path.cgPath
            self.shLayer.frame = self.bounds
            self.shLayer.lineWidth = 2
            self.shLayer.lineCap = .round
            self.shLayer.lineJoin = .round
            self.shLayer.fillColor = UIColor(red: 73.0/255.0, green: 198.0/255.0, blue: 250.0/255.0, alpha: 1.0).cgColor
            self.shLayer.strokeColor = UIColor(red: 73.0/255.0, green: 198.0/255.0, blue: 250.0/255.0, alpha: 1.0).cgColor
            self.shLayer.shadowColor = UIColor.white.cgColor
            self.shLayer.shadowOffset = CGSize(width: 0.5, height: 0.5)
            self.shLayer.shadowRadius = 20
            self.shLayer.shadowOpacity = 0.7
            self.layer.addSublayer(self.shLayer)
            
        } else {
            self.shLayer.removeFromSuperlayer()
        }
    }
 */
}
extension String {
    /// MD5加密
    func getMd5() -> String {
        let str = self.cString(using: String.Encoding.utf8)
        let strLen = CUnsignedInt(self.lengthOfBytes(using: String.Encoding.utf8))
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen)
        CC_MD5(str!, strLen, result)
        let hash = NSMutableString()
        for i in 0..<digestLen {
            hash.appendFormat("%02x", result[i])
        }
        result.deallocate()
        return String(hash)
    }
    /// MD5加密
    var md5: String! {
        return self.getMd5()
    }
    // 16位手势密码
    var pass16: String {
        return String(self.md5.prefix(16))
    }
}
