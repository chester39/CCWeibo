//
//	iOS培训
//		小码哥
//		Chen Chen @ July 25th, 2016
//

import UIKit

extension UIButton {
    
    /**
     便利初始化方法
     */
    convenience init(imageName: String, backgroundImageName: String) {
        
        self.init()
        setImage(UIImage(named: "tabbar_compose_icon_add"), forState: UIControlState.Normal)
        setImage(UIImage(named: "tabbar_compose_icon_add_highlighted"), forState: UIControlState.Highlighted)
        setBackgroundImage(UIImage(named: "tabbar_compose_button"), forState: UIControlState.Normal)
        setBackgroundImage(UIImage(named: "tabbar_compose_button_highlighted"), forState: UIControlState.Highlighted)
        
        sizeToFit()
    }
}
