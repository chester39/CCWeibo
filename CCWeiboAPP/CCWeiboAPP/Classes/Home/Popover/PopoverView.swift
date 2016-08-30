//
//	iOS培训
//		小码哥
//		Chen Chen @ August 16th, 2016
//

import UIKit

import Cartography

class PopoverView: UIView {

    // 背景图片视图
    private var backgroundView = UIImageView()
    // 表格视图
    private var tableView = UITableView()
    
    // MARK: - 初始化方法
    
    /**
     自定义初始化方法
     */
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        setupUI()
        setupConstraints()
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
        
        backgroundView.image = UIImage(named: "popover_background")!.resizableImageWithCapInsets(UIEdgeInsets(top: 25, left: 0, bottom: 25, right: 0), resizingMode: UIImageResizingMode.Stretch)
        addSubview(backgroundView)
        
        tableView.backgroundColor = UIColor(hex: 0xff6c45)
        addSubview(tableView)
    }
    
    /**
     初始化约束方法
     */
    private func setupConstraints() {
        
        constrain(backgroundView, tableView) { (backgroundView, tableView) in
            backgroundView.edges == inset(backgroundView.superview!.edges, 0)
            tableView.edges == inset(backgroundView.edges, kViewPadding)
        }
    }

}
