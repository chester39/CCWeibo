//
//  TitleView.swift
//		CCWeiboAPP
//		Chen Chen @ September 6th, 2016
//

import UIKit

import Cartography

class TitleView: UIView {
    
    /// 标题标签
    var titleLabel = UILabel(text: "", fontSize: 18, lines: 1)
    /// 副标题标签
    var subtitleLabel = UILabel(text: "", fontSize: 14, lines: 1)
    
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
        
        titleLabel.textAlignment = .Center
        addSubview(titleLabel)
        
        subtitleLabel.textAlignment = .Center
        addSubview(subtitleLabel)
        
        sizeToFit()
    }

    /**
     初始化约束方法
     */
    private func setupConstraints() {
        
        constrain(titleLabel, subtitleLabel) { (titleLabel, subtitleLabel) in
            titleLabel.top == titleLabel.superview!.top
            titleLabel.centerX == titleLabel.superview!.centerX
            
            subtitleLabel.top == titleLabel.bottom
            subtitleLabel.centerX == subtitleLabel.superview!.centerX
        }
    }
    
}
