//
//  TSPlayerView.swift
//  TS
//
//  Created by shg on 2021/2/15.
//  Copyright © 2021 GR. All rights reserved.
//

import UIKit
import AVKit

class TSPlayerView: UIView {

    var player:AVPlayer? {
        set {
            (self.layer as! AVPlayerLayer).player = newValue
        }
        get {
            return (self.layer as! AVPlayerLayer).player
        }
    }
    
    override class var layerClass: AnyClass {
        get {
            return AVPlayerLayer.self
        }
    }
    
    var hisArr:Array<Dictionary<String,String>> = Array<Dictionary<String,String>>.init()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.systemBackground
        (self.layer as! AVPlayerLayer).videoGravity = .resize
        self.addSubs()
        let tap:UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(tapAction(sender:)))
        self.addGestureRecognizer(tap)
        NotificationCenter.default.addObserver(self, selector: #selector(enterBack(sender:)), name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(enterFront(sender:)), name: UIApplication.willEnterForegroundNotification, object: nil)
        
        let arr:Array<Dictionary<String,String>> = TSarchiver.uar(Array.init()) as Array<Dictionary<String, String>>
        for dic:Dictionary<String,String> in arr {
            self.hisArr.append(dic)
        }
    }
    
    var playingTT = false
    @objc func enterBack(sender:Notification) {
        self.playingTT = self.playing
        if self.playingTT {
            self.play(sender: self.playBtn)
        }
    }
    
    @objc func enterFront(sender:Notification) {
        if self.playingTT {
            self.play(sender: self.playBtn)
        }
    }
    
    var viewIsShow:Bool = true
    @objc func tapAction(sender:UITapGestureRecognizer) {
        if !self.viewIsShow {
            self.hiddenView(hidden: false, anmi: true)
        }
    }
    
    var topView:UIView!
    var closeBtn:CloseBtn!
    var titleLB:UILabel!
    var bottomView:UIView!
    var hud:UIActivityIndicatorView!
    var playing:Bool = false
    var playBtn:PlayControlBtn!
    var upBtn:PlayControlBtn!
    var downBtn:PlayControlBtn!
    var source:Array<PlayModel> = Array<PlayModel>.init()
    var currenttimeLB:UILabel!
    var altimeLB:UILabel!
    var progressView:GGProgressView!
    var allBtn:UIButton!
    var currentModel:PlayModel?
    
    
    func addSubs() {
        self.hud = UIActivityIndicatorView.init(style: .large)
        self.hud.color = UIColor.label
        self.hud.hidesWhenStopped = true
        self.hud.startAnimating()
        self.addSubview(self.hud)
        self.topView = UIView.init(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: 50))
        self.topView.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        self.addSubview(self.topView)
        self.closeBtn = CloseBtn.init(type: .custom)
        self.closeBtn.frame = CGRect(x: self.topView.bounds.size.width - 50, y: 5, width: 40, height: 40)
        self.closeBtn.addTarget(self, action: #selector(backAction(sender:)), for: .touchUpInside)
        self.topView.addSubview(self.closeBtn)
        self.titleLB = UILabel.init()
        self.titleLB.font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight(rawValue: 1.1))
        self.titleLB.textAlignment = .center
        self.titleLB.textColor = UIColor.white
        self.topView.addSubview(self.titleLB)
        self.bottomView = UIView.init()
        self.bottomView.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        self.addSubview(self.bottomView)
        self.upBtn = PlayControlBtn.init(type: .custom)
        self.upBtn.type = .up
        self.upBtn.addTarget(self, action: #selector(up(sender:)), for: .touchUpInside)
        self.bottomView.addSubview(self.upBtn)
        self.playBtn = PlayControlBtn.init(type: .custom)
        self.playBtn.type = .play
        self.playBtn.addTarget(self, action: #selector(play(sender:)), for: .touchUpInside)
        self.bottomView.addSubview(self.playBtn)
        self.downBtn = PlayControlBtn.init(type: .custom)
        self.downBtn.type = .dowm
        self.downBtn.addTarget(self, action: #selector(down(sender:)), for: .touchUpInside)
        self.bottomView.addSubview(self.downBtn)
        self.currenttimeLB = UILabel.init()
        self.currenttimeLB.font = UIFont.systemFont(ofSize: 12)
        self.currenttimeLB.textAlignment = .center
        self.currenttimeLB.textColor = .white
        self.currenttimeLB.text = "00:00"
        self.bottomView.addSubview(self.currenttimeLB)
        self.progressView = GGProgressView.init(frame: CGRect.zero, progressViewStyle: .allFillet)
        self.progressView.trackTintColor = .white
        self.progressView.progressTintColor = .lightGray
        self.bottomView.addSubview(self.progressView)
        self.altimeLB = UILabel.init()
        self.altimeLB.font = UIFont.systemFont(ofSize: 12)
        self.altimeLB.textAlignment = .center
        self.altimeLB.textColor = .white
        self.altimeLB.text = "00:00"
        self.bottomView.addSubview(self.altimeLB)
        self.allBtn = UIButton.init(type: .custom)
        self.allBtn.setTitle("全部", for: .normal)
        self.allBtn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        self.allBtn.setTitleColor(.white, for: .normal)
        self.allBtn.addTarget(self, action: #selector(showAll(sender:)), for: .touchUpInside)
        self.bottomView.addSubview(self.allBtn)
    }
    lazy var allView: AllView = {
        let view:AllView = AllView.init(source: self.source, frame: CGRect(x: self.bounds.size.width, y: 0, width: 250, height: self.bounds.size.height))
        view.backgroundColor = UIColor.black
        self.addSubview(view)
        view.callBack = {[self] (model) in
            self.currentModel = model
            self.titleLB.text = model.title
            let item:AVPlayerItem = AVPlayerItem.init(url: URL.init(string: model.playUrl)!)
            self.remObs()
            self.player?.replaceCurrentItem(with: item)
            self.player?.play()
            self.addObs()
            self.hud.startAnimating()
            self.save(model: self.currentModel!)
        }
        return view
    }()
    @objc func showAll(sender:UIButton) {
        UIView.animate(withDuration: 0.25) {[self] in
            self.allView.transform = CGAffineTransform.init(translationX: -250, y: 0)
        } completion: { (fin) in
            
        }

    }
    
    @objc func up(sender:PlayControlBtn) {
        if self.currentModel!.index > 0 {
            let model:PlayModel = self.source[self.currentModel!.index - 1]
            self.currentModel = model
            self.titleLB.text = model.title
            let item:AVPlayerItem = AVPlayerItem.init(url: URL.init(string: model.playUrl)!)
            self.remObs()
            self.player?.replaceCurrentItem(with: item)
            self.player?.play()
            self.addObs()
            self.hud.startAnimating()
            self.save(model: self.currentModel!)
        }
    }
    
    @objc func play(sender:PlayControlBtn) {
        if sender.type == .play {
            self.player?.play()
            self.playing = true
            sender.type = .supend
        }else if sender.type == .supend {
            self.player?.pause()
            self.playing = false
            sender.type = .play
        }
        sender.setNeedsDisplay()
    }
    
    func save(model:PlayModel) {
        let arr = self.hisArr.filter({$0["playUrl"] == model.playUrl})
        if arr.count == 0 {
            if model.title == "本地视频" {
                return
            }
            self.hisArr.append(["playUrl":model.playUrl,"title":model.title,"iconUrl":model.imgUrl])
        }
    }
    
    @objc func down(sender:PlayControlBtn) {
        if self.currentModel!.index + 1 < self.source.count {
            let model:PlayModel = self.source[self.currentModel!.index + 1]
            self.currentModel = model
            self.titleLB.text = model.title
            let item:AVPlayerItem = AVPlayerItem.init(url: URL.init(string: model.playUrl)!)
            self.remObs()
            self.player?.replaceCurrentItem(with: item)
            self.player?.play()
            self.addObs()
            self.hud.startAnimating()
            self.save(model: self.currentModel!)
        }
    }
    
    override func layoutSubviews() {
        self.hud.frame = CGRect(x: self.bounds.size.width/2 - 30, y: self.bounds.size.height/2 - 30, width: 60, height: 60)
        self.topView.frame = CGRect(x: 0, y: 0, width: self.bounds.size.width, height: 50)
        self.closeBtn.frame = CGRect(x: self.topView.bounds.size.width - 50, y: 5, width: 40, height: 40)
        self.titleLB.frame = CGRect(x: 50, y: 0, width: self.topView.bounds.size.width - 100, height: self.topView.bounds.size.height)
        self.bottomView.frame = CGRect(x: 0, y: self.bounds.size.height - 50, width: self.bounds.size.width, height: 50)
        self.upBtn.frame = CGRect(x: 30, y: 10, width: 30, height: 30)
        self.playBtn.frame = CGRect(x: 70, y: 5, width: 40, height: 40)
        self.downBtn.frame = CGRect(x: 120, y: 10, width: 30, height: 30)
        self.currenttimeLB.frame = CGRect(x: 170, y: 10, width: 60, height: 30)
        self.progressView.frame = CGRect(x: 230, y: 21, width: self.bottomView.bounds.size.width - 350, height: 8)
        self.progressView.progressViewStyle = .allFillet
        self.altimeLB.frame = CGRect(x: self.progressView.bounds.size.width + self.progressView.frame.origin.x, y: 10, width: 60, height: 30)
        self.allBtn.frame = CGRect(x: self.altimeLB.frame.origin.x + 60, y: 5, width: 40, height: 40)
    }
    
    func hiddenView(hidden:Bool,anmi:Bool) {
        if hidden {
            if anmi {
                DispatchQueue.main.asyncAfter(deadline: .now() + 5) {[self] in
                    UIView.animate(withDuration: 0.25) {[self] in
                        self.topView.alpha = 0
                        self.bottomView.alpha = 0
                    } completion: {[self] (fin) in
                        self.viewIsShow = false
                    }
                }
            } else {
                DispatchQueue.main.asyncAfter(deadline: .now() + 5) {[self] in
                    self.topView.alpha = 0
                    self.bottomView.alpha = 0
                    self.viewIsShow = false
                } 
            }
        } else {
            if anmi {
                UIView.animate(withDuration: 0.25) {[self] in
                    self.topView.alpha = 1.0
                    self.bottomView.alpha = 1.0
                } completion: {[self] (fin) in
                    self.viewIsShow = true
                    self.hiddenView(hidden: true, anmi: true)
                }
            } else {
                self.topView.alpha = 1.0
                self.bottomView.alpha = 1.0
                self.viewIsShow = true
                self.hiddenView(hidden: true, anmi: true)
            }
        }
    }
    var playbackTimeObserver:Any?
    func startPlay() {
        self.playing = true
        self.hud.stopAnimating()
        self.hiddenView(hidden: true,anmi: true)
        let duration:CMTime = (self.player?.currentItem!.duration)!
        let totalSecond:CGFloat = CGFloat(duration.value)/CGFloat(duration.timescale)
        self.altimeLB.text = self.convertTime(second: totalSecond)
        weak var weakSelf = self
        self.playbackTimeObserver = self.player?.addPeriodicTimeObserver(forInterval: CMTimeMake(value: 1, timescale: 1), queue: DispatchQueue.main, using: { (time) in
            let currentSecond:CGFloat = CGFloat((weakSelf?.player?.currentItem?.currentTime().value)!)/CGFloat((weakSelf?.player?.currentItem?.currentTime().timescale)!)
            weakSelf?.currenttimeLB.text = weakSelf?.convertTime(second: currentSecond)
            weakSelf?.progressView.currentProgress = currentSecond/totalSecond
        })
        self.playBtn.type = .supend
        self.playBtn.setNeedsDisplay()
    }
    
    func convertTime(second:CGFloat) -> String {
        let date:Date = Date.init(timeIntervalSince1970: TimeInterval(second))
        let dateFormatter:DateFormatter = DateFormatter.init()
        if second/3600 >= 1 {
            dateFormatter.dateFormat = "HH:mm:ss"
        } else {
            dateFormatter.dateFormat = "mm:ss"
        }
        let time:String = dateFormatter.string(from: date)
        return time
    }
    
    func failPlay() {
        self.hud.stopAnimating()
    }
    var closeBlock:(() -> ())?
    @objc func backAction(sender:UIButton) {
        self.player?.pause()
        if self.closeBlock != nil {
            self.closeBlock!()
        }
        DispatchQueue.global().async {[self] in
            TSarchiver.ar(self.hisArr)
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func play(with model:PlayModel) {
        self.startPlay(model: model)
    }
    
    func startPlay(model:PlayModel) {
        if model.title == "本地视频" {
            (self.layer as! AVPlayerLayer).videoGravity = .resizeAspect
        }
        self.currentModel = model
        let item:AVPlayerItem = AVPlayerItem.init(url: URL.init(string: model.playUrl)!)
        let player:AVPlayer = AVPlayer.init(playerItem: item)
        self.player = player
        self.player?.play()
        if model.title == "本地视频" {
            
        } else {
            UIView.animate(withDuration: 0.25) {[self] in
                self.transform = CGAffineTransform.init(rotationAngle: CGFloat(Double.pi/2))
            }
        }
        self.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.height, height: UIScreen.main.bounds.size.width)
        self.layer.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
        self.titleLB.text = model.title
        self.addObs()
        self.save(model: self.currentModel!)
    }
    
    func addObs() {
        self.player?.currentItem?.addObserver(self, forKeyPath: "status", options: .new, context: nil)
        self.player?.currentItem?.addObserver(self, forKeyPath: "loadedTimeRanges", options: .new, context: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(endPlay(sender:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
    }
    
    @objc func endPlay(sender:Notification) {
        self.player?.seek(to: .zero, completionHandler: {[self] (finished) in
            self.playing = false
            self.playBtn.type = .play
            self.playBtn.setNeedsDisplay()
        })
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "status" {
            let status:AVPlayerItem.Status = AVPlayerItem.Status.init(rawValue: change![.newKey] as! Int) ?? .failed
            if status == .readyToPlay {
                self.startPlay()
            } else {
                self.failPlay()
            }
        }
        if keyPath == "loadedTimeRanges" {
            let timeInterval:TimeInterval = self.availableDuration()
            let duration:CMTime = (self.player?.currentItem!.duration)!
            let totalDuration:CGFloat = CGFloat(CMTimeGetSeconds(duration))
            self.progressView.progress = Float(CGFloat(timeInterval)/totalDuration)
        }
    }
    
    func availableDuration() -> TimeInterval {
        let loadedTimeRanges = self.player?.currentItem?.loadedTimeRanges
        let timeRange:CMTimeRange = (loadedTimeRanges?.first!.timeRangeValue)!
        let startSeconds:Float = Float(CMTimeGetSeconds(timeRange.start))
        let durationSeconds:Float = Float(CMTimeGetSeconds(timeRange.duration))
        let result:TimeInterval = TimeInterval(startSeconds + durationSeconds)
        return result
    }
    
    func remObs() {
        self.player?.currentItem?.removeObserver(self, forKeyPath: "status")
        self.player?.currentItem?.removeObserver(self, forKeyPath: "loadedTimeRanges")
        NotificationCenter.default.removeObserver(self)
        if self.playbackTimeObserver != nil {
            self.player?.removeTimeObserver(self.playbackTimeObserver!)
        }
    }
    
    deinit {
        self.remObs()
    }
    
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}

class CloseBtn: UIButton {
    
    override func draw(_ rect: CGRect) {
        
        let bp = UIBezierPath.init()
        bp.move(to: CGPoint(x: 10, y: 10))
        bp.addLine(to: CGPoint(x: self.bounds.size.width - 10, y: self.bounds.size.height - 10))
        bp.lineWidth = 2.0
        bp.lineCapStyle = .round
        UIColor.white.set()
        bp.stroke()
        let bp1 = UIBezierPath.init()
        bp1.move(to: CGPoint(x: 10, y: self.bounds.size.height - 10))
        bp1.addLine(to: CGPoint(x: self.bounds.size.width - 10, y: 10))
        bp1.lineWidth = 2.0
        bp1.lineCapStyle = .round
        UIColor.white.set()
        bp1.stroke()
    }
}

class PlayControlBtn: UIButton {
    enum PlayControlBtnType:Int {
        case up   = 0
        case dowm = 1
        case play = 2
        case supend = 3
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.lightGray
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.bounds.size.width/2;
        self.layer.masksToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var type:PlayControlBtnType = .play
    override func draw(_ rect: CGRect) {
        if self.type == .play {
            let bp = UIBezierPath.init()
            bp.move(to: CGPoint(x: self.bounds.size.width/2 - 8, y: self.bounds.size.height/2 - 8))
            bp.addLine(to: CGPoint(x: self.bounds.size.width/2 - 8, y: self.bounds.size.height/2 + 8))
            bp.addLine(to: CGPoint(x: self.bounds.size.width/2 + 8, y: self.bounds.size.height/2))
            bp.lineWidth = 2.5
            bp.lineCapStyle = .round
            bp.lineJoinStyle = .miter
            UIColor.white.set()
            bp.close()
            bp.stroke()
        }
        if self.type == .supend {
            
            let bp = UIBezierPath.init()
            bp.move(to: CGPoint(x: self.bounds.size.width/2 - 6, y: self.bounds.size.height/2 - 8))
            bp.addLine(to: CGPoint(x: self.bounds.size.width/2 - 6, y: self.bounds.size.height/2 + 8))
            bp.lineWidth = 2.5
            bp.lineCapStyle = .round
            UIColor.white.set()
            bp.stroke()
            
            let bp1 = UIBezierPath.init()
            bp1.move(to: CGPoint(x: self.bounds.size.width/2 + 6, y: self.bounds.size.height/2 - 8))
            bp1.addLine(to: CGPoint(x: self.bounds.size.width/2 + 6, y: self.bounds.size.height/2 + 8))
            bp1.lineWidth = 2.5
            bp1.lineCapStyle = .round
            UIColor.white.set()
            bp1.stroke()
        }
        if self.type == .up {
            let bp = UIBezierPath.init()
            bp.move(to: CGPoint(x: self.bounds.size.width/2 + 5, y: self.bounds.size.height/2 - 5))
            bp.addLine(to: CGPoint(x: self.bounds.size.width/2 - 5, y: self.bounds.size.height/2))
            bp.addLine(to: CGPoint(x: self.bounds.size.width/2 + 5, y: self.bounds.size.height/2 + 5))
            bp.lineWidth = 2.5
            bp.lineCapStyle = .round
            UIColor.white.set()
            bp.stroke()
        }
        if self.type == .dowm {
            let bp = UIBezierPath.init()
            bp.move(to: CGPoint(x: self.bounds.size.width/2 - 5, y: self.bounds.size.height/2 - 5))
            bp.addLine(to: CGPoint(x: self.bounds.size.width/2 + 5, y: self.bounds.size.height/2))
            bp.addLine(to: CGPoint(x: self.bounds.size.width/2 - 5, y: self.bounds.size.height/2 + 5))
            bp.lineWidth = 2.5
            bp.lineCapStyle = .round
            UIColor.white.set()
            bp.stroke()
        }
    }
}

class PlayModel: NSObject{
    
    var title:String = ""
    var playUrl:String = ""
    var imgUrl:String = ""
    var index:Int = 0
    
    
}

class AllView: UIView {
    
    var callBack:((_ model:PlayModel) -> ())?
    init(source:Array<PlayModel>,frame:CGRect) {
        super.init(frame: frame)
        let scroll:AllScroll = AllScroll.init(source: source, frame: CGRect(x: 30, y: 0, width: Int(frame.size.width - 30), height: Int(frame.size.height)))
        self.addSubview(scroll)
        scroll.callBack = {[self] (model) in
            if self.callBack != nil {
                self.callBack!(model)
            }
        }
        let btn:UIButton = UIButton.init(type: .custom)
        btn.addTarget(self, action: #selector(close(sender:)), for: .touchUpInside)
        btn.frame = CGRect(x: 0, y: 0, width: 30, height: Int(frame.size.height))
        self.addSubview(btn)
    }
    
    @objc func close(sender:UIButton) {
        UIView.animate(withDuration: 0.25) {[self] in
            self.transform = CGAffineTransform.identity
        } completion: { (fin) in
        }
    }
    
    override func draw(_ rect: CGRect) {
        let bp:UIBezierPath = UIBezierPath.init()
        bp.move(to: CGPoint(x: 7, y: self.bounds.size.height/2 - 6))
        bp.addLine(to: CGPoint(x: 15, y: self.bounds.size.height/2))
        bp.addLine(to: CGPoint(x: 7, y: self.bounds.size.height/2 + 6))
        bp.lineWidth = 2.5
        bp.lineCapStyle = .round
        bp.lineJoinStyle = .round
        UIColor.white.set()
        bp.stroke()
        let bp1:UIBezierPath = UIBezierPath.init()
        bp1.move(to: CGPoint(x: 15, y: self.bounds.size.height/2 - 6))
        bp1.addLine(to: CGPoint(x: 23, y: self.bounds.size.height/2))
        bp1.addLine(to: CGPoint(x: 15, y: self.bounds.size.height/2 + 6))
        bp1.lineWidth = 2.5
        bp1.lineCapStyle = .round
        bp1.lineJoinStyle = .round
        UIColor.white.set()
        bp1.stroke()
        
        let bp2:UIBezierPath = UIBezierPath.init()
        bp2.move(to: CGPoint(x: 29, y: 0))
        bp2.addLine(to: CGPoint(x: 29, y: self.bounds.size.height))
        bp2.lineWidth = 1
        UIColor.white.set()
        bp2.stroke()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class AllScroll: UIScrollView {
    
    var source:Array<PlayModel> = Array<PlayModel>.init()
    init(source:Array<PlayModel>,frame:CGRect) {
        super.init(frame: frame)
        self.source = source
        for i:Int in 0 ..< self.source.count {
            let  model:PlayModel = self.source[i]
            let btn:UIButton = UIButton.init(type: .custom)
            btn.setTitle(model.title, for: .normal)
            btn.frame = CGRect(x: 0, y: i * 35, width: Int(frame.size.width), height: 35)
            btn.addTarget(self, action: #selector(btnAction(sender:)), for: .touchUpInside)
            btn.tag = 100 + i
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
            self.addSubview(btn)
        }
        self.contentSize = CGSize(width: Int(frame.size.width), height: 35 * self.source.count)
    }
    var callBack:((_ model:PlayModel) -> ())?
    @objc func btnAction(sender:UIButton) {
        let index:Int = sender.tag - 100
        let model:PlayModel = self.source[index]
        if self.callBack != nil {
            self.callBack!(model)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
