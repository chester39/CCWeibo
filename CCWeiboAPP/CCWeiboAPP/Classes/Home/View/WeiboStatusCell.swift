//
//	iOS培训
//		小码哥
//		Chen Chen @ August 24th, 2016
//

import UIKit

import Cartography
import SDWebImage

class WeiboStatusCell: BaseWeiboCell {

    // 变化约束组
    private var group = ConstraintGroup()
    
    // 微博模型
    override var viewModel: StatusViewModel? {
        didSet {
            iconView.sd_setImageWithURL(viewModel?.iconImageURL)
            verifiedView.image = viewModel?.verifiedImage
            nameLabel.text = viewModel?.status.user?.screenName
            
            vipView.image = nil
            if let image = viewModel?.memberRankImage {
                vipView.image = image
                nameLabel.textColor = UIColor.orangeColor()
            }
            
            timeLabel.text = viewModel?.creatTimeText
            sourceLabel.text = viewModel?.sourceText
            contentLabel.text = viewModel?.status.text
            
            pictureCollectionView.registerClass(PictureCell.self, forCellWithReuseIdentifier: pictureReuseIdentifier)
            pictureCollectionView.dataSource = self
            pictureCollectionView.showsVerticalScrollIndicator = false
            pictureCollectionView.showsHorizontalScrollIndicator = false
            pictureCollectionView.reloadData()
            
            let (cellSize, collectionSize) = setupPictureCollectionView()
            if cellSize != CGSizeZero {
                flowLayout.itemSize = cellSize
            }
            
            constrain(clear: group)
            
            constrain(pictureCollectionView, replace: group) { (pictureCollectionView) in
                pictureCollectionView.width == collectionSize.width
                pictureCollectionView.height == collectionSize.height
            }
            
            self.layoutIfNeeded()
        }
    }
    
    // MARK: - 初始化方法
    
    /**
     指定标识符初始化方法
     */
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
        setupConstraints()
    }
    
    /**
     数据解码XIB初始化方法
     */
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 界面方法
    
    /**
     初始化界面方法
     */
    private func setupUI() {
        
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

        pictureCollectionView.backgroundColor = UIColor.clearColor()
        contentView.addSubview(pictureCollectionView)
        
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
     初始化约束方法
     */
    private func setupConstraints() {
        
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
        
        constrain(pictureCollectionView, contentLabel) { (pictureCollectionView, contentLabel) in
            pictureCollectionView.top == contentLabel.bottom + kViewPadding
            pictureCollectionView.left == contentLabel.left
        }
        
        constrain(pictureCollectionView, replace: group) { (pictureCollectionView) in
            pictureCollectionView.width == 290
            pictureCollectionView.height == 90
        }
        
        constrain(footerView, pictureCollectionView) { (footerView, pictureCollectionView) in
            footerView.height == 44
            footerView.top == pictureCollectionView.bottom + kViewPadding
            footerView.left == footerView.superview!.left
            footerView.bottom == footerView.superview!.bottom
            footerView.right == footerView.superview!.right
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
    
}