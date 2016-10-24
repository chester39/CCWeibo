//
//  SettingViewController.swift
//  CCWeiboAPP
//
//  Created by Chester Chen on 2016/10/18.
//  Copyright © 2016年 Chen Chen. All rights reserved.
//

import UIKit

import SDWebImage

class SettingViewController: UIViewController {
    
    /// 表格视图
    var tableView = UITableView(frame: kScreenFrame, style: .Plain)
    /// 设置视图
    var settingView = SettingView()
    
    var imageView = UIImageView(frame: CGRect(x: 0, y: -kTopHeight, width: kScreenWidth, height: 200))
    /// 设置Cell重用标识符
    private let reuseIdentifier = "SettingCell"
    
    // MARK: - 系统方法
    
    /**
     视图已经加载方法
     */
    override func viewDidLoad() {
        
        super.viewDidLoad()

        setupUI()
    }
    
    /**
     视图将要显示方法
     */
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        
        let coverView = navigationController?.navigationBar.subviews.first
        coverView?.alpha = 0
    }
    
    /**
     视图将要消失方法
     */
    override func viewWillDisappear(animated: Bool) {
        
        super.viewWillDisappear(animated)
        
        let coverView = navigationController?.navigationBar.subviews.first
        coverView?.alpha = 1
    }
    
    /**
     KVO观察者方法
     */
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        
        if keyPath == "contentOffset" {
            let offset = change![NSKeyValueChangeNewKey]!.CGPointValue
            if offset.y <= 0 {
                let scale = ((tableView.tableHeaderView?.frame.size.height)! - offset.y) / (tableView.tableHeaderView?.frame.size.height)!
                imageView.transform = CGAffineTransformMakeScale(scale, scale)
                imageView.f
                
            } else {
                settingView.frame.size.height = kViewDistance
                
            }
        }
    }
    
    /**
     反初始化方法
     */
    deinit {
        
        tableView.removeObserver(self, forKeyPath: "contentOffset")
    }
    
    // MARK: - 界面方法
    
    /**
     初始化界面方法
     */
    private func setupUI() {
        
        edgesForExtendedLayout = .None
        tableView.contentInset = UIEdgeInsets(top: kTopHeight, left: 0, bottom: 0, right: 0)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.addObserver(self, forKeyPath: "contentOffset", options: .New, context: nil)
        view.addSubview(tableView)
        
        imageView.image = UIImage(named: "compose_app_empty")
        view.addSubview(imageView)
        
    }

}

extension SettingViewController: UITableViewDataSource {
    
    /**
     共有组数方法
     */
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }
    
    /**
     每组行数方法
     */
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 30
    }
    
    /**
     每行内容方法
     */
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier, forIndexPath: indexPath)
        
        return cell
    }
    
}

extension SettingViewController: UITableViewDelegate {
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        UIView.animateWithDuration(1.0) { 
            self.settingView.alpha = 1.0
        }
    }
}
