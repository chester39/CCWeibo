//
//	NewFeatureController.swift
//		CCWeiboAPP
//		Chen Chen @ August 22nd, 2016
//

import UIKit

import Cartography

class NewFeatureController: UIViewController {

    /// 最大新特性界面数
    private let maxNewFeatureCount = 4
    /// Cell重用标识符
    private let reuseIdentifier: String = "NewFeatureCell"
    
    /// 新特性集合视图
    private lazy var newFeatureView: UICollectionView = {
        let collectionView = UICollectionView(frame: kScreenFrame, collectionViewLayout: PictureLayout())
        collectionView.dataSource = self
        collectionView.delegate = self
        
        return collectionView
    }()
    
    /// 页码指示器
    private lazy var pageControl: UIPageControl = {
        let page = UIPageControl()
        page.pageIndicatorTintColor = CommonLightColor
        page.currentPageIndicatorTintColor = AuxiliaryTextColor
        
        return page
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

        newFeatureView.registerClass(NewFeatureCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        view.addSubview(newFeatureView)
        
        pageControl.numberOfPages = maxNewFeatureCount
        view.addSubview(pageControl)
    }
    
    /**
     初始化约束方法
     */
    private func setupConstraints() {
        
        constrain(pageControl) { (pageControl) in
            pageControl.centerX == pageControl.superview!.centerX
            pageControl.bottom == pageControl.superview!.bottom - kViewAdapter
        }
    }

}

extension NewFeatureController: UICollectionViewDataSource {
    
    /**
     共有组数方法
     */
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        
        return 1
    }
    
    /**
     每组集数方法
     */
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return maxNewFeatureCount
    }
    
    /**
     每集内容方法
     */
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! NewFeatureCell
        cell.index = indexPath.item
        
        return cell
    }
    
}

extension NewFeatureController: UICollectionViewDelegate {
    
    /**
     指定行已经消失方法
     */
    func collectionView(collectionView: UICollectionView, didEndDisplayingCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        
        let index = collectionView.indexPathsForVisibleItems().last!
        let currentCell = collectionView.cellForItemAtIndexPath(index) as! NewFeatureCell
        pageControl.currentPage = collectionView.indexPathsForVisibleItems().last!.item % maxNewFeatureCount
        if index.item == (maxNewFeatureCount - 1) {
            currentCell.startAnimation()
        }
    }
    
}

class PictureLayout: UICollectionViewFlowLayout {
    
    /**
     准备布局方法
     */
    override func prepareLayout() {
        
        super.prepareLayout()
        
        itemSize = kScreenFrame.size
        minimumInteritemSpacing = 0 
        minimumLineSpacing = 0
        
        scrollDirection = .Horizontal
        collectionView?.pagingEnabled = true
        collectionView?.bounces = false
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.showsVerticalScrollIndicator = false
    }
    
}
