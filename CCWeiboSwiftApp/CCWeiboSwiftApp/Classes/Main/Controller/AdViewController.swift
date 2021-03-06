//
//  AdViewController.swift
//      CCWeiboSwiftApp
//		Chen Chen @ November 23rd, 2016
//

import UIKit

import Cartography

class AdViewController: UIViewController {
    
    /// 广告图片视图
    private var adView = UIImageView()
    /// 跳过按钮
    private var passButton = UIButton(type: .custom)
    /// 定时器
    private var timer = Timer()
    /// 倒计时
    private var countdown: TimeInterval = 5.0
    
    // MARK: - 系统方法
    
    /**
     视图已经加载方法
     */
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        setupUI()
        setupConstraints()
    }
    
    // MARK: - 界面方法
    
    /**
     初始化界面方法
     */
    private func setupUI() {
        
        adView.image = UIImage(named: "advertisement")
        adView.contentMode = .scaleAspectFit
        let imageGesture = UITapGestureRecognizer(target: self, action: #selector(adViewDidClick(gesture:)))
        adView.isUserInteractionEnabled = true
        adView.addGestureRecognizer(imageGesture)
        view.addSubview(adView)
        
        passButton.setTitle("跳过 5 s", for: .normal)
        passButton.layer.cornerRadius = kViewEdge
        passButton.layer.masksToBounds = true
        passButton.layer.borderWidth = 1.0
        passButton.layer.borderColor = kRetweetStatusBackgroundColor.cgColor
        passButton.layer.backgroundColor = kRetweetStatusBackgroundColor.cgColor
        passButton.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        passButton.setTitleColor(kCommonDarkColor, for: .normal)
        passButton.addTarget(self, action: #selector(passAdvertisement), for: .touchUpInside)
        view.addSubview(passButton)
        
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            self.passAdvertisement()
        }
    }
    
    /**
     初始化约束方法
     */
    private func setupConstraints() {
        
        constrain(adView) { adView in
            adView.edges == inset(adView.superview!.edges, 0)
        }
        
        constrain(passButton) { passButton in
            passButton.width == kViewAdapter
            passButton.height == kViewMargin
            passButton.top == passButton.superview!.top + kViewBorder
            passButton.right == passButton.superview!.right - kViewBorder
        }
    }
    
    /**
     跳过广告方法
     */
    @objc private func passAdvertisement() {
        
        timer.invalidate()
        NotificationCenter.default.post(name: Notification.Name(kRootViewControllerSwitched), object: true)
    }
    
    // MARK: - 时间方法
    
    /**
     更新时间方法
     */
    @objc private func updateTime() {
        
        countdown -= 1.0
        passButton.setTitle(String(format: "跳过 %.0f s", countdown), for: .normal)
        if countdown == 0.0 {
            timer.invalidate()
        }
    }
    
    /**
     广告点击方法
     */
    @objc private func adViewDidClick(gesture: UITapGestureRecognizer) {
        
        timer.invalidate()
        let urlString = "http://chesterhupu.kuaizhan.com/"
        let webVC = WebViewController()
        webVC.loadWithURLString(urlString: urlString)
        navigationController?.pushViewController(webVC, animated: true)
    }

}
