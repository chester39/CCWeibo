//
//  WeiboStatusCell.swift
//      CCWeiboSwiftApp
//		Chen Chen @ November 23rd, 2016
//

import UIKit

import Cartography
import SDWebImage

class WeiboStatusCell: BaseStatusCell {

    /// 变化约束组
    private var group = ConstraintGroup()
    
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
        
        contentView.addSubview(pictureView)
    }
    
    /**
     初始化约束方法
     */
    private func setupConstraints() {
        
        constrain(pictureView, contentLabel) { pictureView, contentLabel in
            pictureView.top == contentLabel.bottom + kViewPadding
            pictureView.left == contentLabel.left
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
