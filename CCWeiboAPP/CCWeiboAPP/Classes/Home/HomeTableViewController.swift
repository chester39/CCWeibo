//
//	iOS培训
//		小码哥
//		Chen Chen @ July 21st, 2016
//

import UIKit

class HomeTableViewController: BaseTableViewController {

    // MARK: - 初始化方法
    
    /**
     标题按钮懒加载方法
     */
    private lazy var titleButton: UIButton = { () -> UIButton in
        
        let button = TitleButton()
        button.setTitle("CC首页", forState: UIControlState.Normal)
        button.addTarget(self, action: #selector(titleButtonDidClicked(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        return button
    }()
    
    /**
     转场管理器懒加载方法
     */
    private lazy var presentationManger: PopoverPresentationManager = { () -> PopoverPresentationManager in
        
        let manager = PopoverPresentationManager()
        let presentWidth: CGFloat = 200
        let presentHeight: CGFloat = 250
        let presentX: CGFloat = (kScreenWidth - presentWidth) * 0.5
        let presentY: CGFloat = 50
        manager.presentFrame = CGRect(x: presentX, y: presentY, width: presentWidth, height: presentHeight)
        return manager
        
    }()
    
    // MARK: - 系统方法
    
    /**
     视图已经加载方法
     */
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        if kIsUserLogin == false {
            vistorView.setupVisitorInformation(nil, title: "关注一些人后，再回到这里看看有什么惊喜")
            return
        }
        
        setupNavigation()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(titleButtonDidChanged), name: kPopoverPresentationManagerDidPresented, object: presentationManger)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(titleButtonDidChanged), name: kPopoverPresentationManagerDidDismissed, object: presentationManger)
    }
    
    /**
     反初始化方法
     */
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    // MARK: - 导航栏方法
    
    /**
     初始化导航栏方法
     */
    private func setupNavigation() {
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(imageName: "navigationbar_friendattention", target: self, action: #selector(leftButtonDidClicked))
        navigationItem.rightBarButtonItem = UIBarButtonItem(imageName: "navigationbar_pop", target: self, action: #selector(qrcodeButtonDidClicked))
        navigationItem.titleView = titleButton
    }
    
    // MARK: - 按钮方法
    
    /**
     标题按钮改变方法
     */
    @objc private func titleButtonDidChanged() {
        
        titleButton.selected = !titleButton.selected
    }
    
    /**
     标题按钮点击方法
     */
    @objc private func titleButtonDidClicked(button: TitleButton) {
        
        let popoverVC = PopoverViewController()
        popoverVC.transitioningDelegate = presentationManger
        popoverVC.modalPresentationStyle = UIModalPresentationStyle.Custom
        presentViewController(popoverVC, animated: true, completion: nil)
    }
    
    /**
     左边按钮点击方法
     */
    @objc private func leftButtonDidClicked() {
        
        print(#function)
    }
    
    /**
     二维码按钮点击方法
     */
    @objc private func qrcodeButtonDidClicked() {
        
        let qrcVC = QRCodeViewController()
        let qrcNC = UINavigationController()
        qrcNC.addChildViewController(qrcVC)
        presentViewController(qrcNC, animated: true, completion: nil)
    }
    
}