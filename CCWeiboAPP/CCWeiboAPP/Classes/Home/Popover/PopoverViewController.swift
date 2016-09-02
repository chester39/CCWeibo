//
//	PopoverViewController.swift
//		CCWeiboAPP
//		Chen Chen @ August 10th, 2016
//

import UIKit

class PopoverViewController: UIViewController {
    
    // 弹出框视图
    var popoverView = PopoverView(frame: kScreenFrame)
    
    // MARK: - 系统方法
    
    /**
     视图已经加载方法
     */
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        view = popoverView
    }

}
