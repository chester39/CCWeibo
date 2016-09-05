//
//  ProgressImageView.swift
//		CCWeiboAPP
//		Chen Chen @ September 4th, 2016
//

import UIKit

class ProgressImageView: UIImageView {

    // 进度条视图
    private lazy var progressView: ProgressView = ProgressView()
    
    // 当前进度
    var progress: CGFloat = 0.0 {
        didSet {
            progressView.progress = progress
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
    
    /**
     无参数便利初始化方法
     */
    convenience init() {
        
        self.init(frame: CGRectZero)
    }
    
    /**
     视图已经布局子视图方法
     */
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        progressView.frame = bounds
    }
    
    // MARK: - 界面方法
    
    /**
     初始化界面方法
     */
    private func setupUI() {
        
        addSubview(progressView)
        progressView.backgroundColor = UIColor.clearColor()
    }
    
}
