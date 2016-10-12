//
//  ThemeCell.swift
//		CCWeiboAPP
//		Chen Chen @ October 12th, 2016
//

import UIKit

import Cartography

class ThemeCell: UICollectionViewCell {
    
    /// 主题按钮
    var button = ThemeButton(frame: CGRectZero)
    
    // MARK: - 初始化方法
    
    /**
     自定义初始化方法
     */
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        button.setTitleColor(CommonDarkColor, forState: .Normal)
        button.titleLabel?.font = UIFont.systemFontOfSize(14)
        contentView.addSubview(button)
        constrain(button) { (button) in
            button.edges == inset(button.superview!.edges, 0)
        }
    }
    
    /**
     数据解码XIB初始化方法
     */
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
}

class ThemeLayout: UICollectionViewFlowLayout {
    
    /**
     准备布局方法
     */
    override func prepareLayout() {
        
        super.prepareLayout()
        
        let column: CGFloat = 5
        let row: CGFloat = 2
        let width = (kScreenWidth - kViewEdge * (column - 1)) / column
        let height = (kViewDistance - kViewEdge * (row - 1)) / row
        itemSize = CGSize(width: width, height: height)
        minimumInteritemSpacing = kViewEdge
        minimumLineSpacing = kViewEdge
        
        collectionView?.bounces = false
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.showsVerticalScrollIndicator = false
    }
    
}