//
//  NewFeatureController.swift
//      CCWeiboSwiftApp
//		Chen Chen @ November 25th, 2016
//

import UIKit

import Cartography

class NewFeatureController: UIViewController {

    /// 最大新特性界面数
    fileprivate let maxNewFeatureCount = 4
    /// Cell重用标识符
    fileprivate let reuseIdentifier = "NewFeatureCell"
    
    /// 新特性集合视图
    private lazy var newFeatureView: UICollectionView = {
        let collectionView = UICollectionView(frame: kScreenFrame, collectionViewLayout: NewFeatureLayout())
        collectionView.dataSource = self
        collectionView.delegate = self
        
        return collectionView
    }()
    
    /// 页码指示器
    fileprivate lazy var pageControl: UIPageControl = {
        let page = UIPageControl()
        page.pageIndicatorTintColor = kCommonLightColor
        page.currentPageIndicatorTintColor = kAuxiliaryTextColor
        
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
        
        newFeatureView.register(NewFeatureCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        view.addSubview(newFeatureView)
        
        pageControl.numberOfPages = maxNewFeatureCount
        view.addSubview(pageControl)
    }
    
    /**
     初始化约束方法
     */
    private func setupConstraints() {
        
        constrain(pageControl) { pageControl in
            pageControl.centerX == pageControl.superview!.centerX
            pageControl.bottom == pageControl.superview!.bottom - kViewAdapter
        }
    }
    
}

extension NewFeatureController: UICollectionViewDataSource {
    
    /**
     共有组数方法
     */
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
    }
    
    /**
     每组集数方法
     */
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return maxNewFeatureCount
    }
    
    /**
     每集内容方法
     */
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! NewFeatureCell
        cell.index = indexPath.item
        
        return cell
    }
    
}

extension NewFeatureController: UICollectionViewDelegate {
    
    /**
     指定行已经消失方法
     */
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        let index = collectionView.indexPathsForVisibleItems.last!
        let currentCell = collectionView.cellForItem(at: index) as! NewFeatureCell
        pageControl.currentPage = collectionView.indexPathsForVisibleItems.last!.item % maxNewFeatureCount
        if index.item == (maxNewFeatureCount - 1) {
            currentCell.startAnimation()
        }
    }
    
}

class NewFeatureLayout: UICollectionViewFlowLayout {
    
    /**
     准备布局方法
     */
    override func prepare() {
        
        super.prepare()
        
        itemSize = kScreenFrame.size
        minimumInteritemSpacing = 0
        minimumLineSpacing = 0
        
        scrollDirection = .horizontal
        collectionView?.isPagingEnabled = true
        collectionView?.bounces = false
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.showsVerticalScrollIndicator = false
    }
    
}
