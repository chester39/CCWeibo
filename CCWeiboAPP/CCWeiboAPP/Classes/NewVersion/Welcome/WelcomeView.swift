//
//	iOS培训
//		小码哥
//		Chen Chen @ August 22nd, 2016
//

import UIKit

import Cartography

class WelcomeView: UIView {
    
    // 背景图片视图
    private var backgroundView = UIImageView()
    // 头像图片视图
    var avatarView = UIImageView()
    // 标题标签
    var textLabel = UILabel(text: "", fontSize: 20, lines: 0)
    // 变化约束组
    private var group = ConstraintGroup()
    
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
        
        backgroundView.image = UIImage(named: "ad_background")
        addSubview(backgroundView)
        
        assert(UserAccount.loadUserAccount() != nil, "必须授权之后才能显示欢迎界面")
        
        avatarView.layer.cornerRadius = 45
        avatarView.clipsToBounds = true
        guard let url = NSURL(string: UserAccount.loadUserAccount()!.avatarLarge!) else {
            return
        }
        
        avatarView.sd_setImageWithURL(url)
        addSubview(avatarView)
        
        guard let userName = UserAccount.loadUserAccount()!.screenName else {
            return
        }
        
        textLabel.text = "欢迎回来, \(userName)"
        textLabel.textAlignment = NSTextAlignment.Center
        textLabel.alpha = 0.0
        addSubview(textLabel)
        
        constrain(backgroundView) { (backgroundView) in
            backgroundView.edges == inset(backgroundView.superview!.edges, 0)
        }
        
        constrain(avatarView, textLabel) { (avatarView, textLabel) in
            avatarView.width == 90
            avatarView.height == 90
            
            textLabel.top == avatarView.bottom + kViewMargin
            
            align(centerX: avatarView.superview!, avatarView, textLabel)
        }
        
        constrain(avatarView, replace: group) { (avatarView) in
            avatarView.bottom == avatarView.superview!.bottom - kViewDistance
        }
    }
    
    /**
     开始动画方法
     */
    func startAnimation() {
        
        constrain(avatarView, replace: group) { (avatarView) in
            avatarView.bottom == avatarView.superview!.top + kViewDistance
        }
        
        UIView.animateWithDuration(1.5, animations: {
            self.layoutIfNeeded()
        }) { (true) in
            UIView.animateWithDuration(1.0, animations: {
                self.textLabel.alpha = 1.0
                }, completion: { (true) in
                    NSNotificationCenter.defaultCenter().postNotificationName(kSwitchRootViewController, object: true)
            })
        }
    }

}
