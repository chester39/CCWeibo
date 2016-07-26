//
//	iOS培训
//		小码哥
//		Chen Chen @ July 26th, 2016
//

import UIKit

class BaseTableViewController: UITableViewController {

    /**
     用户是否登录
     */
    var isLogin = false
    /**
     访客视图
     */
    var vistorView = VisitorView()
    
    // MARK: - 系统方法
    
    /**
     读取视图方法
     */
    override func loadView() {
        
        isLogin ? super.loadView() : installVisitorView()
    }
    
    /**
     视图已经加载方法
     */
    override func viewDidLoad() {
        
        super.viewDidLoad()
    }
    
    /**
     收到内存警告方法
     */
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - 自定义方法
    
    /**
     设置访客视图方法
     */
    private func installVisitorView() {
        
        
        
    }
}
