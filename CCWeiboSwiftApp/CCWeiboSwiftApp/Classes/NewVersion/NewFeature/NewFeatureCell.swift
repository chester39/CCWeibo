//
//  NewFeatureCell.swift
//      CCWeiboSwiftApp
//		Chen Chen @ November 25th, 2016
//

import UIKit

import Cartography

class NewFeatureCell: UICollectionViewCell {
    
    /// 图片视图
    private lazy var imageView = UIImageView()
    
    /// 图片下标
    var index: Int = 0 {
        didSet {
            let name = "new_feature_\(index + 1)"
            imageView.image = UIImage(named: name)
            startButton.isHidden = true
        }
    }
    
    /// 开始按钮
    private lazy var startButton: UIButton = {
        let button = UIButton(imageName: nil, backgroundImageName: "new_feature_button")
        button.addTarget(self, action: #selector(startButtonDidClick), for: .touchUpInside)
        
        return button
    }()
    
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
        
        contentView.addSubview(imageView)
        contentView.addSubview(startButton)
    }
    
    /**
     初始化约束方法
     */
    private func setupConstraints() {
        
        constrain(imageView, startButton) { imageView, startButton in
            
            imageView.edges == inset(imageView.superview!.edges, 0)
            
            startButton.width == kViewDistance
            startButton.height == kViewAdapter
            startButton.centerX == startButton.superview!.centerX
            startButton.bottom == startButton.superview!.bottom - kViewDistance
        }
    }
    
    /**
     开始按钮点击方法
     */
    @objc private func startButtonDidClick() {
        
        NotificationCenter.default.post(name: Notification.Name(kRootViewControllerSwitched), object: true)
    }
    
    /**
     开始动画方法
     */
    func startAnimation() {
        
        startButton.isHidden = false
        startButton.transform = CGAffineTransform(scaleX: 0.0, y: 0.0)
        startButton.isUserInteractionEnabled = false
        
        UIView.animate(withDuration: 2.0, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 10, options: UIViewAnimationOptions(rawValue: 0), animations: {
            self.startButton.transform = .identity
        }, completion: { _ in
            self.startButton.isUserInteractionEnabled = true
        })
    }
    
}
