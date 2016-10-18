//
//  SettingView.swift
//  CCWeiboAPP
//
//  Created by Chester Chen on 2016/10/18.
//  Copyright © 2016年 Chen Chen. All rights reserved.
//

import UIKit

import Cartography

class SettingView: UIView {
    
    /// 图片视图
    var imageView = UIImageView()
    
    // MARK: - 初始化方法
    
    /**
     自定义初始化方法
     */
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        imageView.image = UIImage(named: "compose_app_empty")
        imageView.frame = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height)
        addSubview(imageView)
    }
    
    /**
     数据解码XIB初始化方法
     */
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 系统方法
    
    /**
     响应触摸事件方法
     */
    override func hitTest(point: CGPoint, withEvent event: UIEvent?) -> UIView? {
        
        let view = super.hitTest(point, withEvent: event)
        if view == self {
            return nil
            
        } else {
            return view
        }
    }
    
}
