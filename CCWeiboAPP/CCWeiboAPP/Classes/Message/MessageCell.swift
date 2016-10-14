//
//  MessageCell.swift
//		CCWeiboAPP
//		Chen Chen @ October 13th, 2016
//

import UIKit

import Cartography

class MessageCell: UITableViewCell {

    /// 头像图片视图
    var iconView = UIImageView()
    /// 认证图片视图
    var verifiedView = UIImageView()
    /// 昵称标签
    var nameLabel = UILabel(text: "", fontSize: 15, lines: 1)
    /// 信息内容标签
    var contentLabel = UILabel(text: "", fontSize: 13, lines: 1)
    /// 时间标签
    var timeLabel = UILabel(text: "", fontSize: 12, lines: 1)
    /// 消息标签
    var messageLabel = UILabel(text: "", fontSize: 12, lines: 1)

    /// 微博模型
    var viewModel: StatusViewModel? {
        didSet {
            iconView.sd_setImageWithURL(viewModel?.iconImageURL)
            verifiedView.image = viewModel?.verifiedImage
            
            nameLabel.text = viewModel?.status.user?.screenName
            contentLabel.text = viewModel?.status.text
            
            timeLabel.text = viewModel?.creatTimeText

            if viewModel!.status.commentsCount == 0 {
                messageLabel.hidden = true
            }
            
            messageLabel.text = "\(viewModel!.status.commentsCount)"
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
        
        iconView.layer.cornerRadius = 20.0
        iconView.clipsToBounds = true
        contentView.addSubview(iconView)
        
        verifiedView.image = UIImage(named: "avatar_vip")
        contentView.addSubview(verifiedView)
        
        contentView.addSubview(nameLabel)
        
        timeLabel.textColor = AuxiliaryTextColor
        contentView.addSubview(timeLabel)
        
        messageLabel.textColor = CommonLightColor
        messageLabel.layer.cornerRadius = kViewEdge
        messageLabel.clipsToBounds = true
        messageLabel.backgroundColor = MainColor
        contentView.addSubview(messageLabel)
        
        contentLabel.textColor = AuxiliaryTextColor
        contentView.addSubview(contentLabel)
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
        
        constrain(nameLabel, contentLabel, iconView) { (nameLabel, contentLabel, iconView) in
            nameLabel.top == iconView.top
            nameLabel.left == iconView.right + kViewPadding
            
            contentLabel.width == kScreenWidth - kViewStandard
            contentLabel.top == nameLabel.bottom + kViewEdge
            contentLabel.left == iconView.right + kViewPadding
            contentLabel.bottom == contentLabel.superview!.bottom - kViewEdge
        }
        
        constrain(timeLabel, nameLabel) { (timeLabel, nameLabel) in
            timeLabel.right == timeLabel.superview!.right - kViewPadding
            timeLabel.centerY == nameLabel.centerY
        }
        
        constrain(messageLabel, contentLabel) { (messageLabel, contentLabel) in
            messageLabel.right == messageLabel.superview!.right - kViewPadding
            messageLabel.centerY == contentLabel.centerY
        }
    }

}
