//
//  EmoticonKeyboardCell.swift
//		CCWeiboAPP
//		Chen Chen @ September 11th, 2016
//

import UIKit

class EmoticonKeyboardCell: UICollectionViewCell {
    
    // 表情按钮
    private lazy var emoticonButton: UIButton = {
        let button = UIButton(type: .Custom)
        button.userInteractionEnabled = false
        button.titleLabel?.font = UIFont.systemFontOfSize(32)
       
        return button
    }()
    
    // 表情模型
    var emoticon: EmoticonModel? {
        didSet {
            emoticonButton.setTitle(emoticon?.emoticonString ?? "", forState: .Normal)
            emoticonButton.setImage(nil, forState: .Normal)
            if emoticon?.chs != nil {
                emoticonButton.setImage(UIImage(contentsOfFile: emoticon!.pngPath!), forState: .Normal)
            }
            
            if emoticon!.isRemoveButton {
                emoticonButton.setImage(UIImage(named: "compose_emotion_delete"), forState: .Normal)
                emoticonButton.setImage(UIImage(named: "compose_emotion_delete_highlighted"), forState: .Highlighted)
            }
        }
    }
    
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
        
        emoticonButton.frame = CGRectInset(bounds, kViewEdge, kViewEdge)
        contentView.addSubview(emoticonButton)
    }
    
}

class EmoticonAttachment: NSTextAttachment {
    
    // 表情字符串
    var emoticonChs: String?
    
}
