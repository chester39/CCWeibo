//
//	iOS培训
//		小码哥
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
    // 转发微博用户昵称标签
    private var retweetNameLabel = UILabel(text: "", fontSize: 14, lines: 1)
    // 转发微博用户认证图片视图
    private var retweetVerifiedView = UIImageView()
    // 转发微博会员图片视图
    private var retweetVipView = UIImageView()
    // 转发微博信息内容标签
    private var retweetContentLabel = UILabel(text: "", fontSize: 13, lines: 0)
    // 转发微博时间标签
    private var retweetTimeLabel = UILabel(text: "", fontSize: 12, lines: 1)
    // 转发微博来源标签
    private var retweetSourceLabel = UILabel(text: "", fontSize: 12, lines: 1)

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
            
            retweetNameLabel.text = viewModel?.retweetScreenNameText
            retweetVerifiedView.image = viewModel?.retweetVerifiedImage
            retweetVipView.image = nil
            if let image = viewModel?.retweetMemberRankImage {
                retweetVipView.image = image
            }
            
            retweetContentLabel.text = viewModel?.status.retweetedStatus?.text
            retweetTimeLabel.text = viewModel?.retweetCreatTimeText
            retweetSourceLabel.text = viewModel?.retweetSourceText
            
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
        retweetView.layer.borderColor = UIColor(hex: 0xdddddd).CGColor
        retweetView.backgroundColor = UIColor(hex: 0xdddddd)
        contentView.addSubview(retweetView)
        
        retweetView.addSubview(retweetNameLabel)
        
        retweetVerifiedView.image = UIImage(named: "avatar_vip")
        retweetView.addSubview(retweetVerifiedView)
        
        vipView.image = UIImage(named: "common_icon_membership")
        retweetView.addSubview(retweetVipView)
        
        retweetContentLabel.preferredMaxLayoutWidth = kScreenWidth - kViewMargin
        retweetView.addSubview(retweetContentLabel)
        
        retweetView.addSubview(pictureView)
        
        retweetTimeLabel.textColor = UIColor(hex: 0xa5a5a5)
        retweetView.addSubview(retweetTimeLabel)
        
        retweetSourceLabel.textColor = UIColor(hex: 0xa5a5a5)
        retweetView.addSubview(retweetSourceLabel)
    }
    
    /**
     初始化约束方法
     */
    private func setupConstraints() {
        
        constrain(retweetView, contentLabel, footerView) { (retweetView, contentLabel, footerView) in
            retweetView.top == contentLabel.bottom + kViewPadding
            retweetView.left == retweetView.superview!.left
            retweetView.bottom == footerView.top
            retweetView.right == retweetView.superview!.right
        }
        
        constrain(retweetNameLabel, retweetVerifiedView, retweetVipView) { (retweetNameLabel, retweetVerifiedView, retweetVipView) in
            retweetNameLabel.top == retweetNameLabel.superview!.top + kViewPadding
            retweetNameLabel.left == retweetNameLabel.superview!.left + kViewPadding
            
            retweetVerifiedView.width == 17
            retweetVerifiedView.height == 17
            
            retweetVipView.width == 14
            retweetVipView.height == 14
            
            align(centerY: retweetNameLabel, retweetVerifiedView, retweetVipView)
            distribute(by: 0, leftToRight: retweetNameLabel, retweetVerifiedView, retweetVipView)
        }
        
        constrain(retweetContentLabel, pictureView, retweetNameLabel) { (retweetContentLabel, pictureView, retweetNameLabel) in
            align(left: retweetNameLabel, retweetContentLabel, pictureView)
            distribute(by: kViewPadding, vertically: retweetNameLabel, retweetContentLabel, pictureView)
        }
        
        constrain(pictureView, replace: group) { (pictureView) in
            pictureView.width == 290
            pictureView.height == 90
        }
        
        constrain(retweetTimeLabel, retweetSourceLabel, pictureView) { (retweetTimeLabel, retweetSourceLabel, pictureView) in
            retweetTimeLabel.top == pictureView.bottom + kViewPadding
            retweetTimeLabel.left == pictureView.left
            
            retweetSourceLabel.top == retweetTimeLabel.top
            retweetSourceLabel.left == retweetTimeLabel.right + kViewPadding
        }
        
        constrain(footerView, retweetTimeLabel) { (footerView, retweetTimeLabel) in
            footerView.height == kNavigationBarHeight
            footerView.top == retweetTimeLabel.bottom + kViewPadding
            footerView.left == footerView.superview!.left
            footerView.bottom == footerView.superview!.bottom - kViewPadding
            footerView.right == footerView.superview!.right
        }
    }
    
}
