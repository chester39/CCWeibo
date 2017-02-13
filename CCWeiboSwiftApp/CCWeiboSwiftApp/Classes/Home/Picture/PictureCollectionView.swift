//
//  PictureCollectionView.swift
//      CCWeiboSwiftApp
//		Chen Chen @ November 23rd, 2016
//

import UIKit

import SDWebImage

/// Cell重用标识符
private let reuseIdentifier = "PictureCell"

class PictureCollectionView: UICollectionView {

    /// 微博模型
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
        
        register(StatusPictureCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        dataSource = self
        delegate = self
        
        backgroundColor = ClearColor
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
            return (cellSize: .zero, collectionSize: .zero)
            
        case 1:
            let key = viewModel!.thumbnailPictureArray!.first!
            var image = SDWebImageManager.shared().imageCache!.imageFromDiskCache(forKey: key.absoluteString)
            if image != nil {
                return (cellSize: image!.size, collectionSize: image!.size)
                
            } else {
                let data = try! Data(contentsOf: key)
                image = UIImage(data: data)
                
                return (cellSize: image!.size, collectionSize: image!.size)
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
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
    }
    
    /**
     每组集数方法
     */
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return viewModel?.thumbnailPictureArray?.count ?? 0
    }
    
    /**
     每集内容方法
     */
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! StatusPictureCell
        cell.url = viewModel!.thumbnailPictureArray![indexPath.item]
        
        return cell
    }
    
}

extension PictureCollectionView: UICollectionViewDelegate {
    
    /**
     选中集合方法
     */
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let url = viewModel!.middlePictureArray![indexPath.item]
        let cell = collectionView.cellForItem(at: indexPath) as! StatusPictureCell
        SDWebImageManager.shared().downloadImage(with: url, options: .retryFailed, progress: { (current, total) in
            cell.imageView.progress = CGFloat(current) / CGFloat(total)
        }) { (_, _, _, _, _) in
            let userInfo = ["middlePicture": self.viewModel!.middlePictureArray!, "indexPath": indexPath] as [String : Any]
            NotificationCenter.default.post(name: Notification.Name(kBrowserViewControllerShowed), object: self, userInfo: userInfo)
        }
    }
    
}

extension PictureCollectionView: BrowserPresentationDelegate {
    
    /**
     浏览图片视图创建方法
     */
    func browerPresentationWillShowImageView(browserPresentationController: BrowserPresentationController, indexPath: IndexPath) -> UIImageView {
        
        let imageView = UIImageView()
        let cell = cellForItem(at: indexPath) as! StatusPictureCell
        imageView.image = cell.imageView.image
        imageView.sizeToFit()
        
        return imageView
    }
    
    /**
     浏览图片相对尺寸方法
     */
    func browerPresentationWillFromFrame(browserPresentationController: BrowserPresentationController, indexPath: IndexPath) -> CGRect {
        
        let cell = cellForItem(at: indexPath) as! StatusPictureCell
        let frame = convert(cell.frame, to: UIApplication.shared.keyWindow!)
        
        return frame
    }
    
    /**
     浏览图片绝对尺寸方法
     */
    func browerPresentationWillToFrame(browserPresentationController: BrowserPresentationController, indexPath: IndexPath) -> CGRect {
        
        let cell = cellForItem(at: indexPath) as! StatusPictureCell
        let image = cell.imageView.image!
        let scale = image.size.width / image.size.height
        let imageHeight = kScreenHeight / scale
        
        var offsetY: CGFloat = 0
        if imageHeight < kScreenHeight {
            offsetY = (kScreenHeight - imageHeight) / 2
        }
        
        return CGRect(x: 0, y: offsetY, width: kScreenWidth, height: imageHeight)
    }

}
