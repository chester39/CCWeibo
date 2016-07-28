//
//	iOS培训
//		小码哥
//		Chen Chen @ July 26th, 2016
//

import UIKit

class VisitorView: UIView {
    
    /**
     注册按钮
     */
    var registerButton = UIButton()
    /**
     登录按钮
     */
    var loginButton = UIButton()
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
    init(frame: CGRect, iconName: String, title: String) {
        
        super.init(frame: frame)
        
        let margin: CGFloat = 10
        
        let rotationWidth: CGFloat =  175
        let rotationHeight: CGFloat =  175
        let rotationX: CGFloat = (frame.origin.x + frame.size.width - rotationWidth) * 0.5
        let rotationY: CGFloat = (frame.origin.y + frame.size.height - rotationHeight) * 0.5
        rotationView.frame = CGRectMake(rotationX, rotationY, rotationWidth, rotationHeight)
        rotationView.image = UIImage(named: "visitordiscover_feed_image_smallicon")
        addSubview(rotationView)
        
        let iconWidth: CGFloat =  94
        let iconHeight: CGFloat =  90
        let iconX: CGFloat = (frame.origin.x + frame.size.width - iconWidth) * 0.5
        let iconY = rotationY
        iconView.frame = CGRectMake(iconX, iconY, iconWidth, iconHeight)
        iconView.image = UIImage(named: iconName)
        addSubview(iconView)
        
        let titleWidth: CGFloat = 220
        let titleHeight: CGFloat = 30
        let titleX: CGFloat = (frame.origin.x + frame.size.width - titleWidth) * 0.5
        let titleY = iconY + margin * 3
        titleLabel.frame = CGRectMake(titleX, titleY, titleWidth, titleHeight)
        titleLabel.numberOfLines = 0
        titleLabel.font = UIFont.systemFontOfSize(17)
        titleLabel.text = title
        addSubview(titleLabel)
        
        let registerWidth: CGFloat = 100
        let registerHeight: CGFloat = 34
        let registerX = titleX
        let registerY = titleY + margin
        registerButton.frame = CGRectMake(registerX, registerY, registerWidth, registerHeight)
        registerButton.titleLabel?.text = "注册"
        registerButton.titleLabel?.textColor = UIColor.orangeColor()
        registerButton.setBackgroundImage(UIImage(named: "common_button_white_disable"), forState: UIControlState.Normal)
        addSubview(registerButton)
        
        let loginWidth = registerWidth
        let loginHeight = registerHeight
        let loginX = registerX + margin * 2
        let loginY = registerY
        loginButton.frame = CGRectMake(loginX, loginY, loginWidth, loginHeight)
        loginButton.titleLabel?.text = "登录"
        loginButton.setBackgroundImage(UIImage(named: "common_button_white_disable"), forState: UIControlState.Normal)
        addSubview(loginButton)
        
    }
    
    /**
     必需初始化方法
     */
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}