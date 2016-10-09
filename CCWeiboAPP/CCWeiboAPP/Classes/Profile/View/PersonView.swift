//
//  PersonView.swift
//		CCWeiboAPP
//		Chen Chen @ October 9th, 2016
//

import UIKit

import Cartography

class PersonView: UIView {
    
    /// 头像图片视图
    private var iconView = UIImageView()
    /// 昵称标签
    private var nameLabel = UILabel(text: "", fontSize: 15, lines: 1)
    /// 简介标签
    private var introLabel = UILabel(text: "", fontSize: 12, lines: 1)
    /// 会员按钮
    private var vipButton = UIButton(type: .Custom)
    /// 底部视图
    private var footerView = UIView()
    /// 微博数视图
    private var statusesView = TitleView(frame: CGRectZero)
    /// 关注数视图
    private var friendsView = TitleView(frame: CGRectZero)
    /// 粉丝数视图
    private var followersView = TitleView(frame: CGRectZero)
    
    // MARK: - 初始化方法
    
    /**
     自定义初始化方法
     */
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
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
        
        assert(UserAccount.loadUserAccount() != nil, "必须授权之后才能使用用户数据")
        guard let user = UserAccount.loadUserAccount() else {
            return
        }

        iconView.layer.cornerRadius = 20.0
        iconView.clipsToBounds = true
        iconView.sd_setImageWithURL(NSURL(string: user.avatarLarge!))
        addSubview(iconView)

        nameLabel.text = user.screenName!
        addSubview(nameLabel)
        
        let intro = user.descriptionIntro!
        let text = (intro == "" ? "暂无介绍" : intro)
        introLabel.textColor = AuxiliaryTextColor
        introLabel.text = "简介：\(text)"
        addSubview(introLabel)
        
        vipButton.setImage(UIImage(named: "common_icon_membership"), forState: .Normal)
        vipButton.setTitle("会员", forState: .Normal)
        vipButton.setTitleColor(MainColor, forState: .Normal)
        vipButton.titleLabel?.font = UIFont.systemFontOfSize(14)
        vipButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: kViewPadding)
        addSubview(vipButton)

        footerView.layer.borderWidth = 1.0
        footerView.layer.borderColor = AuxiliaryTextColor.CGColor
        addSubview(footerView)
        
        statusesView.titleLabel.text = String(user.statusesCount)
        statusesView.subtitleLabel.text = "微博"
        statusesView.subtitleLabel.textColor = AuxiliaryTextColor
        footerView.addSubview(statusesView)
        
        friendsView.titleLabel.text = String(user.friendsCount)
        friendsView.subtitleLabel.text = "关注"
        friendsView.subtitleLabel.textColor = AuxiliaryTextColor
        footerView.addSubview(friendsView)
        
        followersView.titleLabel.text = String(user.followersCount)
        followersView.subtitleLabel.text = "微博"
        followersView.subtitleLabel.textColor = AuxiliaryTextColor
        footerView.addSubview(followersView)
    }
    
    /**
     初始化约束方法
     */
    private func setupConstraints() {
        
        constrain(iconView, nameLabel, introLabel) { (iconView, nameLabel, introLabel) in
            iconView.width == 40
            iconView.height == 40
            iconView.top == iconView.superview!.top + kViewPadding
            iconView.left == iconView.superview!.left + kViewPadding

            nameLabel.top == iconView.top
            nameLabel.left == iconView.right + kViewPadding
            
            introLabel.bottom == iconView.bottom
            introLabel.left == iconView.right + kViewPadding
        }
        
        constrain(vipButton) { (vipButton) in
            vipButton.width == 60
            vipButton.height == 30
            vipButton.top == vipButton.superview!.top  + kViewPadding
            vipButton.right == vipButton.superview!.right - kViewPadding
        }
        
        constrain(footerView, iconView) { (footerView, iconView) in
            footerView.top == iconView.bottom + kViewPadding
            footerView.left == footerView.superview!.left
            footerView.bottom == footerView.superview!.bottom
            footerView.right == footerView.superview!.right
        }
        
        constrain(statusesView, friendsView, followersView) { (statusesView, friendsView, followersView) in
            statusesView.left == statusesView.superview!.left
            followersView.right == followersView.superview!.right
            
            statusesView.width == friendsView.width
            friendsView.width == followersView.width
            
            statusesView.height == 50
            friendsView.height == statusesView.height
            followersView.height == statusesView.height
            
            align(top: statusesView, friendsView, followersView, statusesView.superview!)
            align(bottom: statusesView, friendsView, followersView, statusesView.superview!)
            distribute(by: 0, leftToRight: statusesView, friendsView, followersView)
        }
    }

}
