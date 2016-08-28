//
//	iOS培训
//		小码哥
//		Chen Chen @ August 24th, 2016
//

import UIKit

import Cartography
import SDWebImage

class WeiboStatusCell: UITableViewCell {

    // Cell重用标识符
    private let pictureReuseIdentifier = "PictureCell"
    
    // 头像图片视图
    private var iconView = UIImageView()
    // 认证图片视图
    private var verifiedView = UIImageView()
    // 昵称标签
    private var nameLabel = UILabel()
    // 会员图片视图
    private var vipView = UIImageView()
    // 时间标签
    private var timeLabel = UILabel()
    // 来源标签
    private var sourceLabel = UILabel()
    // 内容标签
    private var contentLabel = UILabel()
    // 底部视图
    private var footerView = UIView()
    // 转发按钮
    private var forwardButton = UIButton(imageName: "timeline_icon_retweet", backgroundImageName: "timeline_card_bottom_background")
    // 评论按钮
    private var commentButton = UIButton(imageName: "timeline_icon_comment", backgroundImageName: "timeline_card_bottom_background")
    // 点赞按钮
    private var likeButton = UIButton(imageName: "timeline_icon_unlike", backgroundImageName: "timeline_card_bottom_background")
    // 照片集合视图
    private var pictureCollectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: PictureLayout())
    
    // 微博模型
    var viewModel: StatusViewModel? {
        didSet {
            iconView.sd_setImageWithURL(viewModel?.iconImageURL)
            verifiedView.image = viewModel?.verifiedImage
            nameLabel.text = viewModel?.status.user?.screenName
            
            vipView.image = nil
            nameLabel.textColor = UIColor.blackColor()
            if let image = viewModel?.memberRankImage {
                vipView.image = image
                nameLabel.textColor = UIColor.orangeColor()
            }
            
            timeLabel.text = viewModel?.creatTimeText
            sourceLabel.text = viewModel?.sourceText
            contentLabel.text = viewModel?.status.text
            
            pictureCollectionView.registerClass(PictureCell.self, forCellWithReuseIdentifier: pictureReuseIdentifier)
            pictureCollectionView.dataSource = self
            pictureCollectionView.reloadData()
        }
    }
    
    // MARK: - 初始化方法
    
    /**
     指定标识符初始化方法
     */
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
    }
    
    /**
     数据解码XIB初始化方法
     */
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }

    /**
     cell选中方法
     */
    override func setSelected(selected: Bool, animated: Bool) {
        
        super.setSelected(selected, animated: animated)
    }
    
    // MARK: - 界面方法
    
    /**
     初始化界面方法
     */
    private func setupUI() {
        
        iconView.layer.cornerRadius = 25
        iconView.clipsToBounds = true
        contentView.addSubview(iconView)
        
        verifiedView.image = UIImage(named: "avatar_vip")
        contentView.addSubview(verifiedView)
        
        nameLabel.font = UIFont.systemFontOfSize(15)
        contentView.addSubview(nameLabel)
        
        vipView.image = UIImage(named: "common_icon_membership")
        contentView.addSubview(vipView)
        
        timeLabel.tintColor = UIColor.orangeColor()
        timeLabel.font = UIFont.systemFontOfSize(15)
        contentView.addSubview(timeLabel)
        
        sourceLabel.font = UIFont.systemFontOfSize(15)
        contentView.addSubview(sourceLabel)
        
        contentLabel.numberOfLines = 0
        contentLabel.preferredMaxLayoutWidth = kScreenWidth - kViewMargin
        contentView.addSubview(contentLabel)

        pictureCollectionView.backgroundColor = UIColor.clearColor()
        contentView.addSubview(pictureCollectionView)
        
        contentView.addSubview(footerView)

        forwardButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: kViewPadding)
        forwardButton.setTitle("转发", forState: UIControlState.Normal)
        forwardButton.setTitleColor(UIColor.darkGrayColor(), forState: UIControlState.Normal)
        forwardButton.titleLabel?.font = UIFont.systemFontOfSize(15)
        footerView.addSubview(forwardButton)
        
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
        
        constrain(iconView, verifiedView) { (iconView, verifiedView) in
            iconView.width == 50
            iconView.height == 50
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
        
        constrain(pictureCollectionView, contentLabel) { (pictureCollectionView, contentLabel) in
            pictureCollectionView.top == contentLabel.bottom + kViewPadding
            pictureCollectionView.left == contentLabel.left
            pictureCollectionView.right == contentLabel.right
            
            pictureCollectionView.height == 300
        }
        
        constrain(footerView, pictureCollectionView) { (footerView, pictureCollectionView) in
            footerView.height == 44
            footerView.top == pictureCollectionView.bottom + kViewPadding
            footerView.left == footerView.superview!.left
            footerView.bottom == footerView.superview!.bottom
            footerView.right == footerView.superview!.right
        }
        
        constrain(forwardButton, commentButton, likeButton) { (forwardButton, commentButton, likeButton) in
            forwardButton.left == forwardButton.superview!.left
            likeButton.right == likeButton.superview!.right
            
            forwardButton.width == commentButton.width
            commentButton.width == likeButton.width
            
            align(top: forwardButton, commentButton, likeButton, forwardButton.superview!)
            align(bottom: forwardButton, commentButton, likeButton, forwardButton.superview!)
            distribute(by: 0, leftToRight: forwardButton, commentButton, likeButton)
        }
    }
    
}

extension WeiboStatusCell: UICollectionViewDataSource {
    
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
        
        return viewModel?.thumbnailPicture?.count ?? 0
    }
    
    /**
     每集内容方法
     */
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(pictureReuseIdentifier, forIndexPath: indexPath) as! PictureCell
        cell.imageCellWithURL(viewModel?.thumbnailPicture?[indexPath.item])
        return cell
    }
}

private class PictureCell: UICollectionViewCell {
    
    // 照片视图
    var imageView = UIImageView()
    
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
    
    func imageCellWithURL(url: NSURL?) {
        
        imageView.sd_setImageWithURL(url)
    }
}

private class PictureLayout: UICollectionViewFlowLayout {
    
    /**
     准备布局方法
     */
    override func prepareLayout() {
        
        let imageWidth: CGFloat = 90
        let imageHeight = imageWidth
        itemSize = CGSize(width: imageWidth, height: imageHeight)
        minimumInteritemSpacing = kViewPadding
        minimumLineSpacing = kViewMargin

        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.showsVerticalScrollIndicator = false
    }
}