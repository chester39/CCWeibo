//
//	BaseStatusCell.swift
//		CCWeiboAPP
//		Chen Chen @ August 31st, 2016
//

import UIKit

import Cartography
import SDWebImage

class BaseStatusCell: UITableViewCell {

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
    // 信息内容标签
    var contentLabel = UILabel(text: "", fontSize: 15, lines: 0)
    // 底部视图
    var footerView = UIView()
    // 转发按钮
    var retweetButton = UIButton(imageName: "timeline_icon_retweet", backgroundImageName: "timeline_card_bottom_background")
    // 评论按钮
    var commentButton = UIButton(imageName: "timeline_icon_comment", backgroundImageName: "timeline_card_bottom_background")
    // 点赞按钮
    var likeButton = UIButton(imageName: "timeline_icon_unlike", backgroundImageName: "timeline_card_bottom_background")

    // 集合布局
    lazy var flowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = kViewPadding
        layout.minimumInteritemSpacing = kViewPadding
        
        return layout
    }()
    
    // 图片集合视图
    lazy var pictureView: PictureCollectionView = {
        let pictureView = PictureCollectionView(frame: CGRectZero, collectionViewLayout: self.flowLayout)
        
        return pictureView
    }()
    
    // 微博模型
    var viewModel: StatusViewModel?
    
    // MARK: - 界面方法
    
    /**
     初始化基本界面方法
     */
    func setupBaseUI() {
        
        iconView.layer.cornerRadius = 20.0
        iconView.clipsToBounds = true
        contentView.addSubview(iconView)
        
        verifiedView.image = UIImage(named: "avatar_vip")
        contentView.addSubview(verifiedView)
        
        contentView.addSubview(nameLabel)
        
        vipView.image = UIImage(named: "common_icon_membership")
        contentView.addSubview(vipView)
        
        timeLabel.textColor = UIColor(hex: 0xA5A5A5)
        contentView.addSubview(timeLabel)
        
        sourceLabel.textColor = UIColor(hex: 0xA5A5A5)
        contentView.addSubview(sourceLabel)
        
        contentLabel.preferredMaxLayoutWidth = kScreenWidth - kViewMargin
        contentView.addSubview(contentLabel)
        
        contentView.addSubview(footerView)
        
        retweetButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: kViewBorder)
        retweetButton.setTitle("转发", forState: UIControlState.Normal)
        retweetButton.setTitleColor(UIColor.darkGrayColor(), forState: UIControlState.Normal)
        retweetButton.titleLabel?.font = UIFont.systemFontOfSize(15)
        footerView.addSubview(retweetButton)
        
        commentButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: kViewBorder)
        commentButton.setTitle("评论", forState: UIControlState.Normal)
        commentButton.setTitleColor(UIColor.darkGrayColor(), forState: UIControlState.Normal)
        commentButton.titleLabel?.font = UIFont.systemFontOfSize(15)
        footerView.addSubview(commentButton)
        
        likeButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: kViewBorder)
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
            iconView.top == iconView.superview!.top + kViewBorder
            iconView.left == iconView.superview!.left + kViewBorder
            
            verifiedView.width == 17
            verifiedView.height == 17
            verifiedView.right == iconView.right
            verifiedView.bottom == iconView.bottom
        }
        
        constrain(nameLabel, vipView, iconView) { (nameLabel, vipView, iconView) in
            nameLabel.top == iconView.top
            nameLabel.left == iconView.right + kViewBorder
            
            vipView.width == 14
            vipView.height == 14
            vipView.centerY == nameLabel.centerY
            vipView.left == nameLabel.right + kViewBorder
        }
        
        constrain(timeLabel, sourceLabel, iconView) { (timeLabel, sourceLabel, iconView) in
            timeLabel.left == iconView.right + kViewBorder
            timeLabel.bottom == iconView.bottom
            
            sourceLabel.top == timeLabel.top
            sourceLabel.left == timeLabel.right + kViewBorder
        }
        
        constrain(contentLabel, iconView) { (contentLabel, iconView) in
            contentLabel.top == iconView.bottom + kViewBorder
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
    
}