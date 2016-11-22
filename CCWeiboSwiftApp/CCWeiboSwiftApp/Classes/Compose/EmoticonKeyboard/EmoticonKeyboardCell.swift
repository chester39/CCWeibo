//
//  EmoticonKeyboardCell.swift
//      CCWeiboSwiftApp
//		Chen Chen @ November 22nd, 2016
//

import UIKit

class EmoticonKeyboardCell: UICollectionViewCell {
    
    /// 表情按钮
    private lazy var emoticonButton: UIButton = {
        let button = UIButton(type: .custom)
        button.isUserInteractionEnabled = false
        button.titleLabel?.font = UIFont.systemFont(ofSize: 32)
        
        return button
    }()
    
    /// 表情模型
    var emoticon: EmoticonModel? {
        didSet {
            emoticonButton.setTitle(emoticon?.emojiString ?? "", for: .normal)
            emoticonButton.setImage(nil, for: .normal)
            if emoticon?.chs != nil {
                emoticonButton.setImage(UIImage(contentsOfFile: emoticon!.pngPath!), for: .normal)
            }
            
            if emoticon!.isRemoveButton {
                emoticonButton.setImage(UIImage(named: "compose_emotion_delete"), for: .normal)
                emoticonButton.setImage(UIImage(named: "compose_emotion_delete_highlighted"), for: .highlighted)
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
        
        emoticonButton.frame = bounds.insetBy(dx: kViewEdge, dy: kViewEdge)
        contentView.addSubview(emoticonButton)
    }
    
}

class EmoticonAttachment: NSTextAttachment {
    
    /// 表情简体字符串
    var emoticonChs: String?
    
}
