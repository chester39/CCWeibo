//
//	iOS培训
//		小码哥
//		Chen Chen @ July 21st, 2016
//

import UIKit

class HomeTableViewController: BaseTableViewController {

    // MARK: - 系统方法
    
    /**
     视图已经加载方法
     */
    override func viewDidLoad() {
        
        super.viewDidLoad()
        if isLogin == false {
            
            vistorView.setupVisitorInformation(nil, title: "关注一些人后，再回到这里看看有什么惊喜")
            return
        }
        
    }
    
 }
