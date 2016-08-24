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
    // 微博模型
    var status: StatusModel? {
        didSet {
            if let urlString = status?.user?.avatarLarge {
                let url = NSURL(string: urlString)
                iconView.sd_setImageWithURL(url)
            }
            
            if let type = status?.user?.verifiedType {
                var name = ""
                switch type {
                case 0:
                    name = "avatar_vip"
                case 2, 3, 5:
                    name = "avatar_enterprise_vip"
                case 220:
                    name = "avatar_grassroot"
                default:
                    name = ""
                }
                verifiedView.image = UIImage(named: name)
            }
            
            nameLabel.text = status?.user?.screenName
            
            if let rank = status?.user?.memberRank {
                if rank >= 1 && rank <= 6 {
                    vipView.image = UIImage(named: "common_icon_membership_level\(rank)")
                    nameLabel.textColor = UIColor.orangeColor()
                } else {
                    vipView.image = nil
                    nameLabel.textColor = UIColor.blackColor()
                }
            }
            
            if let timeString = status?.createdAt {
                let date = NSDate.convertStringToDate(timeString, formatterString: "EE MM dd HH:mm:ss Z yyyy")
                timeLabel.text = NSDate.formatDateToString(date)
            }
            
            if let sourceString: NSString = status?.source where sourceString != "" {
                let startIndex = sourceString.rangeOfString(">").location + 1
                let length = sourceString.rangeOfString("<", options: NSStringCompareOptions.BackwardsSearch).location - startIndex
                let restString = sourceString.substringWithRange(NSMakeRange(startIndex, length))
                sourceLabel.text = "来自: " + restString
            }
            
            contentLabel.text = status?.text
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
        
        iconView.layer.cornerRadius = 30
        iconView.clipsToBounds = true
        contentView.addSubview(iconView)
        
        verifiedView.image = UIImage(named: "avatar_vip")
        contentView.addSubview(verifiedView)
        
        contentView.addSubview(nameLabel)
        
        vipView.image = UIImage(named: "common_icon_membership")
        contentView.addSubview(vipView)
        
        timeLabel.tintColor = UIColor.orangeColor()
        contentView.addSubview(timeLabel)
        
        contentView.addSubview(sourceLabel)
        
        contentLabel.numberOfLines = 0
        contentLabel.preferredMaxLayoutWidth = kScreenWidth - kViewMargin
        contentView.addSubview(contentLabel)
        
        constrain(iconView, verifiedView) { (iconView, verifiedView) in
            iconView.width == 60
            iconView.height == 60
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
            contentLabel.bottom == contentLabel.superview!.bottom - kViewMargin
        }
    }
    
}
