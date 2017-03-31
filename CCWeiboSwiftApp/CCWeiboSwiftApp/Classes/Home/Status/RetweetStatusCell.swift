//
//  RetweetStatusCell.swift
//  CCWeiboSwiftApp
//
//  Created by Chester Chen on 2016/11/23.
//  Copyright © 2016年 Chen Chen. All rights reserved.
//

import UIKit
import WebKit

import ActiveLabel
import Cartography
import SDWebImage

class RetweetStatusCell: BaseStatusCell {
    
    /// 变化约束组
    private var group = ConstraintGroup()
    /// 转发微博视图
    private var retweetView = UIView()
    
    /// 转发微博信息内容
    private var retweetLabel: ActiveLabel = {
        let label = ActiveLabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 14)
        label.enabledTypes = [.mention, .hashtag, .url]
        label.mentionColor = kRetweetUserTextColor
        label.hashtagColor = kMainColor
        
        return label
    }()
    
    /// 微博模型
    override var viewModel: StatusViewModel? {
        didSet {
            iconView.sd_setImage(with: viewModel?.iconImageURL)
            verifiedView.image = viewModel?.verifiedImage
            nameLabel.text = viewModel?.status.user?.screenName
            
            vipView.image = nil
            if let image = viewModel?.memberRankImage {
                vipView.image = image
                nameLabel.textColor = kMainColor
            }
            
            timeLabel.text = viewModel?.creatTimeText
            sourceLabel.text = viewModel?.sourceText
            
            contentLabel.attributedText = EmoticonManager.emoticonMutableAttributedString(string: viewModel?.status.text ?? "", font: contentLabel.font)
            contentLabel.handleURLTap { url in
                if let tempDelegate = self.delegate {
                    let urlString = url.absoluteString
                    tempDelegate.statusCellDidShowWebViewWithURLString(cell: self, urlString: urlString)
                }
            }
            
            if viewModel?.status.repostsCount != 0 {
                retweetButton.setTitle("\(viewModel!.status.repostsCount)", for: .normal)
            }
            
            if viewModel?.status.commentsCount != 0 {
                commentButton.setTitle("\(viewModel!.status.commentsCount)", for: .normal)
            }
            
            if viewModel?.status.attitudesCount != 0 {
                likeButton.setTitle("\(viewModel!.status.attitudesCount)", for: .normal)
            }
            
            retweetLabel.attributedText = EmoticonManager.emoticonMutableAttributedString(string: viewModel?.retweetText ?? "", font: contentLabel.font)
            retweetLabel.handleURLTap { url in
                if let tempDelegate = self.delegate {
                    let urlString = url.absoluteString
                    tempDelegate.statusCellDidShowWebViewWithURLString(cell: self, urlString: urlString)
                }
            }
            
            retweetLabel.handleMentionTap { mention in
                guard let id = self.viewModel?.status.retweetedStatus?.user?.userID else {
                    return
                }
                
                let urlString = "http://weibo.com/u/\(id)"
                if let tempDelegate = self.delegate {
                    tempDelegate.statusCellDidShowWebViewWithURLString(cell: self, urlString: urlString)
                }
            }
            
            pictureView.viewModel = viewModel
            let (cellSize, collectionSize) = pictureView.acquireLayoutSize()
            if cellSize != .zero {
                flowLayout.itemSize = cellSize
            }
            
            constrain(clear: group)
            constrain(pictureView, replace: group) { pictureView in
                pictureView.width == collectionSize.width
                pictureView.height == collectionSize.height
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
        
        super.setupBaseUI()
        setupUI()
        super.setupBaseConstraints()
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
        
        retweetView.clipsToBounds = true
        retweetView.layer.cornerRadius = kViewEdge
        retweetView.layer.borderWidth = 1.0
        retweetView.layer.borderColor = kRetweetStatusBackgroundColor.cgColor
        retweetView.backgroundColor = kRetweetStatusBackgroundColor
        contentView.addSubview(retweetView)
        
        retweetLabel.preferredMaxLayoutWidth = kScreenWidth - kViewBorder
        retweetView.addSubview(retweetLabel)
        retweetView.addSubview(pictureView)
    }
    
    /**
     初始化约束方法
     */
    private func setupConstraints() {
        
        constrain(retweetView, contentLabel, footerView) { retweetView, contentLabel, footerView in
            retweetView.top == contentLabel.bottom + kViewPadding
            retweetView.left == retweetView.superview!.left
            retweetView.bottom == footerView.top
            retweetView.right == retweetView.superview!.right
        }
        
        constrain(retweetLabel, pictureView) { retweetLabel, pictureView in
            retweetLabel.top == retweetLabel.superview!.top + kViewPadding
            retweetLabel.left == retweetLabel.superview!.left + kViewPadding
            
            pictureView.top == retweetLabel.bottom + kViewPadding
            pictureView.left == retweetLabel.left
        }
        
        constrain(pictureView, replace: group) { pictureView in
            pictureView.width == 300
            pictureView.height == kViewStandard
        }
        
        constrain(footerView, pictureView) { footerView, pictureView in
            footerView.height == kNavigationBarHeight
            footerView.top == pictureView.bottom + kViewPadding
            footerView.left == footerView.superview!.left
            footerView.bottom == footerView.superview!.bottom - kViewPadding
            footerView.right == footerView.superview!.right
        }
    }
    
}
