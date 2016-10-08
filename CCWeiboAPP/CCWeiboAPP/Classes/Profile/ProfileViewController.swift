//
//	ProfileViewController.swift
//		CCWeiboAPP
//		Chen Chen @ July 21st, 2016
//

import UIKit

class ProfileViewController: BaseViewController {
    
    /// 个人Cell重用标识符
    private let profileReuseIdentifier: String = "ProfileStatusCell"
    
    /// 个人资料数组
    private lazy var profileArray: [ProfileGroup] = {
        var array = [ProfileGroup]()
        if let dictArray = NSArray(contentsOfFile: NSBundle.mainBundle().pathForResource("WeiboProfile", ofType: "plist")!) {
            for dict in dictArray {
                let group = ProfileGroup(dict: dict as! [String: AnyObject])
                array.append(group)
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
            vistorView.setupVisitorInformation("visitordiscover_image_profile", title: "登录后，你的微博、相册、个人资料会显示在这里，显示给其他人")
            return
        }
        
        setupTableView()
    }
    
    // MARK: - 界面方法
    
    
    /**
     初始化导航栏方法
     */
    private func setupNavigation() {
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "添加好友", style: .Plain, target: self, action: nil)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "设置", style: .Plain, target: self, action: nil)
        navigationItem.title = "我"
    }
    
    /**
     初始化表格视图方法
     */
    private func setupTableView() {
        
        tableView = UITableView(frame: kScreenFrame, style: .Grouped)
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: profileReuseIdentifier)
        
    }

}

extension ProfileViewController {
    
    /**
     共有组数方法
     */
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return profileArray.count
    }
    
    /**
     每组行数方法
     */
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let group = profileArray[section]
        return group.detail.count
    }
    
    /**
     每行内容方法
     */
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: .Value1, reuseIdentifier: profileReuseIdentifier)
        cell.accessoryType = .DisclosureIndicator
        let group = profileArray[indexPath.section]
        let profile = group.detail[indexPath.row]
        cell.textLabel?.text = profile.title
        if let image = profile.icon {
            cell.imageView?.image = UIImage(named: image)
        }
        
        cell.detailTextLabel?.text = profile.remark
        cell.detailTextLabel?.font = UIFont.systemFontOfSize(12)
        
        return cell
    }
    
}