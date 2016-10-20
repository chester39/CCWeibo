//
//  PictureCell.swift
//		CCWeiboAPP
//		Chen Chen @ September 2nd, 2016
//

import UIKit

import Cartography
import SDWebImage

class PictureCell: UICollectionViewCell {
    
    /// 图片视图
    var imageView = ProgressImageView()
    /// GIF按钮
    private var gifView = UIImageView()
    
    /// 图片URL
    var url: NSURL? {
        didSet {
            imageView.sd_setImageWithURL(url)
            if let flag = url?.absoluteString!.lowercaseString.hasSuffix("gif") {
                gifView.hidden = !flag
            }
        }
    }
    
    // MARK: - 初始化方法
    
    /**
     自定义初始化方法
     */
    override init(frame: CGRect) {
        
        super.init(frame: frame)

        contentView.addSubview(imageView)
        
        gifView.image = UIImage(named: "gif")
        contentView.addSubview(gifView)
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
        
        constrain(gifView) { (gifView) in
            gifView.width == kViewBorder
            gifView.height == kViewPadding
            gifView.bottom == gifView.superview!.bottom
            gifView.right == gifView.superview!.right
        }
    }
    
}
