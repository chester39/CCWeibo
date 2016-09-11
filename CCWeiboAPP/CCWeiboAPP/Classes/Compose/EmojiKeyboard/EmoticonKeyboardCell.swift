//
//  EmoticonKeyboardCell.swift
//		CCWeiboAPP
//		Chen Chen @ September 11th, 2016
//

import UIKit

class EmoticonKeyboardCell: UICollectionViewCell {
    
    // 表情按钮
    private lazy var emojiButton: UIButton = {
        let button = UIButton(type: .Custom)
        button.userInteractionEnabled = false
        button.titleLabel?.font = UIFont.systemFontOfSize(30)
       
        return button
    }()
    
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
    
    // MARK: - 界面方法
    
    /**
     初始化界面方法
     */
    private func setupUI() {
        
        emojiButton.backgroundColor = CommonLightColor
        emojiButton.frame = CGRectInset(bounds, kViewEdge, kViewEdge)
        contentView.addSubview(emojiButton)
    }
}
