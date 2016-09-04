//
//	PictureCollectionView.swift
//		CCWeiboAPP
//		Chen Chen @ September 1st, 2016
//

import UIKit

import SDWebImage

class PictureCollectionView: UICollectionView {

    // 微博模型
    var viewModel: StatusViewModel? {
        didSet {
            reloadData()
        }
    }
    
    // MARK: - 初始化方法
    
    /**
     指定布局初始化方法
     */
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        
        super.init(frame: frame, collectionViewLayout: layout)
        
        registerClass(PictureCell.self, forCellWithReuseIdentifier: kPictureReuseIdentifier)
        dataSource = self
        delegate = self
        
        backgroundColor = UIColor.clearColor()
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
    }
    
    /**
     数据解码XIB初始化方法
     */
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    /**
     获取集合布局方法
     */
    func acquireLayoutSize() -> (cellSize: CGSize, collectionSize: CGSize) {
        
        let count = viewModel?.thumbnailPictureArray?.count ?? 0
        let imageWidth: CGFloat = 95
        let imageHeight: CGFloat = 95
        
        switch count {
        case 0:
            return (cellSize: CGSizeZero, collectionSize:CGSizeZero)
            
        case 1:
            let key = viewModel!.thumbnailPictureArray!.first!
            var image = SDWebImageManager.sharedManager().imageCache.imageFromDiskCacheForKey(key.absoluteString)
            if image != nil {
                return (cellSize: image.size, collectionSize: image.size)
                
            } else {
                let data = NSData(contentsOfURL: key)
                image = UIImage(data: data!)
                return (cellSize: image.size, collectionSize: image.size)
            }
        
        case 4:
            let column = 2
            let row = column
            let width = imageWidth * CGFloat(column) + kViewEdge * CGFloat(column - 1)
            let height = imageHeight * CGFloat(row) + kViewEdge * CGFloat(row - 1)
            return (cellSize: CGSize(width: imageWidth, height: imageHeight), collectionSize: CGSize(width: width, height: height))
            
        default:
            let column = 3
            let row = (count - 1) / 3 + 1
            let width = imageWidth * CGFloat(column) + kViewEdge * CGFloat(column - 1)
            let height = imageHeight * CGFloat(row) + kViewEdge * CGFloat(row - 1)
            return (cellSize: CGSize(width: imageWidth, height: imageHeight), collectionSize: CGSize(width: width, height: height))
        }
    }

}

extension PictureCollectionView: UICollectionViewDataSource {
    
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
        
        return viewModel?.thumbnailPictureArray?.count ?? 0
    }
    
    /**
     每集内容方法
     */
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(kPictureReuseIdentifier, forIndexPath: indexPath) as! PictureCell
        cell.url = viewModel!.thumbnailPictureArray![indexPath.item]
        
        return cell
    }
    
}

extension PictureCollectionView: UICollectionViewDelegate {
    
    /**
     选中集合方法
     */
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        let url = viewModel!.middlePictureArray![indexPath.item]
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! PictureCell
        SDWebImageManager.sharedManager().downloadImageWithURL(url, options: .RetryFailed, progress: { (current, total) in
            cell.imageView.progress = CGFloat(current) / CGFloat(total)
            }) { (_, _, _, _, _) in
                let userInfo = ["middlePicture": self.viewModel!.middlePictureArray!, "indexPath": indexPath]
                NSNotificationCenter.defaultCenter().postNotificationName(kPictureBrowserControllerShowed, object: self, userInfo: userInfo)
        }
    }
    
}