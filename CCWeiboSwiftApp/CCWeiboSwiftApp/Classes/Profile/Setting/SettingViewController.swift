//
//  SettingViewController.swift
//  CCWeiboSwiftApp
//
//  Created by Chester Chen on 2016/11/29.
//  Copyright © 2016年 Chen Chen. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController {

    /// 表格视图
    private var tableView = UITableView(frame: kScreenFrame, style: .grouped)
    /// 图片视图
    fileprivate var imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: kViewDistance))
    /// 导航栏背景视图
    fileprivate var barView = UIView()
    /// 临时透明度
    fileprivate var tempAlpha: CGFloat = 0
    /// 设置Cell重用标识符
    fileprivate let reuseIdentifier = "SettingCell"
    
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
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.shadowImage = UIImage()
        barView = (navigationController?.navigationBar.subviews.first)!
        barView.alpha = tempAlpha
    }
    
    /**
     视图将要消失方法
     */
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        
        navigationController?.navigationBar.barTintColor = nil
        navigationController?.navigationBar.tintColor = kMainColor
        navigationController?.navigationBar.shadowImage = nil
        barView.alpha = 1.0
    }
    
    // MARK: - 界面方法
    
    /**
     初始化界面方法
     */
    private func setupUI() {
        
        automaticallyAdjustsScrollViewInsets = false
        navigationController?.navigationBar.barTintColor = kMainColor
        navigationController?.navigationBar.tintColor = kCommonDarkColor
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "返回", style: .plain, target: self, action: #selector(closeButtonDidClick))
        
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: kViewDistance))
        headerView.backgroundColor = kClearColor
        
        tableView.showsVerticalScrollIndicator = false
        tableView.alwaysBounceVertical = true
        tableView.tableHeaderView = headerView
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        view.addSubview(tableView)
        
        imageView.image = UIImage(named: "arsenal_background")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        view.addSubview(imageView)
    }
    
    /**
     关闭按钮点击方法
     */
    func closeButtonDidClick() {
        
        _ = navigationController?.popViewController(animated: true)
    }
    
}

extension SettingViewController: UITableViewDataSource {
    
    /**
     共有组数方法
     */
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 4
    }
    
    /**
     每组行数方法
     */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
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
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
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
            cell.textLabel?.textColor = kMainColor
            
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
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 2 && indexPath.row == 0 {
            let cachesSize = view.cachesSize()
            let format = String(format: "%.2f", cachesSize)
            let message = "当前缓存为\(format) MB，是否需要清除？"
            let alertVC = UIAlertController(title: "清理缓存", message: message, preferredStyle: .alert)
            let cancelButton = UIAlertAction(title: "取消", style: .cancel) { (action) in
                self.dismiss(animated: true, completion: nil)
            }
            
            let okButton = UIAlertAction(title: "确定", style: .destructive) { [weak self] action in
                self?.view.clearCaches()
                self?.dismiss(animated: true, completion: nil)
            }
            
            alertVC.addAction(cancelButton)
            alertVC.addAction(okButton)
            present(alertVC, animated: true, completion: nil)
            
        } else if indexPath.section == 3 {
            let message = "是否退出当前账号？"
            let alertVC = UIAlertController(title: "退出当前账号", message: message, preferredStyle: .alert)
            let cancelButton = UIAlertAction(title: "取消", style: .cancel) { [weak self] action in
                self?.dismiss(animated: true, completion: nil)
            }
            
            let okButton = UIAlertAction(title: "确定", style: .destructive) { [weak self] action in
                if FileManager.default.fileExists(atPath: UserAccount.filePath) {
                    do {
                        try FileManager.default.removeItem(atPath: UserAccount.filePath)
                        
                    } catch {
                        print("退出失败")
                    }
                }
                
                self?.dismiss(animated: true, completion: nil)
                NotificationCenter.default.post(name: Notification.Name(kRootViewControllerSwitched), object: true)
            }
            
            alertVC.addAction(cancelButton)
            alertVC.addAction(okButton)
            present(alertVC, animated: true, completion: nil)
        }

    }
    
    /**
     开始滚动方法
     */
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let offsetY = scrollView.contentOffset.y
        if offsetY >= 0 {
            imageView.frame.origin.y = -offsetY
            if offsetY <= kViewDistance {
                tempAlpha = (offsetY / (kViewDistance - kTopHeight) >= 1) ? 1 : offsetY / (kViewDistance - kTopHeight)
                if tempAlpha == 1.0 {
                    navigationItem.title = "设置"
                    
                } else {
                    navigationItem.title = ""
                }
                
            } else if offsetY > kViewDistance {
                tempAlpha = 1.0
                navigationItem.title = "设置"
            }
            
            barView.alpha = tempAlpha
            
        } else {
            imageView.transform = CGAffineTransform(scaleX: 1 + offsetY / -kViewDistance, y: 1 + offsetY / -kViewDistance)
            imageView.frame.origin.y = 0
            navigationItem.title = ""
        }
    }
    
}
