//
//	iOS培训
//		小码哥
//		Chen Chen @ July 21st, 2016
//

import UIKit

class DiscoverTableViewController: BaseTableViewController {

    // MARK: - 系统方法
    
    /**
     视图已经加载方法
     */
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        if isLogin == false {
            vistorView.setupVisitorInformation("visitordiscover_image_message", title: "登录后，最新、最热微博尽在掌握，不再会与时事潮流擦肩而过")
            return
        }
    }
    
}
