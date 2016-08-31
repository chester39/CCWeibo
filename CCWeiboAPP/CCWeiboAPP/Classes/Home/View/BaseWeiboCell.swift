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
    
    // MARK: - 界面方法
    
    /**
     初始化基本界面方法
     */
    func setupBaseUI() {
        
        iconView.layer.cornerRadius = 20
        iconView.clipsToBounds = true
        contentView.addSubview(iconView)
        
        verifiedView.image = UIImage(named: "avatar_vip")
        contentView.addSubview(verifiedView)
        
        contentView.addSubview(nameLabel)
        
        vipView.image = UIImage(named: "common_icon_membership")
        contentView.addSubview(vipView)
        
        timeLabel.textColor = UIColor(hex: 0xa5a5a5)
        contentView.addSubview(timeLabel)
        
        sourceLabel.textColor = UIColor(hex: 0xa5a5a5)
        contentView.addSubview(sourceLabel)
        
        contentLabel.preferredMaxLayoutWidth = kScreenWidth - kViewMargin
        contentView.addSubview(contentLabel)
        
        contentView.addSubview(footerView)
        
        retweetButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: kViewPadding)
        retweetButton.setTitle("转发", forState: UIControlState.Normal)
        retweetButton.setTitleColor(UIColor.darkGrayColor(), forState: UIControlState.Normal)
        retweetButton.titleLabel?.font = UIFont.systemFontOfSize(15)
        footerView.addSubview(retweetButton)
        
        commentButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: kViewPadding)
        commentButton.setTitle("评论", forState: UIControlState.Normal)
        commentButton.setTitleColor(UIColor.darkGrayColor(), forState: UIControlState.Normal)
        commentButton.titleLabel?.font = UIFont.systemFontOfSize(15)
        footerView.addSubview(commentButton)
        
        likeButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: kViewPadding)
        likeButton.setTitle("赞", forState: UIControlState.Normal)
        likeButton.setTitleColor(UIColor.darkGrayColor(), forState: UIControlState.Normal)
        likeButton.titleLabel?.font = UIFont.systemFontOfSize(15)
        footerView.addSubview(likeButton)
    }
    
    /**
     初始化基本约束方法
     */
    func setupBaseConstraints() {
        
        constrain(iconView, verifiedView) { (iconView, verifiedView) in
            iconView.width == 40
            iconView.height == 40
            iconView.top == iconView.superview!.top + kViewPadding
            iconView.left == iconView.superview!.left + kViewPadding
            
            verifiedView.width == 17
            verifiedView.height == 17
            verifiedView.right == iconView.right
            verifiedView.bottom == iconView.bottom
        }
        
        constrain(nameLabel, vipView, iconView) { (nameLabel, vipView, iconView) in
            nameLabel.top == iconView.top
            nameLabel.left == iconView.right + kViewPadding
            
            vipView.width == 14
            vipView.height == 14
            vipView.centerY == nameLabel.centerY
            vipView.left ==  nameLabel.right + kViewPadding
        }
        
        constrain(timeLabel, sourceLabel, iconView) { (timeLabel, sourceLabel, iconView) in
            timeLabel.left == iconView.right + kViewPadding
            timeLabel.bottom == iconView.bottom
            
            sourceLabel.top == timeLabel.top
            sourceLabel.left == timeLabel.right + kViewPadding
        }
        
        constrain(contentLabel, iconView) { (contentLabel, iconView) in
            contentLabel.top == iconView.bottom + kViewPadding
            contentLabel.left == iconView.left
        }
        
        constrain(retweetButton, commentButton, likeButton) { (retweetButton, commentButton, likeButton) in
            retweetButton.left == retweetButton.superview!.left
            likeButton.right == likeButton.superview!.right
            
            retweetButton.width == commentButton.width
            commentButton.width == likeButton.width
            
            align(top: retweetButton, commentButton, likeButton, retweetButton.superview!)
            align(bottom: retweetButton, commentButton, likeButton, retweetButton.superview!)
            distribute(by: 0, leftToRight: retweetButton, commentButton, likeButton)
        }
    }
    
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
