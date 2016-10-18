//
//  CommentCell.swift
//		CCWeiboAPP
//		Chen Chen @ October 16th, 2016
//

import UIKit

import ActiveLabel
import Cartography
import SDWebImage

class CommentCell: UITableViewCell {

    /// 头像图片视图
    private var iconView = UIImageView()
    /// 认证图片视图
    private var verifiedView = UIImageView()
    /// 昵称标签
    private var nameLabel = UILabel(text: "", fontSize: 13, lines: 1)
    /// 时间标签
    private var timeLabel = UILabel(text: "", fontSize: 12, lines: 1)
    /// 评论内容标签
    private var commentLabel = UILabel(text: "", fontSize: 14, lines: 0)
    /// 点赞按钮
    var likeButton = UIButton(type: .Custom)
    
    /// 评论模型
    var comment: CommentModel? {
        didSet {
            let url = NSURL(string: comment!.user?.avatarLarge ?? "")
            iconView.sd_setImageWithURL(url)
            
            var image: UIImage?
            switch comment!.user?.verifiedType ?? -1 {
            case 0:
                image = UIImage(named: "avatar_vip")
                
            case 2, 3, 5:
                image = UIImage(named:"avatar_enterprise_vip")
                
            case 220:
                image = UIImage(named:"avatar_grassroot")
                
            default:
                image = nil
            }
            
            verifiedView.image = image
            
            var time: String = ""
            if let timeString = comment!.createdAt where timeString != "" {
                let date = NSDate.convertStringToDate(timeString, formatterString: "EE MM dd HH:mm:ss Z yyyy")
                time = NSDate.formatDateToString(date)
            }
            
            timeLabel.text = time
            
            nameLabel.text = comment!.user?.screenName
            commentLabel.attributedText = EmoticonManager.emoticonMutableAttributedString(comment!.text ?? "", font: commentLabel.font)
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
        
        iconView.layer.cornerRadius = kViewBorder
        iconView.clipsToBounds = true
        contentView.addSubview(iconView)
        
        verifiedView.image = UIImage(named: "avatar_vip")
        contentView.addSubview(verifiedView)
        
        contentView.addSubview(nameLabel)
        
        timeLabel.textColor = AuxiliaryTextColor
        contentView.addSubview(timeLabel)
        
        commentLabel.preferredMaxLayoutWidth = kScreenWidth - kViewStandard
        contentView.addSubview(commentLabel)
        
        likeButton.setImage(UIImage(named: "timeline_icon_unlike"), forState: .Normal)
        contentView.addSubview(likeButton)
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
        
        constrain(nameLabel, timeLabel, iconView) { (nameLabel, timeLabel, iconView) in
            nameLabel.top == iconView.top
            nameLabel.left == iconView.right + kViewPadding
            
            timeLabel.top == nameLabel.bottom + kViewEdge
            timeLabel.left == iconView.right + kViewPadding
        }
        
        constrain(commentLabel, timeLabel) { (commentLabel, timeLabel) in
            commentLabel.top == timeLabel.bottom + kViewEdge
            commentLabel.left == timeLabel.left
            commentLabel.bottom == commentLabel.superview!.bottom - kViewEdge
        }
        
        constrain(likeButton, nameLabel) { (likeButton, nameLabel) in
            likeButton.width == 15
            likeButton.height == 15
            likeButton.centerY == nameLabel.centerY
            likeButton.right == likeButton.superview!.right - kViewPadding
        }
    }
    
}
