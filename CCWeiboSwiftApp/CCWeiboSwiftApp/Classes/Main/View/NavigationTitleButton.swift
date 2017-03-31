//
//  NavigationTitleButton.swift
//      CCWeiboSwiftApp
//		Chen Chen @ November 23rd, 2016
//

import UIKit

class NavigationTitleButton: UIButton {
    
    // MARK: - 初始化方法
    
    /**
     自定义初始化方法
     */
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        setupUI()
    }
    
    /**
     数据解码XIB初始化方法
     */
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 基本方法
    
    /**
     设置标题方法
     */
    override func setTitle(_ title: String?, for state: UIControlState) {
        
        super.setTitle((title ?? "") + "  ", for: state)
    }
    
    /**
     视图已经布局子视图方法
     */
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        titleLabel?.frame.origin.x = 0
        imageView?.frame.origin.x = titleLabel!.frame.width
    }
    
    // MARK: - 界面方法
    
    /**
     初始化界面方法
     */
    private func setupUI() {
        
        setImage(UIImage(named: "navigationbar_arrow_down"), for: .normal)
        setImage(UIImage(named: "navigationbar_arrow_up"), for: .selected)
        
        setTitleColor(kStatusTabBarTextColor, for: .normal)
        sizeToFit()
    }
    
}
