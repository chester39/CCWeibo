//
//	iOS培训
//		小码哥
//		Chen Chen @ August 22nd, 2016
//

import UIKit

class NewFeatureViewController: UIViewController {

    // 最大新特性界面数
    private var maxCount = 4
    // Cell重用标识符
    private let reuseIdentifier = "NewFeatureCell"
    // 新特性视图
    var newFeatureView = UICollectionView(frame: kScreenFrame, collectionViewLayout: NewFeatureLayout())
    
    // MARK: - 系统方法
    
    /**
     视图已经加载方法
     */
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        setupUI()
    }
    
    // MARK: - 界面方法
    
    /**
     初始化界面方法
     */
    private func setupUI() {
        
        newFeatureView.dataSource = self
        newFeatureView.delegate = self
        newFeatureView.registerClass(NewFeatureCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        view.addSubview(newFeatureView)
    }

}

extension NewFeatureViewController: UICollectionViewDataSource {
    
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
        
        return maxCount
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

extension NewFeatureViewController: UICollectionViewDelegate {
    
    /**
     指定行已经消失方法
     */
    func collectionView(collectionView: UICollectionView, didEndDisplayingCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        
        let index = collectionView.indexPathsForVisibleItems().last!
        let currentCell = collectionView.cellForItemAtIndexPath(index) as! NewFeatureCell
        if index.item == (maxCount - 1) {
            currentCell.startAnimation()
        }
    }
}

class NewFeatureLayout: UICollectionViewFlowLayout {
    
    /**
     准备布局方法
     */
    override func prepareLayout() {
        
        itemSize = kScreenFrame.size
        minimumInteritemSpacing = 0 
        minimumLineSpacing = 0
        
        scrollDirection = UICollectionViewScrollDirection.Horizontal
        collectionView?.pagingEnabled = true
        collectionView?.bounces = false
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.showsVerticalScrollIndicator = false
    }
}
