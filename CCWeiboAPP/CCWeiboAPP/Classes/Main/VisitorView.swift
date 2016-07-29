//
//	iOS培训
//		小码哥
//		Chen Chen @ July 26th, 2016
//

import UIKit

let kMargin: CGFloat = 10

class VisitorView: UIView {
    
    /**
     注册按钮
     */
    var registerButton = UIButton(type: UIButtonType.Custom)
    /**
     登录按钮
     */
    var loginButton = UIButton(type: UIButtonType.Custom)
    /**
     旋转视图
     */
    var rotationView = UIImageView()
    /**
     图标按钮
     */
    var iconView = UIImageView()
    /**
     文字标签
     */
    var titleLabel = UILabel()

    // MARK: - 初始化方法
    
    /**
     自定义初始化方法
     */
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        setupUI()
    }
    
    /**
     必需初始化方法
     */
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setupUI() {
        
        let rotationWidth: CGFloat =  175
        let rotationHeight: CGFloat =  175
        let rotationX: CGFloat = (frame.origin.x + frame.size.width - rotationWidth) * 0.5
        let rotationY: CGFloat = (frame.origin.y + frame.size.height - rotationHeight) * 0.5
        rotationView.frame = CGRect(x: rotationX, y: rotationY, width: rotationWidth, height: rotationHeight)
        rotationView.image = UIImage(named: "visitordiscover_feed_image_smallicon")
        addSubview(rotationView)
        
        let iconWidth: CGFloat =  94
        let iconHeight: CGFloat =  90
        let iconX: CGFloat = (frame.origin.x + frame.size.width - iconWidth) * 0.5
        let iconY = rotationY + kMargin * 3
        iconView.frame = CGRect(x: iconX, y: iconY, width: iconWidth, height: iconHeight)
        addSubview(iconView)
        
        let titleWidth: CGFloat = 220
        let titleHeight: CGFloat = 80
        let titleX: CGFloat = (frame.origin.x + frame.size.width - titleWidth) * 0.5
        let titleY = iconY
        titleLabel.frame = CGRect(x: titleX, y: titleY, width: titleWidth, height: titleHeight)
        titleLabel.numberOfLines = 0
        titleLabel.font = UIFont.systemFontOfSize(17)
        addSubview(titleLabel)
        
        let registerWidth: CGFloat = 100
        let registerHeight: CGFloat = 34
        let registerX = titleX
        let registerY = titleY + titleHeight + kMargin
        registerButton.frame = CGRect(x: registerX, y: registerY, width: registerWidth, height: registerHeight)
        registerButton.setTitle("注册", forState: UIControlState.Normal)
        registerButton.setTitleColor(UIColor.orangeColor(), forState: UIControlState.Normal)
        registerButton.titleLabel?.font = UIFont.systemFontOfSize(15)
        registerButton.setBackgroundImage(UIImage(named: "common_button_white_disable"), forState: UIControlState.Normal)
        addSubview(registerButton)
        
        let loginWidth = registerWidth
        let loginHeight = registerHeight
        let loginX = registerX + registerWidth + kMargin
        let loginY = registerY
        loginButton.frame = CGRect(x: loginX, y: loginY, width: loginWidth, height: loginHeight)
        loginButton.setTitle("登录", forState: UIControlState.Normal)
        loginButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        loginButton.titleLabel?.font = UIFont.systemFontOfSize(15)
        loginButton.setBackgroundImage(UIImage(named: "common_button_white_disable"), forState: UIControlState.Normal)
        addSubview(loginButton)
    }
    
    /**
     设置访客视图信息方法
     */
    func setupVisitorInformation(iconName: String?, title: String) {
        
        titleLabel.text = title
        guard let name = iconName else {
            
            startAnimation()
            return
        }
        rotationView.hidden = true
        iconView.image = UIImage(named: name)
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

}