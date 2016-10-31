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
    var tableView = UITableView(frame: kScreenFrame, style: .Grouped)
    /// 图片视图
    var imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: kViewDistance))
    /// 导航栏背景视图
    var barView = UIView()
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
        
        navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    /**
     视图将要消失方法
     */
    override func viewWillDisappear(animated: Bool) {
        
        super.viewWillDisappear(animated)
        
        navigationController?.navigationBar.barTintColor = nil
        navigationController?.navigationBar.tintColor = MainColor
        navigationController?.navigationBar.setBackgroundImage(nil, forBarMetrics: .Default)
    }
  
    // MARK: - 界面方法
    
    /**
     初始化界面方法
     */
    private func setupUI() {

        navigationController?.navigationBar.barTintColor = MainColor
        navigationController?.navigationBar.tintColor = CommonDarkColor
        navigationItem.title = "设置"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "关闭", style: .Plain, target: self, action: #selector(closeButtonDidClick))
        
        tableView.showsVerticalScrollIndicator = false
        tableView.tableHeaderView = imageView
        tableView.dataSource = self
        tableView.delegate = self
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        view.addSubview(tableView)
        
        imageView.image = UIImage(named: "compose_app_empty")
        barView = (navigationController?.navigationBar.subviews.first)!
    }
    
    /**
     关闭按钮点击方法
     */
    func closeButtonDidClick() {
        
        navigationController?.popViewControllerAnimated(true)
    }

}

extension SettingViewController: UITableViewDataSource {
    
    /**
     共有组数方法
     */
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 4
    }
    
    /**
     每组行数方法
     */
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case 0:
            return 2
          
        case 1:
            return 3
            
        case 2:
            return 3
            
        case 3:
            return 1
            
        default:
            return 0
        }
    }
    
    /**
     每行内容方法
     */
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier, forIndexPath: indexPath)
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                cell.textLabel?.text = "账号管理"
                
            case 1:
                cell.textLabel?.text = "账号安全"
                
            default:
                break
            }
            
        case 1:
            switch indexPath.row {
            case 0:
                cell.textLabel?.text = "通知"
                
            case 1:
                cell.textLabel?.text = "隐私"
                
            case 2:
                cell.textLabel?.text = "通用设置"
                
            default:
                break
            }
            
        case 2:
            switch indexPath.row {
            case 0:
                cell.textLabel?.text = "清理缓存"
                
            case 1:
                cell.textLabel?.text = "意见反馈"
                
            case 2:
                cell.textLabel?.text = "关于微博"
                
            default:
                break
            }
            
        case 3:
            cell.textLabel?.text = "退出当前账号"
            cell.textLabel?.textColor = MainColor
            
        default:
            break
        }
        
        return cell
    }
    
}

extension SettingViewController: UITableViewDelegate {
    
    /**
     选中行方法
     */
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if indexPath.section == 2 && indexPath.row == 0 {
            let cachesSize = view.acquireCachesSize()
            let format = String(format: "%.2f", cachesSize)
            let message = "当前缓存为\(format) MB，是否需要清除？"
            let alertVC = UIAlertController(title: "清理缓存", message: message, preferredStyle: .Alert)
            let cancelButton = UIAlertAction(title: "取消", style: .Cancel) { (action) in
                self.dismissViewControllerAnimated(true, completion: nil)
            }
            
            let okButton = UIAlertAction.init(title: "确定", style: .Destructive) { (action) in
                self.view.clearCaches()
                self.dismissViewControllerAnimated(true, completion: nil)
            }
            
            alertVC.addAction(cancelButton)
            alertVC.addAction(okButton)
            presentViewController(alertVC, animated: true, completion: nil)
            
        } else if indexPath.section == 3 {
            let message = "是否退出当前账号？"
            let alertVC = UIAlertController(title: "退出当前账号", message: message, preferredStyle: .Alert)
            let cancelButton = UIAlertAction(title: "取消", style: .Cancel) { (action) in
                self.dismissViewControllerAnimated(true, completion: nil)
            }
            
            let okButton = UIAlertAction.init(title: "确定", style: .Destructive) { (action) in
                
                if NSFileManager.defaultManager().fileExistsAtPath(UserAccount.filePath) {
                    do {
                        try NSFileManager.defaultManager().removeItemAtPath(UserAccount.filePath)
                        
                    } catch {
                        print("退出失败")
                    }
                }
                self.dismissViewControllerAnimated(true, completion: nil)
                NSNotificationCenter.defaultCenter().postNotificationName(kRootViewControllerSwitched, object: false)
            }
            
            alertVC.addAction(cancelButton)
            alertVC.addAction(okButton)
            presentViewController(alertVC, animated: true, completion: nil)
        }
    }
    
    /**
     开始滚动方法
     */
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        barView.alpha = scrollView.contentOffset.y / kViewDistance
    }
    
}
