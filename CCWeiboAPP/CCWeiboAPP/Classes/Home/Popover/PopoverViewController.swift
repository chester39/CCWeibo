//
//	iOS培训
//		小码哥
//		Chen Chen @ August 10th, 2016
//

import UIKit

class PopoverViewController: UIViewController {

    var backgroundView = UIImageView()
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
        
        backgroundView.frame = view.frame
        backgroundView.image = UIImage(named: "popover_background")!.resizableImageWithCapInsets(UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0), resizingMode: UIImageResizingMode.Stretch)
        view.addSubview(backgroundView)
        
        let margin: CGFloat = 20
        let tableX = margin
        let tableY = margin
        let tableWidth = view.frame.size.width - margin * 2
        let tableHeight = view.frame.size.height - margin * 2
        tableView.frame = CGRect(x: tableX, y: tableY, width: tableWidth, height: tableHeight)
        view.addSubview(tableView)
    }

}
