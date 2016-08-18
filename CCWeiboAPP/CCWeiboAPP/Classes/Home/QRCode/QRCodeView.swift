//
//	iOS培训
//		小码哥
//		Chen Chen @ August 16th, 2016
//

import UIKit
import Cartography

class QRCodeView: UIView {

    // 底部标签栏
    var tabBar = UITabBar()
    // 容器视图
    var containerView = UIView()
    // 边框图片视图
    private var edgeView = UIImageView()
    // 波纹图片视图
    var waveView = UIImageView()
    // 文字标签
    var textLabel = UILabel()
    // 名片按钮
    var cardButton = UIButton()
    
    // MARK: - 初始化方法
    
    /**
     自定义初始化方法
     */
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        setupUI()
    }
    
    /**
     XIB初始化方法
     */
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 界面方法
    
    /**
     初始化界面方法
     */
    private func setupUI() {
        
        let qrcodeItem = UITabBarItem(title: "二维码", image: UIImage(named: "qrcode_tabbar_icon_qrcode"), selectedImage: UIImage(named: "qrcode_tabbar_icon_qrcode_highlighted"))
        let barcodeItem = UITabBarItem(title: "条形码", image: UIImage(named: "qrcode_tabbar_icon_barcode"), selectedImage: UIImage(named: "qrcode_tabbar_icon_barcode_highlighted"))
        tabBar.items = [qrcodeItem, barcodeItem]
        tabBar.selectedItem = qrcodeItem
        tabBar.barTintColor = UIColor.blackColor()
        addSubview(tabBar)
        
        containerView.backgroundColor = UIColor.clearColor()
        addSubview(containerView)
        
        edgeView.image = UIImage(named: "qrcode_border")?.resizableImageWithCapInsets(UIEdgeInsets(top: 25, left: 25, bottom: 25, right: 25), resizingMode: UIImageResizingMode.Tile)
        containerView.addSubview(edgeView)
        
        waveView.image = UIImage(named: "qrcode_scanline_qrcode")
        containerView.addSubview(waveView)
        
        textLabel.font = UIFont.systemFontOfSize(17)
        textLabel.textAlignment = NSTextAlignment.Center
        textLabel.text = "将二维码放入框内, 即可扫描二维码"
        textLabel.numberOfLines = 0
        addSubview(textLabel)
        
        cardButton.setTitle("我的名片", forState: UIControlState.Normal)
        cardButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        cardButton.backgroundColor = UIColor.orangeColor()
        addSubview(cardButton)
        
        constrain(tabBar) { (tabBar) in
            tabBar.leading == tabBar.superview!.leading
            tabBar.trailing == tabBar.superview!.trailing
            tabBar.bottom == tabBar.superview!.bottom
            tabBar.height == 49
        }
        
        constrain(containerView, edgeView, waveView) { (containerView, edgeView, waveView) in
            containerView.centerX == containerView.superview!.centerX
            containerView.centerY == containerView.superview!.centerY - 100
            containerView.width == 200
            containerView.height == 200
            
            edgeView.edges == inset(containerView.edges, 0)
            waveView.edges == inset(edgeView.edges, 0)
        }
        
        constrain(textLabel, containerView) { (textLabel, containerView) in
            textLabel.leading == containerView.leading
            textLabel.trailing == containerView.trailing
            textLabel.top == containerView.bottom + 20
        }
        
        constrain(cardButton, textLabel) { (cardButton, textLabel) in
            cardButton.centerX == cardButton.superview!.centerX
            cardButton.top == textLabel.bottom + 20
        }
    }
    
    /**
     开始动画方法
     */
    func startAnimation() {
        
        let group = ConstraintGroup()
        constrain(waveView, containerView, replace: group) { (waveView, containerView) in
            waveView.bottom == containerView.top
        }
        layoutIfNeeded()
        
        UIView.animateWithDuration(1.5) {
            UIView.setAnimationRepeatCount(MAXFLOAT)
            constrain(self.waveView, self.containerView, replace: group) { (waveView, containerView) in
                waveView.bottom == containerView.bottom
            }
            self.layoutIfNeeded()
        }
    }

}
