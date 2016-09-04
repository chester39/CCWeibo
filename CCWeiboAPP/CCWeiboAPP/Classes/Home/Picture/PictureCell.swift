//
//  PictureCell.swift
//		CCWeiboAPP
//		Chen Chen @ September 2nd, 2016
//

import UIKit

import Cartography

class PictureCell: UICollectionViewCell {
    
    // 图片视图
    var imageView = ProgressImageView()
    
    // 图片URL
    var url: NSURL? {
        didSet {
            imageView.sd_setImageWithURL(url)
        }
    }
    
    // MARK: - 初始化方法
    
    /**
     自定义初始化方法
     */
    override init(frame: CGRect) {
        
        super.init(frame: frame)

        contentView.addSubview(imageView)
    }
    
    /**
     数据解码XIB初始化方法
     */
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    /**
     视图已经布局子视图方法
     */
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        imageView.frame = bounds
    }
}
