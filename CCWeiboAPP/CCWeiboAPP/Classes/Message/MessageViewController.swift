//
//	MessageViewController.swift
//		CCWeiboAPP
//		Chen Chen @ July 21st, 2016
//

import UIKit

import MBProgressHUD
import SwiftyJSON

class MessageViewController: BaseViewController {

    /// 微博数组
    var statusArray: [StatusViewModel]?
    /// 基本Cell重用标识符
    private let basicReuseIdentifier = "BasicMessageCell"
    /// 微博Cell重用标识符
    private let weiboReuseIdentifier = "WeiboMessageCell"
    
    /// 基本数组
    private var basicArray: [[String: AnyObject]] = {
        var array = [[String: AnyObject]]()
        if let data = NSData(contentsOfFile: NSBundle.mainBundle().pathForResource("BasicMessage", ofType: "json")!) {
            let json = JSON(data: data)
            if let jsonArray = json.arrayObject {
                for dict in jsonArray {
                    array.append(dict as! [String : AnyObject])
                }
            }
        }
        
        return array
    }()
    
    // MARK: - 系统方法
    
    /**
     视图已经加载方法
     */
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        if isUserLogin == false {
            vistorView.setupVisitorInformation("visitordiscover_image_message", title: "登录后，别人评论你的微博，发给你的消息，都会在这里收到通知")
            return
        }
        
        setupNavigation()
        setupTableView()
        loadWeiboStatus()
    }
    
    // MARK: - 界面方法
    
    /**
     初始化导航栏方法
     */
    private func setupNavigation() {
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "发现群", style: .Plain, target: self, action: nil)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "聊天", style: .Plain, target: self, action: nil)
        navigationItem.title = "消息"
    }
    
    /**
     初始化表格视图方法
     */
    private func setupTableView() {
        
        tableView.estimatedRowHeight = kViewAdapter
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: basicReuseIdentifier)
        tableView.registerClass(MessageCell.self, forCellReuseIdentifier: weiboReuseIdentifier)
        tableView.tableFooterView = UIView(frame: CGRectZero)
    }
    
    // MARK: - 数据方法
    
    /**
     读取微博数据方法
     */
    @objc private func loadWeiboStatus() {
        
        NetworkingUtil.sharedInstance.loadWeiboStatuses(0, maxID: 0) { (array, error) in
            if error != nil {
                MBProgressHUD.showMessage("微博数据获取失败", delay: 1.0)
            }
            
            guard let weiboArray = array else {
                return
            }
            
            var modelArray = [StatusViewModel]()
            for dict in weiboArray {
                let status = StatusModel(dict: dict)
                let viewModel = StatusViewModel(status: status)
                modelArray.append(viewModel)
            }
            
            self.statusArray = modelArray
            self.tableView.reloadData()
        }
    }
    
}

extension MessageViewController {
    
    /**
     共有组数方法
     */
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }
    
    /**
     每组行数方法
     */
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return basicArray.count + (statusArray?.count ?? 0)
    }
    
    /**
     每行内容方法
     */
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.row < basicArray.count {
            let cell = tableView.dequeueReusableCellWithIdentifier(basicReuseIdentifier, forIndexPath: indexPath)
            let dict = basicArray[indexPath.item]
            let title = dict["title"] as? String
            let icon = dict["icon"] as? String
            
            cell.textLabel?.text = title
            cell.imageView?.image = UIImage(named: icon!)
            cell.accessoryType = .DisclosureIndicator
            
            return cell
            
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier(weiboReuseIdentifier, forIndexPath: indexPath) as! MessageCell
            cell.viewModel = statusArray![indexPath.row - basicArray.count]
            
            return cell
        }

    }
    
}

extension MessageViewController {
    
    /**
     将要结束抓拽方法
     */
    override func scrollViewWillEndDragging(scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        if velocity.y > 0 {
            navigationController?.setNavigationBarHidden(true, animated: true)
            
        } else {
            navigationController?.setNavigationBarHidden(false, animated: true)
        }
    }
}
