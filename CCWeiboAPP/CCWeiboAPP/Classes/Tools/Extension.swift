//
//	iOS培训
//		小码哥
//		Chen Chen @ July 25th, 2016
//

import Foundation
import UIKit

// MARK: - UIButton扩展方法

extension UIButton {
    
    /**
     便利初始化方法
     */
    convenience init(imageName: String, backgroundImageName: String) {
        
        self.init()
        setImage(UIImage(named: imageName), forState: UIControlState.Normal)
        setImage(UIImage(named: imageName + "_highlighted"), forState: UIControlState.Highlighted)
        setBackgroundImage(UIImage(named: backgroundImageName), forState: UIControlState.Normal)
        setBackgroundImage(UIImage(named: backgroundImageName + "_highlighted"), forState: UIControlState.Highlighted)
        
        sizeToFit()
    }
}
