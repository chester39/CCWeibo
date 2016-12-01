//
//  DiscoverThemeButton.swift
//      CCWeiboSwiftApp
//		Chen Chen @ December 1st, 2016
//

import UIKit

class DiscoverThemeButton: UIButton {

    // MARK: - 初始化方法
    
    /**
     自定义初始化方法
     */
    override init(frame: CGRect) {
        
        super.init(frame: frame)
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
        
        super.setTitle(title, for: state)
        
        setNeedsLayout()
    }
    
    /**
     设置图片方法
     */
    override func setImage(_ image: UIImage?, for state: UIControlState) {
        
        super.setImage(image, for: state)
        
        setNeedsLayout()
    }
    
    /**
     视图已经布局子视图方法
     */
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        imageView?.sizeToFit()
        titleLabel?.sizeToFit()
        
        imageView?.frame.origin.x = (frame.width - imageView!.frame.size.width) / 2.0
        imageView?.frame.origin.y = (frame.height - imageView!.frame.size.height) / 2.0
        
        titleLabel?.frame.origin.x = (frame.width - titleLabel!.frame.size.width) / 2.0
        titleLabel?.frame.origin.y = imageView!.frame.maxY
    }

}
