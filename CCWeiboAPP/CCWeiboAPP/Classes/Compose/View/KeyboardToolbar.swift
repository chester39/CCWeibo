//
//  KeyboardToolbar.swift
//		CCWeiboAPP
//		Chen Chen @ September 9th, 2016
//

import UIKit

class KeyboardToolbar: UIToolbar {

    /// 图片按钮
    lazy var pictureButton: UIBarButtonItem = {
        let button = UIBarButtonItem()
        button.image = UIImage(named: "compose_toolbar_picture")
        button.style = .Plain
        
        return button
    }()
    
    /// 提及按钮
    lazy var mentionButton: UIBarButtonItem = {
        let button = UIBarButtonItem()
        button.image = UIImage(named: "compose_mentionbutton_background")
        button.style = .Plain
        
        return button
    }()
    
    /// 趋势按钮
    lazy var trendButton: UIBarButtonItem = {
        let button = UIBarButtonItem()
        button.image = UIImage(named: "compose_trendbutton_background")
        button.style = .Plain
        
        return button
    }()
    
    /// 表情按钮
    lazy var emoticonButton: UIBarButtonItem = {
        let button = UIBarButtonItem()
        button.image = UIImage(named: "compose_emoticonbutton_background")
        button.style = .Plain
        
        return button
    }()
    
    /// 更多按钮
    lazy var moreButton: UIBarButtonItem = {
        let button = UIBarButtonItem()
        button.image = UIImage(named: "compose_addbutton_background")
        button.style = .Plain
        
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
        
        let flexibleButton = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: self, action: nil)
        var itemArray = [UIBarButtonItem]()
        for button in [pictureButton, mentionButton, trendButton, emoticonButton, moreButton] {
            itemArray.append(button)
            itemArray.append(flexibleButton)
        }
        
        itemArray.removeLast()
        items = itemArray
        tintColor = AuxiliaryTextColor
    }
    
}
