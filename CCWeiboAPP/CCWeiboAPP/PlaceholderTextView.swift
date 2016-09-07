//
//  PlaceholderTextView.swift
//		CCWeiboAPP
//		Chen Chen @ September 6th, 2016
//

import UIKit

import Cartography

class PlaceholderTextView: UITextView {

    // 占位符标签
    private lazy var placeholderLabel: UILabel = {
        let label = UILabel()
        label.text = "分享新鲜事..."
        label.textColor = AuxiliaryTextColor
        label.font = UIFont.systemFontOfSize(18)

        return label
    }()
    
    // MARK: - 初始化方法
    
    /**
     自定义初始化方法
     */
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        
        super.init(frame: frame, textContainer: textContainer)
        
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
        
        addSubview(placeholderLabel)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(textDidChange), name: UITextViewTextDidChangeNotification, object: self)
    }
    
    /**
     初始化约束方法
     */
    private func setupConstraints() {
        
        constrain(placeholderLabel) { (placeholderLabel) in
            placeholderLabel.top == placeholderLabel.superview!.top + 8
            placeholderLabel.left == placeholderLabel.superview!.left + 4
        }
    }
    
    // MARK: - 通知方法
    
    /**
     文本已经改变方法
     */
    @objc private func textDidChange() {
        
        placeholderLabel.hidden = hasText()
    }
}