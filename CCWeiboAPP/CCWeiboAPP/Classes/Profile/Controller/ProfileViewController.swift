//
//	ProfileViewController.swift
//		CCWeiboAPP
//		Chen Chen @ July 21st, 2016
//

import UIKit

class ProfileViewController: BaseViewController {
    
    /// 个人Cell重用标识符
    private let profileReuseIdentifier: String = "ProfileStatusCell"
    /// 个人信息视图
    private var personView: PersonView = {
        let view = PersonView((frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: kViewStandard)))
        view.backgroundColor = CommonLightColor
        
        return view
    }()
    
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
        
        setupNavigation()
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
        tableView.tableHeaderView = personView
        tableView.sectionFooterHeight = kViewEdge
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

extension ProfileViewController {
    
    /**
     选中行方法
     */
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let group = profileArray[indexPath.section]
        let profile = group.detail[indexPath.row]
        
        let message = "测试使用"
        let alertVC = UIAlertController(title: profile.title, message: message, preferredStyle: .Alert)
        let cancelButton = UIAlertAction.init(title: "确定", style: .Cancel) { (action) in
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        alertVC.addAction(cancelButton)
        presentViewController(alertVC, animated: true, completion: nil)
    }
    
    /**
     头部区域高度方法
     */
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return kViewEdge
    }

}