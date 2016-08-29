//
//	iOS培训
//		小码哥
//		Chen Chen @ July 26th, 2016
//

import UIKit

import Cartography

class VisitorView: UIView {
    
    // 注册按钮
    var registerButton = UIButton()
    // 登录按钮
    var loginButton = UIButton()
    // 旋转视图
    private var rotationView = UIImageView()
    // 图标按钮
    private var iconView = UIImageView()
    // 文字标签
    private var textLabel = UILabel()

    // MARK: - 初始化方法
    
    /**
     自定义初始化方法
     */
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        setupUI()
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
    
        self.backgroundColor = UIColor(red: 232.0 / 255.0, green: 232.0 / 255.0, blue: 232.0 / 255.0, alpha: 1.0)
        
        rotationView.image = UIImage(named: "visitordiscover_feed_image_smallicon")
        addSubview(rotationView)
        
        iconView.image = UIImage(named: "visitordiscover_feed_image_house" )
        addSubview(iconView)

        textLabel.numberOfLines = 0
        textLabel.font = UIFont.systemFontOfSize(18)
        textLabel.textAlignment = NSTextAlignment.Center
        addSubview(textLabel)
        
        let buttonImage = UIImage(named: "common_button_white_disable")?.resizableImageWithCapInsets(UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5), resizingMode: UIImageResizingMode.Stretch)
        
        registerButton.setTitle("注册", forState: UIControlState.Normal)
        registerButton.setTitleColor(UIColor.orangeColor(), forState: UIControlState.Normal)
        registerButton.titleLabel?.font = UIFont.systemFontOfSize(15)
        registerButton.setBackgroundImage(buttonImage, forState: UIControlState.Normal)
        addSubview(registerButton)
        
        loginButton.setTitle("登录", forState: UIControlState.Normal)
        loginButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        loginButton.titleLabel?.font = UIFont.systemFontOfSize(15)
        loginButton.setBackgroundImage(buttonImage, forState: UIControlState.Normal)
        addSubview(loginButton)
        
        constrain(rotationView) { (rotationView) in
            rotationView.center == rotationView.superview!.center
        }
        
        constrain(iconView) { (iconView) in
            iconView.center == iconView.superview!.center
        }
        
        constrain(textLabel, rotationView) { (textLabel, rotationView) in
            textLabel.width == 220
            textLabel.centerX == rotationView.centerX
            textLabel.top == rotationView.bottom + kViewMargin
        }
        
        constrain(registerButton, textLabel) { (registerButton, textLabel) in
            registerButton.width == 100
            registerButton.top == textLabel.bottom + kViewMargin
            registerButton.left == textLabel.left
        }
        
        constrain(loginButton, textLabel) { (loginButton, textLabel) in
            loginButton.width == 100
            loginButton.top == textLabel.bottom + kViewMargin
            loginButton.right == textLabel.right
        }
    }
    
    /**
     开始动画方法
     */
    private func startAnimation() {
        
        let animation = CABasicAnimation(keyPath: "transform.rotation")
        animation.toValue = M_PI * 2
        animation.duration = 5.0
        animation.repeatCount = MAXFLOAT
        animation.removedOnCompletion = false
        
        rotationView.layer.addAnimation(animation, forKey: nil)
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
        
        rotationView.hidden = true
        iconView.image = UIImage(named: name)
    }
    
}