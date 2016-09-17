//
//  PhotoPickerController.swift
//		CCWeiboAPP
//		Chen Chen @ September 17th, 2016
//

import UIKit

import Cartography

class PhotoPickerController: UIViewController {
    
    private lazy var photoView: UICollectionView = {
        let collectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.backgroundColor = MainColor
        return collectionView
    }()
    
    // MARK: - 系统方法
    
    /**
     视图已经加载方法
     */
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        setupUI()
        setupConstraints()
    }
    
    // MARK: - 界面方法
    
    /**
     初始化界面方法
     */
    private func setupUI() {

        view.addSubview(photoView)
    }
    
    /**
     初始化约束方法
     */
    private func setupConstraints() {
        
        constrain(photoView) { (photoView) in
            photoView.edges == inset(photoView.superview!.edges, 0)
        }
    }
    
}

class PhotoPickerLayout: UICollectionViewFlowLayout {
    
    /**
     准备布局方法
     */
    override func prepareLayout() {
        
        super.prepareLayout()
        
        itemSize = CGSize(width: kViewAdapter, height: kViewAdapter)
        minimumInteritemSpacing = kViewBorder
        minimumLineSpacing = kViewBorder
        
        scrollDirection = .Horizontal
        collectionView?.pagingEnabled = true
        collectionView?.bounces = false
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.showsVerticalScrollIndicator = false
    }
    
}