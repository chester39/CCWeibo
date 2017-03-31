//
//  ThemeCell.swift
//      CCWeiboSwiftApp
//		Chen Chen @ December 1st, 2016
//

import UIKit

import Cartography

class ThemeCell: UICollectionViewCell {
    
    /// 主题按钮
    var button = DiscoverThemeButton(frame: .zero)
    
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
        
        button.setTitleColor(kCommonDarkColor, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        contentView.addSubview(button)
    }
    
    /**
     初始化约束方法
     */
    private func setupConstraints() {
        
        constrain(button) { button in
            button.edges == inset(button.superview!.edges, 0)
        }
    }
    
}

class ThemeLayout: UICollectionViewFlowLayout {
    
    /**
     准备布局方法
     */
    override func prepare() {
        
        super.prepare()
        
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
