//
//  PersonView.swift
//		CCWeiboAPP
//		Chen Chen @ October 9th, 2016
//

import UIKit

import Cartography

class PersonView: UIView {
    
    /// 头像图片视图
    var iconView = UIImageView()
    /// 昵称标签
    var nameLabel = UILabel(text: "", fontSize: 15, lines: 1)
    /// 简介标签
    var introLabel = UILabel(text: "", fontSize: 12, lines: 1)
    /// 会员按钮
    private var vipButton = UIButton(type: .Custom)
    /// 分割线
    private var divideLine = UIView()
    /// 微博数视图
    var statusesView = TitleView(frame: CGRectZero)
    /// 关注数视图
    var friendsView = TitleView(frame: CGRectZero)
    /// 粉丝数视图
    var followersView = TitleView(frame: CGRectZero)
    
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

        iconView.layer.cornerRadius = 20.0
        iconView.clipsToBounds = true
        addSubview(iconView)
        
        addSubview(nameLabel)
        
        introLabel.textColor = AuxiliaryTextColor
        addSubview(introLabel)
        
        vipButton.setImage(UIImage(named: "common_icon_membership"), forState: .Normal)
        vipButton.setTitle("会员", forState: .Normal)
        vipButton.setTitleColor(MainColor, forState: .Normal)
        vipButton.titleLabel?.font = UIFont.systemFontOfSize(14)
        vipButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: kViewPadding)
        addSubview(vipButton)
        
        divideLine.backgroundColor = DivideLineColor
        addSubview(divideLine)
        
        statusesView.subtitleLabel.text = "微博"
        statusesView.subtitleLabel.textColor = AuxiliaryTextColor
        addSubview(statusesView)
        
        friendsView.subtitleLabel.text = "关注"
        friendsView.subtitleLabel.textColor = AuxiliaryTextColor
        addSubview(friendsView)
        
        followersView.subtitleLabel.text = "微博"
        followersView.subtitleLabel.textColor = AuxiliaryTextColor
        addSubview(followersView)
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
        
        constrain(divideLine, iconView) { (divideLine, iconView) in
            divideLine.height == 1
            divideLine.top == iconView.bottom + kViewEdge
            divideLine.left == divideLine.superview!.left + kViewEdge
            divideLine.right == divideLine.superview!.right - kViewEdge
        }
        
        constrain(statusesView, friendsView, followersView) { (statusesView, friendsView, followersView) in
            statusesView.width == friendsView.width
            friendsView.width == followersView.width
            
            statusesView.height == 40
            friendsView.height == statusesView.height
            followersView.height == statusesView.height
            
            statusesView.left == statusesView.superview!.left
            followersView.right == followersView.superview!.right
            
            statusesView.bottom == statusesView.superview!.bottom
            friendsView.bottom == statusesView.superview!.bottom
            followersView.bottom == followersView.superview!.bottom

            distribute(by: 0, leftToRight: statusesView, friendsView, followersView)
        }
    }

}
