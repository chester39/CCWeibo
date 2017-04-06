//
//  VisitorView.swift
//      CCWeiboSwiftApp
//		Chen Chen @ November 18th, 2016
//

import UIKit

import Cartography

class VisitorView: UIView {

    /// 注册按钮
    var registerButton = UIButton(type: .system)
    /// 登录按钮
    var loginButton = UIButton(type: .system)
    /// 旋转视图
    private var rotationView = UIImageView()
    /// 图标按钮
    private var iconView = UIImageView()
    /// 文字标签
    private var textLabel = UILabel(text: "", fontSize: 18, lines: 0)
    
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
        
        backgroundColor = kVistorBackgroundColor
        
        rotationView.image = UIImage(named: "visitordiscover_feed_image_smallicon")
        addSubview(rotationView)
        
        iconView.image = UIImage(named: "visitordiscover_feed_image_house" )
        addSubview(iconView)
        
        textLabel.textAlignment = .center
        addSubview(textLabel)
        
        let buttonImage = UIImage(named: "common_button_white_disable")?.resizableImage(withCapInsets: UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5), resizingMode: .stretch)
        
        registerButton.setTitle("注册", for: .normal)
        registerButton.setTitleColor(kMainColor, for: .normal)
        registerButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        registerButton.setBackgroundImage(buttonImage, for: .normal)
        addSubview(registerButton)
        
        loginButton.setTitle("登录", for: .normal)
        loginButton.setTitleColor(kCommonDarkColor, for: .normal)
        loginButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        loginButton.setBackgroundImage(buttonImage, for: .normal)
        addSubview(loginButton)
    }
    
    /**
     初始化约束方法
     */
    private func setupConstraints() {
        
        constrain(rotationView) { rotationView in
            rotationView.center == rotationView.superview!.center
        }
        
        constrain(iconView) { iconView in
            iconView.center == iconView.superview!.center
        }
        
        constrain(textLabel, rotationView) { textLabel, rotationView in
            textLabel.width == 220
            textLabel.centerX == rotationView.centerX
            textLabel.top == rotationView.bottom + kViewBorder
        }
        
        constrain(registerButton, textLabel) { registerButton, textLabel in
            registerButton.width == kViewStandard
            registerButton.top == textLabel.bottom + kViewBorder
            registerButton.left == textLabel.left
        }
        
        constrain(loginButton, textLabel) { loginButton, textLabel in
            loginButton.width == kViewStandard
            loginButton.top == textLabel.bottom + kViewBorder
            loginButton.right == textLabel.right
        }
    }
    
    /**
     开始动画方法
     */
    private func startAnimation() {
        
        let animation = CABasicAnimation(keyPath: "transform.rotation")
        animation.toValue = Double.pi * 2
        animation.duration = 5.0
        animation.repeatCount = MAXFLOAT
        animation.isRemovedOnCompletion = false
        
        rotationView.layer.add(animation, forKey: nil)
    }
    
    /**
     设置访客视图信息方法
     */
    func setupVisitorInformation(iconName: String?, title: String) {
        
        textLabel.text = title
        guard let name = iconName else {
            startAnimation()
            return
        }
        
        rotationView.isHidden = true
        iconView.image = UIImage(named: name)
    }

}
