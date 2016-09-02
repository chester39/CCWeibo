//
//	RetweetStatusCell.swift
//		CCWeiboAPP
//		Chen Chen @ August 31st, 2016
//

import UIKit

import Cartography
import SDWebImage

class RetweetStatusCell: BaseWeiboCell {

    // 变化约束组
    private var group = ConstraintGroup()
    // 转发微博视图
    private var retweetView = UIView()
    // 转发微博信息内容
    private var retweetLabel = UILabel(text: "", fontSize: 14, lines: 0)

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
            
            if viewModel?.status.repostsCount != 0 {
                retweetButton.setTitle("\(viewModel!.status.repostsCount)", forState: UIControlState.Normal)
            }
            
            if viewModel?.status.commentsCount != 0 {
                commentButton.setTitle("\(viewModel!.status.commentsCount)", forState: UIControlState.Normal)
            }
            
            if viewModel?.status.attitudesCount != 0 {
                likeButton.setTitle("\(viewModel!.status.attitudesCount)", forState: UIControlState.Normal)
            }
            
            retweetLabel.attributedText = viewModel?.retweetText
            pictureView.viewModel = viewModel
            
            let (cellSize, collectionSize) = pictureView.acquireLayoutSize()
            if cellSize != CGSizeZero {
                flowLayout.itemSize = cellSize
            }
            
            constrain(clear: group)
            constrain(pictureView, replace: group) { (pictureView) in
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
        retweetView.layer.cornerRadius = 5.0
        retweetView.layer.borderWidth = 1.0
        retweetView.layer.borderColor = UIColor(hex: 0xE5E5E5).CGColor
        retweetView.backgroundColor = UIColor(hex: 0xE5E5E5)
        contentView.addSubview(retweetView)
        
        retweetLabel.preferredMaxLayoutWidth = kScreenWidth - kViewMargin
        retweetView.addSubview(retweetLabel)
        retweetView.addSubview(pictureView)
    }
    
    /**
     初始化约束方法
     */
    private func setupConstraints() {
        
        constrain(retweetView, contentLabel, footerView) { (retweetView, contentLabel, footerView) in
            retweetView.top == contentLabel.bottom + kViewBorder
            retweetView.left == retweetView.superview!.left
            retweetView.bottom == footerView.top
            retweetView.right == retweetView.superview!.right
        }
        
        constrain(retweetLabel, pictureView) { (retweetLabel, pictureView) in
            retweetLabel.top == retweetLabel.superview!.top + kViewBorder
            retweetLabel.left == retweetLabel.superview!.left + kViewBorder
            
            pictureView.top == retweetLabel.bottom + kViewBorder
            pictureView.left == retweetLabel.left
        }
        
        constrain(pictureView, replace: group) { (pictureView) in
            pictureView.width == 300
            pictureView.height == 100
        }
        
        constrain(footerView, pictureView) { (footerView, pictureView) in
            footerView.height == kNavigationBarHeight
            footerView.top == pictureView.bottom + kViewBorder
            footerView.left == footerView.superview!.left
            footerView.bottom == footerView.superview!.bottom - kViewBorder
            footerView.right == footerView.superview!.right
        }
    }
    
}
