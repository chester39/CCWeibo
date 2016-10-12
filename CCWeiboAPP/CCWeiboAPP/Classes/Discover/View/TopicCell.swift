//
//  TopicCell.swift
//		CCWeiboAPP
//		Chen Chen @ October 12th, 2016
//

import UIKit

import Cartography

class TopicCell: UICollectionViewCell {
    
    /// 图标视图
    var iconView = UIImageView()
    /// 标题标签
    var titleLabel = UILabel(text: "", fontSize: 14, lines: 1)
    
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
        
        contentView.addSubview(iconView)
        contentView.addSubview(titleLabel)
    }
    
    /**
     初始化约束方法
     */
    private func setupConstraints() {
        
        constrain(iconView, titleLabel) { (iconView, titleLabel) in
            iconView.width == kViewMargin
            iconView.height == kViewMargin
            iconView.top == iconView.superview!.top
            iconView.left == iconView.superview!.left + kViewEdge
            
            titleLabel.left == iconView.right + kViewEdge
            titleLabel.centerY == titleLabel.superview!.centerY
        }
    }
}

class TopicLayout: UICollectionViewFlowLayout {
    
    /**
     准备布局方法
     */
    override func prepareLayout() {
        
        super.prepareLayout()
        
        let column: CGFloat = 2
        let width = (kScreenWidth - kViewEdge * (column - 1)) / column
        itemSize = CGSize(width: width, height: kViewMargin)
        minimumInteritemSpacing = kViewEdge
        minimumLineSpacing = kViewEdge
        
        collectionView?.bounces = false
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.showsVerticalScrollIndicator = false
    }
    
}