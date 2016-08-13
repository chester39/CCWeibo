//
//	iOS培训
//		小码哥
//		Chen Chen @ August 12th, 2016
//

import UIKit
import Cartography

class QRCodeViewController: UIViewController {
    
    // 底部标签栏
    var tabBar = UITabBar()
    // 容器视图
    var containerView = UIView()
    // 边框图片
    var edgeView = UIImageView()
    // 波纹图片
    var waveView = UIImageView()
    // 文字标签
    var titleLabel = UILabel()
    // 名片按钮
    var cardButton = UIButton()
    
    // MARK: - 系统方法
    
    /**
     视图已经加载方法
     */
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        setupUI()
    }
    
    /**
     视图已经显示方法
     */
    override func viewDidAppear(animated: Bool) {
        
        super.viewDidAppear(animated)
        
        startAnimation()
    }
    
    // MARK: - 界面方法
    
    /**
     初始化UI方法
     */
    func setupUI() {
        
        navigationController?.navigationBar.barTintColor = UIColor.blackColor()
        navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont.systemFontOfSize(19), NSForegroundColorAttributeName: UIColor.whiteColor()]
        navigationItem.title = "扫一扫"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "关闭", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(closeButtonDidClicked))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "相册", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(albumButtonDidClicked))
        
        let qrcodeItem = UITabBarItem(title: "二维码", image: UIImage(named: "qrcode_tabbar_icon_qrcode"), selectedImage: UIImage(named: "qrcode_tabbar_icon_qrcode_highlighted"))
        let barcodeItem = UITabBarItem(title: "条形码", image: UIImage(named: "qrcode_tabbar_icon_barcode"), selectedImage: UIImage(named: "qrcode_tabbar_icon_barcode_highlighted"))
        tabBar.items = [qrcodeItem, barcodeItem]
        tabBar.selectedItem = qrcodeItem
        tabBar.barTintColor = UIColor.blackColor()
        tabBar.delegate = self
        view.addSubview(tabBar)
        
        containerView.backgroundColor = UIColor.clearColor()
        view.addSubview(containerView)
        
        edgeView.image = UIImage(named: "qrcode_border")?.resizableImageWithCapInsets(UIEdgeInsets(top: 25, left: 25, bottom: 25, right: 25), resizingMode: UIImageResizingMode.Tile)
        containerView.addSubview(edgeView)
        
        waveView.image = UIImage(named: "qrcode_scanline_qrcode")
        containerView.addSubview(waveView)
        
        titleLabel.font = UIFont.systemFontOfSize(17)
        titleLabel.textAlignment = NSTextAlignment.Center
        titleLabel.text = "将二维码放入框内, 即可扫描二维码"
        titleLabel.numberOfLines = 0
        view.addSubview(titleLabel)
        
        cardButton.setTitle("我的名片", forState: UIControlState.Normal)
        cardButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        view.addSubview(cardButton)
        
        constrain(tabBar) { (tabBar) in
            tabBar.leading == tabBar.superview!.leading
            tabBar.trailing == tabBar.superview!.trailing
            tabBar.bottom == tabBar.superview!.bottom
            tabBar.height == 49
        }
        
        constrain(containerView) { (containerView) in
            containerView.centerX == containerView.superview!.centerX
            containerView.centerY == containerView.superview!.centerY - 100
            containerView.width == 200
            containerView.height == 200
        }
        
        constrain(edgeView, waveView) { (edgeView, waveView) in
            edgeView.edges == inset(edgeView.superview!.edges, 0)
            waveView.edges == inset(edgeView.edges, 0)
        }
        
        constrain(titleLabel, containerView) { (titleLabel, containerView) in
            titleLabel.leading == containerView.leading
            titleLabel.trailing == containerView.trailing
            titleLabel.top == containerView.bottom + 20
        }
        
        constrain(cardButton, titleLabel) { (cardButton, titleLabel) in
            cardButton.centerX == cardButton.superview!.centerX
            cardButton.top == titleLabel.bottom + 20
        }
    }
    
    /**
     开始动画方法
     */
    private func startAnimation() {
        
        let group = ConstraintGroup()
        constrain(waveView, containerView, replace: group) { (waveView, containerView) in
            waveView.bottom == containerView.top
        }
        view.layoutIfNeeded()
        
        UIView.animateWithDuration(1.5) {
            UIView.setAnimationRepeatCount(MAXFLOAT)
            constrain(self.waveView, self.containerView, replace: group) { (waveView, containerView) in
                waveView.bottom == containerView.bottom
            }
            self.view.layoutIfNeeded()
        }
    }
    
    /**
     关闭按钮点击方法
     */
    func closeButtonDidClicked() {
        
        dismissViewControllerAnimated(true, completion: nil)
    }

    /**
     相册按钮点击方法
     */
    func albumButtonDidClicked() {
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary) == false {
            return
        }
        let imagePickerVC = UIImagePickerController()
        imagePickerVC.delegate = self
        presentViewController(imagePickerVC, animated: true, completion: nil)
    }
}

extension QRCodeViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    /**
     照片控制器选择多媒体方法
     */
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            return
        }
        guard let ciImage = CIImage(image: image) else {
            return
        }
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
}

extension QRCodeViewController: UITabBarDelegate {
    
    /**
     点击底部工具栏方法
     */
    func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem) {
        
        titleLabel.text = (item.title == "条形码") ? "将条形码放入框内, 即可扫描条形码" : "将二维码放入框内, 即可扫描二维码"
        view.layoutIfNeeded()
        
        waveView.layer.removeAllAnimations()
        startAnimation()
    }
}