//
//	iOS培训
//		小码哥
//		Chen Chen @ August 22nd, 2016
//

import UIKit

class NewfeatureViewController: UIViewController {

    // 最大新特性界面数
    private var maxCount = 4
    // Cell重用标识符
    private let reuseIdentifier = "NewfeatureCell"
    // 新特性视图
    var newfeatureView = UICollectionView(frame: kScreenFrame, collectionViewLayout: NewfeatureLayout())
    
    // MARK: - 系统方法
    
    /**
     视图已经加载方法
     */
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        setupUI()
    }
    
    /**
     初始化界面方法
     */
    private func setupUI() {
        
        newfeatureView.dataSource = self
        newfeatureView.delegate = self
        newfeatureView.registerClass(NewfeatureCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        view.addSubview(newfeatureView)
    }

}

extension NewfeatureViewController: UICollectionViewDataSource {
    
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
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! NewfeatureCell
        cell.index = indexPath.item
        return cell
    }
}

extension NewfeatureViewController: UICollectionViewDelegate {
    
    /**
     指定行已经消失方法
     */
    func collectionView(collectionView: UICollectionView, didEndDisplayingCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        
        let index = collectionView.indexPathsForVisibleItems().last!
        let currentCell = collectionView.cellForItemAtIndexPath(index) as! NewfeatureCell
        if index.item == (maxCount - 1) {
            currentCell.startAnimation()
        }
    }
}

class NewfeatureLayout: UICollectionViewFlowLayout {
    
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
