//
//	iOS培训
//		小码哥
//		Chen Chen @ July 21st, 2016
//

import UIKit

class HomeTableViewController: BaseTableViewController {

    // MARK: - 系统方法
    
    /**
     视图已经加载方法
     */
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        if isLogin == false {
            vistorView.setupVisitorInformation(nil, title: "关注一些人后，再回到这里看看有什么惊喜")
            return
        }
        
        setupNavigation()
    }
    
    // MARK: - 导航栏方法
    
    /**
     初始化导航栏方法
     */
    private func setupNavigation() {
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(imageName: "navigationbar_friendattention", target: self, action: #selector(leftButtonDidClicked))
        navigationItem.rightBarButtonItem = UIBarButtonItem(imageName: "navigationbar_pop", target: self, action: #selector(rightButtonDidClicked))
        
        let titleButton = TitleButton()
        titleButton.setTitle("CC首页", forState: UIControlState.Normal)
        titleButton.addTarget(self, action: #selector(titleButtonDidClicked(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        navigationItem.titleView = titleButton
    }
    
    
    // MARK: - 按钮方法
    
    /**
     标题按钮点击方法
     */
    @objc private func titleButtonDidClicked(button: TitleButton) {
        
        button.selected = !button.selected
        
        let popoverVc = PopoverViewController()
//        popoverVc.transitioningDelegate = 
        popoverVc.modalPresentationStyle = UIModalPresentationStyle.Custom
        presentViewController(popoverVc, animated: true, completion: nil)
    }
    
    /**
     左边按钮点击方法
     */
    @objc private func leftButtonDidClicked() {
        
        print(#function)
    }
    
    /**
     右边按钮点击方法
     */
    @objc private func rightButtonDidClicked() {
        
        print(#function)
    }
    
}