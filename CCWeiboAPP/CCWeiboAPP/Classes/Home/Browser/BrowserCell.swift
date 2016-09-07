//
//	BrowserCell.swift
//		CCWeiboAPP
//		Chen Chen @ September 2nd, 2016
//

import UIKit

import SDWebImage

class BrowserCell: UICollectionViewCell {

    // 图标URL
    var imageURL: NSURL? {
        didSet {
            indicatorView.startAnimating()
            resetView()
            
            imageView.sd_setImageWithURL(imageURL, placeholderImage: nil) { (image, error, _, url) in
                self.indicatorView.stopAnimating()
                let scale = image.size.width / image.size.height
                let imageHeight = kScreenWidth / scale
                self.imageView.frame = CGRect(origin: CGPointZero, size: CGSize(width: kScreenWidth, height: imageHeight))
                
                if imageHeight < kScreenHeight {
                    let offsetY = (kScreenHeight - imageHeight) / 2
                    self.baseView.contentInset = UIEdgeInsets(top: offsetY, left: 0, bottom: offsetY, right: 0)
                    
                } else {
                    self.baseView.contentSize = CGSize(width: kScreenWidth, height: imageHeight)
                }
            }
        }
    }
    
    // 基本滑动视图
    private lazy var baseView: UIScrollView = {
       
        let scrollView = UIScrollView()
        scrollView.maximumZoomScale = 2.0
        scrollView.minimumZoomScale = 0.5
        scrollView.delegate = self
        
        return scrollView
    }()
    
    // 图片视图
    lazy var imageView: UIImageView = UIImageView()
    // 提示视图
    private lazy var indicatorView: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
    
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
        
        baseView.frame = kScreenFrame
        baseView.backgroundColor = CommonDarkColor
        contentView.addSubview(baseView)
        
        baseView.addSubview(imageView)
        
        indicatorView.center = contentView.center
        contentView.addSubview(indicatorView)
    }
    
    /**
     重置视图方法
     */
    private func resetView() {
        
        baseView.contentSize = CGSizeZero
        baseView.contentInset = UIEdgeInsetsZero
        baseView.contentOffset = CGPointZero
        
        imageView.transform = CGAffineTransformIdentity
    }
    
}

extension BrowserCell: UIScrollViewDelegate {
    
    /**
     获取缩放视图方法
     */
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        
        return imageView
    }
    
    /**
     正在缩放方法
     */
    func scrollViewDidZoom(scrollView: UIScrollView) {
        
        var offsetX = (kScreenWidth - imageView.frame.size.width) / 2
        var offsetY = (kScreenHeight - imageView.frame.size.height) / 2
        offsetX = (offsetX < 0) ? 0 : offsetX
        offsetY = (offsetY < 0) ? 0 : offsetY
        
        scrollView.contentInset = UIEdgeInsets(top: offsetY, left: offsetX, bottom: offsetY, right: offsetX)
    }
    
}
