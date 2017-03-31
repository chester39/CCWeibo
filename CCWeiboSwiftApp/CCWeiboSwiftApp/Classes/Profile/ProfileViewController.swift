//
//  ProfileViewController.swift
//      CCWeiboSwiftApp
//		Chen Chen @ November 17th, 2016
//

import UIKit

import SDWebImage
import SwiftyJSON

class ProfileViewController: BaseViewController {

    /// 个人信息视图
    private var personView = PersonView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: kViewStandard))
    /// 表格视图
    fileprivate var tableView = UITableView(frame: kScreenFrame, style: .plain)
    /// 个人Cell重用标识符
    fileprivate let reuseIdentifier = "ProfileStatusCell"
    
    /// 个人资料数组
    fileprivate lazy var profileArray: [ProfileGroup] = {
        var array = [ProfileGroup]()
        do {
            if let data = try String(contentsOfFile: Bundle.main.path(forResource: "WeiboProfile", ofType: "json")!).data(using: .utf8) {
                let json = JSON(data: data)
                if let jsonArray = json.arrayObject {
                    for dict in jsonArray {
                        let group = ProfileGroup(dict: dict as! [String: Any])
                        array.append(group)
                    }
                }
            }
            
        } catch {
            print("读取失败")
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
            vistorView.setupVisitorInformation(iconName: "visitordiscover_image_profile", title: "登录后，你的微博、相册、个人资料会显示在这里，显示给其他人")
            return
        }
        
        setupNavigation()
        setupUI()
    }
    
    // MARK: - 界面方法
    
    /**
     初始化导航栏方法
     */
    private func setupNavigation() {
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "添加好友", style: .plain, target: self, action: nil)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "设置", style: .plain, target: self, action: #selector(settingButtonDidClick))
        navigationItem.title = "我"
    }
    
    /**
     初始化界面方法
     */
    private func setupUI() {
        
        assert(UserAccount.loadUserAccount() != nil, "必须授权之后才能使用用户数据")
        guard let user = UserAccount.loadUserAccount() else {
            return
        }
        
        personView.backgroundColor = kCommonLightColor
        personView.iconView.sd_setImage(with: URL(string: user.avatarLarge!))
        personView.nameLabel.text = user.screenName!
        personView.statusesView.titleLabel.text = String(user.statusesCount)
        personView.friendsView.titleLabel.text = String(user.friendsCount)
        personView.followersView.titleLabel.text = String(user.followersCount)
        
        let intro = user.descriptionIntro!
        let text = (intro == "" ? "暂无介绍" : intro)
        personView.introLabel.text = "简介：\(text)"
        
        tableView = UITableView(frame: kScreenFrame, style: .grouped)
        tableView.tableHeaderView = personView
        tableView.sectionFooterHeight = kViewEdge
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        view.addSubview(tableView)
    }
    
    /**
     设置按钮点击方法
     */
    @objc private func settingButtonDidClick() {
        
        let settingVC = SettingViewController()
        navigationController?.pushViewController(settingVC, animated: true)
    }
    
}

extension ProfileViewController: UITableViewDataSource {
    
    /**
     共有组数方法
     */
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return profileArray.count
    }
    
    /**
     每组行数方法
     */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let group = profileArray[section]
        return group.detail.count
    }
    
    /**
     每行内容方法
     */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: .value1, reuseIdentifier: reuseIdentifier)
        cell.accessoryType = .disclosureIndicator
        
        let group = profileArray[indexPath.section]
        let profile = group.detail[indexPath.row]
        cell.textLabel?.text = profile.title
        if let image = profile.icon {
            cell.imageView?.image = UIImage(named: image)
        }
        
        cell.detailTextLabel?.text = profile.remark
        cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 12)
        
        return cell
    }
    
}

extension ProfileViewController: UITableViewDelegate {
    
    /**
     选中行方法
     */
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let group = profileArray[indexPath.section]
        let profile = group.detail[indexPath.row]
        
        let message = "测试使用"
        let alertVC = UIAlertController(title: profile.title, message: message, preferredStyle: .alert)
        let cancelButton = UIAlertAction(title: "确定", style: .cancel) { (action) in
            self.dismiss(animated: true, completion: nil)
        }
        
        alertVC.addAction(cancelButton)
        present(alertVC, animated: true, completion: nil)
    }
    
    /**
     头部区域高度方法
     */
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return kViewEdge
    }
    
}
