//
//  WelcomeView.swift
//      CCWeiboSwiftApp
//		Chen Chen @ November 25th, 2016
//


import UIKit

import Cartography

class WelcomeView: UIView {
    
    /// 背景图片视图
    private var backgroundView = UIImageView()
    /// 头像图片视图
    private var avatarView = UIImageView()
    /// 标题标签
    private var textLabel = UILabel(text: "", fontSize: 20, lines: 0)
    /// 变化约束组
    private var group = ConstraintGroup()
    
    // MARK: - 初始化方法
    
    /**
     自定义初始化方法
     */
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        setupUI()
        setupConstraints()
    }
    
    /**
     数据解码XIB初始化方法
     */
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 界面方法
    
    /**
     初始化界面方法
     */
    private func setupUI() {
        
        backgroundView.image = UIImage(named: "ad_background")
        addSubview(backgroundView)
        
        assert(UserAccount.loadUserAccount() != nil, "必须授权之后才能显示欢迎界面")
        guard let user = UserAccount.loadUserAccount() else {
            return
        }
        
        avatarView.layer.cornerRadius = 45.0
        avatarView.clipsToBounds = true
        avatarView.sd_setImage(with: URL(string: user.avatarLarge!))
        addSubview(avatarView)
        
        textLabel.text = "欢迎回来, \(user.screenName!)"
        textLabel.textAlignment = .center
        textLabel.alpha = 0.0
        addSubview(textLabel)
    }
    
    /**
     初始化约束方法
     */
    private func setupConstraints() {
        
        constrain(backgroundView) { backgroundView in
            backgroundView.edges == inset(backgroundView.superview!.edges, 0)
        }
        
        constrain(avatarView, textLabel) { avatarView, textLabel in
            avatarView.width == 90
            avatarView.height == 90
            
            textLabel.top == avatarView.bottom + kViewBorder
            
            align(centerX: avatarView.superview!, avatarView, textLabel)
        }
        
        constrain(avatarView, replace: group) { avatarView in
            avatarView.bottom == avatarView.superview!.bottom - kViewDistance
        }
    }
    
    /**
     开始动画方法
     */
    func startAnimation() {
        
        constrain(avatarView, replace: group) { avatarView in
            avatarView.bottom == avatarView.superview!.top + kViewDistance
        }
        
        UIView.animate(withDuration: 1.0, animations: {
            self.layoutIfNeeded()
        }) { _ in
            UIView.animate(withDuration: 1.0, animations: {
                self.textLabel.alpha = 1.0
            }, completion: { _ in
                NotificationCenter.default.post(name: Notification.Name(kRootViewControllerSwitched), object: true)
            })
        }
    }

}
