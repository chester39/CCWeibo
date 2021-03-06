//
//  BaseStatusCell.swift
//      CCWeiboSwiftApp
//		Chen Chen @ November 23rd, 2016
//

import UIKit

import ActiveLabel
import Cartography
import SDWebImage

protocol BaseStatusCellDelegate: NSObjectProtocol {
    
    /**
     由URL显示网页视图方法
     */
    func statusCellDidShowWebViewWithURLString(cell: BaseStatusCell, urlString: String)
    
}

class BaseStatusCell: UITableViewCell {

    /// 头像图片视图
    var iconView = UIImageView()
    /// 认证图片视图
    var verifiedView = UIImageView()
    /// 昵称标签
    var nameLabel = UILabel(text: "", fontSize: 15, lines: 1)
    /// 会员图片视图
    var vipView = UIImageView()
    /// 时间标签
    var timeLabel = UILabel(text: "", fontSize: 12, lines: 1)
    /// 来源标签
    var sourceLabel = UILabel(text: "", fontSize: 12, lines: 1)
    /// 信息内容标签
    var contentLabel = ActiveLabel()
    /// 底部视图
    var footerView = UIView()
    /// 转发按钮
    var retweetButton = UIButton(imageName: "timeline_icon_retweet", backgroundImageName: "timeline_card_bottom_background")
    /// 评论按钮
    var commentButton = UIButton(imageName: "timeline_icon_comment", backgroundImageName: "timeline_card_bottom_background")
    /// 点赞按钮
    var likeButton = UIButton(imageName: "timeline_icon_unlike", backgroundImageName: "timeline_card_bottom_background")
    /// BaseStatusCellDelegate代理
    weak var delegate: BaseStatusCellDelegate?
    
    /// 集合布局
    lazy var flowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = kViewEdge
        layout.minimumInteritemSpacing = kViewEdge
        
        return layout
    }()
    
    /// 图片集合视图
    lazy var pictureView: PictureCollectionView = {
        let pictureView = PictureCollectionView(frame: .zero, collectionViewLayout: self.flowLayout)
        
        return pictureView
    }()
    
    /// 微博模型
    var viewModel: StatusViewModel?
    
    // MARK: - 界面方法
    
    /**
     初始化基本界面方法
     */
    func setupBaseUI() {
                
        iconView.layer.cornerRadius = kViewBorder
        iconView.clipsToBounds = true
        iconView.isUserInteractionEnabled = true
        let imageGesture = UITapGestureRecognizer(target: self, action: #selector(iconViewDidClick(gesture:)))
        iconView.addGestureRecognizer(imageGesture)
        contentView.addSubview(iconView)
        
        verifiedView.image = UIImage(named: "avatar_vip")
        contentView.addSubview(verifiedView)
        
        nameLabel.isUserInteractionEnabled = true
        let labelGesture = UITapGestureRecognizer(target: self, action: #selector(nameLabelDidClick(gesture:)))
        nameLabel.addGestureRecognizer(labelGesture)
        contentView.addSubview(nameLabel)
        
        vipView.image = UIImage(named: "common_icon_membership")
        contentView.addSubview(vipView)
        
        timeLabel.textColor = kAuxiliaryTextColor
        contentView.addSubview(timeLabel)
        
        sourceLabel.textColor = kAuxiliaryTextColor
        contentView.addSubview(sourceLabel)
        
        contentLabel.preferredMaxLayoutWidth = kScreenWidth - kViewBorder
        contentLabel.numberOfLines = 0
        contentLabel.font = UIFont.systemFont(ofSize: 15)
        contentLabel.enabledTypes = [.mention, .hashtag, .url]
        contentLabel.mentionColor = kRetweetUserTextColor
        contentLabel.hashtagColor = kMainColor
        contentView.addSubview(contentLabel)
        
        contentView.addSubview(footerView)
        
        retweetButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: kViewPadding)
        retweetButton.setTitle("转发", for: .normal)
        retweetButton.setTitleColor(kStatusTabBarTextColor, for: .normal)
        retweetButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        footerView.addSubview(retweetButton)
        
        commentButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: kViewPadding)
        commentButton.setTitle("评论", for: .normal)
        commentButton.setTitleColor(kStatusTabBarTextColor, for: .normal)
        commentButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        footerView.addSubview(commentButton)
        
        likeButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: kViewPadding)
        likeButton.setTitle("赞", for: .normal)
        likeButton.setTitleColor(kStatusTabBarTextColor, for: .normal)
        likeButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        footerView.addSubview(likeButton)
    }
    
    /**
     初始化基本约束方法
     */
    func setupBaseConstraints() {
        
        constrain(iconView, verifiedView) { iconView, verifiedView in
            iconView.width == 40
            iconView.height == 40
            iconView.top == iconView.superview!.top + kViewPadding
            iconView.left == iconView.superview!.left + kViewPadding
            
            verifiedView.width == 17
            verifiedView.height == 17
            verifiedView.right == iconView.right
            verifiedView.bottom == iconView.bottom
        }
        
        constrain(nameLabel, vipView, iconView) { nameLabel, vipView, iconView in
            nameLabel.top == iconView.top
            nameLabel.left == iconView.right + kViewPadding
            
            vipView.width == 14
            vipView.height == 14
            vipView.centerY == nameLabel.centerY
            vipView.left == nameLabel.right + kViewPadding
        }
        
        constrain(timeLabel, sourceLabel, iconView) { timeLabel, sourceLabel, iconView in
            timeLabel.left == iconView.right + kViewPadding
            timeLabel.bottom == iconView.bottom
            
            sourceLabel.top == timeLabel.top
            sourceLabel.left == timeLabel.right + kViewPadding
        }
        
        constrain(contentLabel, iconView) { contentLabel, iconView in
            contentLabel.top == iconView.bottom + kViewPadding
            contentLabel.left == iconView.left
        }
        
        constrain(retweetButton, commentButton, likeButton) { retweetButton, commentButton, likeButton in
            retweetButton.left == retweetButton.superview!.left
            likeButton.right == likeButton.superview!.right
            
            retweetButton.width == commentButton.width
            commentButton.width == likeButton.width
            
            align(top: retweetButton, commentButton, likeButton, retweetButton.superview!)
            align(bottom: retweetButton, commentButton, likeButton, retweetButton.superview!)
            distribute(by: 0, leftToRight: retweetButton, commentButton, likeButton)
        }
    }
    
    // MARK: - 点击方法
    
    /**
     头像图片视图点击方法
     */
    @objc private func iconViewDidClick(gesture: UITapGestureRecognizer) {
        
        if let id = self.viewModel?.status.user?.userID {
            let urlString = "http://weibo.com/u/\(id)"
            if let tempDelegate = delegate {
                tempDelegate.statusCellDidShowWebViewWithURLString(cell: self, urlString: urlString)
            }
        }
    }
    
    /**
     昵称标签点击方法
     */
    @objc private func nameLabelDidClick(gesture: UITapGestureRecognizer) {
        
        if let id = self.viewModel?.status.user?.userID {
            let urlString = "http://weibo.com/u/\(id)"
            if let tempDelegate = delegate {
                tempDelegate.statusCellDidShowWebViewWithURLString(cell: self, urlString: urlString)
            }
        }
    }

}
