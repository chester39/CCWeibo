//
//	iOS培训
//		小码哥
//		Chen Chen @ August 22nd, 2016
//

import UIKit

import Cartography
import SDWebImage

class WelcomeViewController: UIViewController {

    // 欢迎视图
    var welcomeView = WelcomeView(frame: kScreenFrame)
    
    // MARK: - 系统方法
    
    /**
     视图已经加载方法
     */
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        view = welcomeView
    }
    
    /**
     视图已经显示方法
     */
    override func viewDidAppear(animated: Bool) {
        
        super.viewDidAppear(animated)
        
        let group = ConstraintGroup()
        constrain(welcomeView.avatarView, replace: group) { (avatarView) in
            avatarView.bottom == avatarView.superview!.bottom - 180
        }
        
        constrain(welcomeView.avatarView, replace: group) { (avatarView) in
            
            avatarView.bottom == avatarView.superview!.top + 180
        }
        
        UIView.animateWithDuration(2.0, animations: { 
            self.view.layoutIfNeeded()
            }) { (true) in
                UIView.animateWithDuration(1.0, animations: {
                    self.welcomeView.textLabel.alpha = 1.0
                    }, completion: { (true) in
                        NSNotificationCenter.defaultCenter().postNotificationName(kSwitchRootViewController, object: true)
                })
        }
    }

}
