//
//  PopoverView.swift
//      CCWeiboSwiftApp
//		Chen Chen @ November 28th, 2016
//

import UIKit

import Cartography

class PopoverView: UIView {

    /// 背景图片视图
    private var backgroundView = UIImageView()
    /// 表格视图
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
        
        backgroundView.image = UIImage(named: "popover_background")!.resizableImage(withCapInsets: UIEdgeInsets(top: 25, left: 0, bottom: 25, right: 0), resizingMode: .stretch)
        addSubview(backgroundView)
        
        tableView.backgroundColor = kMainColor
        addSubview(tableView)
    }
    
    /**
     初始化约束方法
     */
    private func setupConstraints() {
        
        constrain(backgroundView, tableView) { backgroundView, tableView in
            backgroundView.edges == inset(backgroundView.superview!.edges, 0)
            tableView.edges == inset(backgroundView.edges, kViewPadding)
        }
    }

}
