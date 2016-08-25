//
//	iOS培训
//		小码哥
//		Chen Chen @ August 24th, 2016
//

import UIKit

import Cartography
import SDWebImage

class WeiboStatusCell: UITableViewCell {

    // 头像图片视图
    var iconView = UIImageView()
    // 认证图片视图
    var verifiedView = UIImageView()
    // 昵称标签
    var nameLabel = UILabel()
    // 会员图片视图
    var vipView = UIImageView()
    // 时间标签
    var timeLabel = UILabel()
    // 来源标签
    var sourceLabel = UILabel()
    // 内容标签
    var contentLabel = UILabel()
    // 底部视图
    var bottomBarView = UIView()
    // 转发按钮
    var forwardButton = UIButton()
    // 评论按钮
    var commentButton = UIButton()
    // 点赞按钮
    var likeButton = UIButton()
    
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
        
        contentView.addSubview(bottomBarView)

        forwardButton = UIButton(imageName: "timeline_icon_retweet", backgroundImageName: "timeline_card_bottom_background")
        forwardButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: kViewPadding)
        forwardButton.setTitle("转发", forState: UIControlState.Normal)
        forwardButton.setTitleColor(UIColor.darkGrayColor(), forState: UIControlState.Normal)
        forwardButton.titleLabel?.font = UIFont.systemFontOfSize(15)
        bottomBarView.addSubview(forwardButton)
        
        commentButton = UIButton(imageName: "timeline_icon_comment", backgroundImageName: "timeline_card_bottom_background")
        commentButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: kViewPadding)
        commentButton.setTitle("评论", forState: UIControlState.Normal)
        commentButton.setTitleColor(UIColor.darkGrayColor(), forState: UIControlState.Normal)
        commentButton.titleLabel?.font = UIFont.systemFontOfSize(15)
        bottomBarView.addSubview(commentButton)
        
        likeButton = UIButton(imageName: "timeline_icon_unlike", backgroundImageName: "timeline_card_bottom_background")
        likeButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: kViewPadding)
        likeButton.setTitle("赞", forState: UIControlState.Normal)
        likeButton.setTitleColor(UIColor.darkGrayColor(), forState: UIControlState.Normal)
        likeButton.titleLabel?.font = UIFont.systemFontOfSize(15)
        bottomBarView.addSubview(likeButton)
        
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
        
        constrain(bottomBarView, contentLabel) { (bottomBarView, contentLabel) in
            bottomBarView.height == 44
            bottomBarView.top == contentLabel.bottom + kViewPadding
            bottomBarView.left == bottomBarView.superview!.left
            bottomBarView.bottom == bottomBarView.superview!.bottom
            bottomBarView.right == bottomBarView.superview!.right
        }
        
        constrain(forwardButton, commentButton, likeButton) { (forwardButton, commentButton, likeButton) in
            forwardButton.left == forwardButton.superview!.left

            likeButton.right == likeButton.superview!.right
            forwardButton.width == commentButton.width
            commentButton.width == likeButton.width
            
            
            
            distribute(by: 0, leftToRight: forwardButton, commentButton, likeButton)
            
            align(top: forwardButton, commentButton, likeButton, forwardButton.superview!)
            align(bottom: forwardButton, commentButton, likeButton, forwardButton.superview!)
        }
    }
    
}
