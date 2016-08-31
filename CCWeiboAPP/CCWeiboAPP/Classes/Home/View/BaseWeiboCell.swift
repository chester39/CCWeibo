//
//	iOS培训
//		小码哥
//		Chen Chen @ August 31st, 2016
//

import UIKit

import Cartography
import SDWebImage

class BaseWeiboCell: UITableViewCell {

    // Cell重用标识符
    let pictureReuseIdentifier = "PictureCell"
    // 头像图片视图
    var iconView = UIImageView()
    // 认证图片视图
    var verifiedView = UIImageView()
    // 昵称标签
    var nameLabel = UILabel(text: "", fontSize: 15, lines: 1)
    // 会员图片视图
    var vipView = UIImageView()
    // 时间标签
    var timeLabel = UILabel(text: "", fontSize: 12, lines: 1)
    // 来源标签
    var sourceLabel = UILabel(text: "", fontSize: 12, lines: 1)
    // 内容标签
    var contentLabel = UILabel(text: "", fontSize: 14, lines: 0)
    // 底部视图
    var footerView = UIView()
    // 转发按钮
    var retweetButton = UIButton(imageName: "timeline_icon_retweet", backgroundImageName: "timeline_card_bottom_background")
    // 评论按钮
    var commentButton = UIButton(imageName: "timeline_icon_comment", backgroundImageName: "timeline_card_bottom_background")
    // 点赞按钮
    var likeButton = UIButton(imageName: "timeline_icon_unlike", backgroundImageName: "timeline_card_bottom_background")

    // 集合布局懒加载
    lazy var flowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = kViewPadding
        layout.minimumInteritemSpacing = kViewPadding
        
        return layout
    }()
    
    // 图片集合视图懒加载
    lazy var pictureCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: self.flowLayout)
        
        return collectionView
    }()
    
    // 微博模型
    var viewModel: StatusViewModel?
    
    /**
     初始化图片集合视图方法
     */
    func setupPictureCollectionView() -> (cellSize: CGSize, collectionSize: CGSize) {
        
        let count = viewModel?.thumbnailPictureArray?.count ?? 0
        let imageWidth: CGFloat = 90
        let imageHeight: CGFloat = 90
        
        switch count {
        case 0:
            return (cellSize: CGSizeZero, collectionSize:CGSizeZero)
            
        case 1:
            let key = viewModel!.thumbnailPictureArray!.first!.absoluteString
            let image = SDWebImageManager.sharedManager().imageCache.imageFromDiskCacheForKey(key)
            return (cellSize: image.size, collectionSize: image.size)
            
        case 4:
            let column = 2
            let row = column
            let width = imageWidth * CGFloat(column) + kViewPadding * CGFloat(column - 1)
            let height = imageHeight * CGFloat(row) + kViewPadding * CGFloat(row - 1)
            return (cellSize: CGSize(width: imageWidth, height: imageHeight), collectionSize: CGSize(width: width, height: height))
            
        default:
            let column = 3
            let row = (count - 1) / 3 + 1
            let width = imageWidth * CGFloat(column) + kViewPadding * CGFloat(column - 1)
            let height = imageHeight * CGFloat(row) + kViewPadding * CGFloat(row - 1)
            return (cellSize: CGSize(width: imageWidth, height: imageHeight), collectionSize: CGSize(width: width, height: height))
        }
    }
    
}

extension BaseWeiboCell: UICollectionViewDataSource {
    
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
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(pictureReuseIdentifier, forIndexPath: indexPath) as! PictureCell
        cell.url = viewModel!.thumbnailPictureArray![indexPath.item]
        
        return cell
    }
}

class PictureCell: UICollectionViewCell {
    
    // 图片视图
    var imageView = UIImageView()
    
    // 图片URL
    var url: NSURL? {
        didSet {
            imageView.sd_setImageWithURL(url)
        }
    }
    
    // MARK: - 初始化方法
    
    /**
     自定义初始化方法
     */
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        contentView.addSubview(imageView)
        constrain(imageView) { (imageView) in
            imageView.edges == inset(imageView.superview!.edges, 0)
        }
    }
    
    /**
     数据解码XIB初始化方法
     */
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
}
