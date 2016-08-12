//
//	iOS培训
//		小码哥
//		Chen Chen @ August 10th, 2016
//

import UIKit
import Cartography

class PopoverViewController: UIViewController {

    // 背景图片视图
    var backgroundView = UIImageView()
    // 表格视图
    var tableView = UITableView()
    
    // MARK: - 系统方法
    
    /**
     视图已经加载方法
     */
    override func viewDidLoad() {
        
        super.viewDidLoad()
    
        setupUI()
    }
    
    /**
     初始化UI方法
     */
    func setupUI() {
        
        backgroundView.image = UIImage(named: "popover_background")!.resizableImageWithCapInsets(UIEdgeInsets(top: 25, left: 0, bottom: 25, right: 0), resizingMode: UIImageResizingMode.Stretch)
        view.addSubview(backgroundView)
        
        view.addSubview(tableView)
        
        constrain(backgroundView, tableView) { (backgroundView, tableView) in
            backgroundView.edges == inset(backgroundView.superview!.edges, 0)
            tableView.edges == inset(backgroundView.edges, kViewPadding)
        }
    }

}
