//
//  DetailViewController.swift
//      CCWeiboSwiftApp
//		Chen Chen @ November 28th, 2016
//

import UIKit

import MBProgressHUD

class DetailViewController: UIViewController {

    /// 微博视图模型
    fileprivate var viewModel: StatusViewModel?
    /// 评论数组
    fileprivate var commentArray: [CommentModel]?
    /// 表格视图
    private var tableView = UITableView(frame: kScreenFrame, style: .plain)
    /// 微博Cell重用标识符
    fileprivate let weiboReuseIdentifier = "WeiboStatusCell"
    /// 转发微博Cell重用标识符
    fileprivate let retweetReuseIdentifier = "RetweetStatusCell"
    /// 评论Cell重用标识符
    fileprivate let commentReuseIdentifier = "CommentCell"
    
    /// 头视图
    fileprivate var headerView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: kViewMargin))
        view.backgroundColor = kCommonLightColor
        
        return view
    }()
    
    // MARK: - 初始化方法
    
    /**
     图片数组和索引初始化方法
     */
    init(viewModel: StatusViewModel) {
        
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    /**
     数据解码XIB初始化方法
     */
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 系统方法
    
    /**
     视图已经加载方法
     */
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        setupUI()
        loadCommentStatus()
    }
    
    // MARK: - 界面方法
    
    /**
     初始化界面方法
     */
    private func setupUI() {
        
        navigationItem.title = "微博正文"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareButtonDidClick))
        
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 200
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(WeiboStatusCell.self, forCellReuseIdentifier: weiboReuseIdentifier)
        tableView.register(RetweetStatusCell.self, forCellReuseIdentifier: retweetReuseIdentifier)
        tableView.register(CommentCell.self, forCellReuseIdentifier: commentReuseIdentifier)
        view.addSubview(tableView)
    }
    
    /**
     按钮点击方法
     */
    @objc fileprivate func buttonDidClick(button: UIButton) {
        
        for view in headerView.subviews {
            if view.frame.size.height == 1 {
                view.removeFromSuperview()
            }
        }
        
        let line = UIView()
        line.frame.origin.x = button.frame.origin.x
        line.frame.origin.y = kViewMargin - kViewEdge
        line.frame.size.width = kViewAdapter
        line.frame.size.height = 1
        line.backgroundColor = kMainColor
        headerView.addSubview(line)
    }
    
    /**
     分享按钮点击方法
     */
    @objc private func shareButtonDidClick() {
        
        print(#function)
    }
    
    // MARK: - 数据方法
    
    /**
     读取微博数据方法
     */
    private func loadCommentStatus() {
        
        let id = viewModel!.status.weiboID
        NetworkingUtil.shared.loadStatusComments(id: id) { (array, error) in
            if error != nil {
                MBProgressHUD.showMessage(text: "评论数据获取失败", delay: 1.0)
            }
            
            guard let commentArray = array else {
                return
            }
            
            var modelArray = [CommentModel]()
            for dict in commentArray {
                let comment = CommentModel(dict: dict)
                modelArray.append(comment)
            }
            
            self.commentArray = modelArray
            
            self.tableView.reloadData()
        }
    }
    
}

extension DetailViewController: UITableViewDataSource {
    
    /**
     共有组数方法
     */
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 2
    }
    
    /**
     每组行数方法
     */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return 1
            
        } else {
            return commentArray?.count ?? 0
        }
    }
    
    /**
     每行内容方法
     */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            if viewModel!.status.retweetedStatus != nil {
                let cell = tableView.dequeueReusableCell(withIdentifier: retweetReuseIdentifier, for: indexPath) as! RetweetStatusCell
                cell.viewModel = viewModel!
                cell.delegate = self
                
                return cell
                
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: weiboReuseIdentifier, for: indexPath) as! WeiboStatusCell
                cell.viewModel = viewModel!
                cell.delegate = self
                
                return cell
            }
            
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: commentReuseIdentifier, for: indexPath) as! CommentCell
            let comment = commentArray![indexPath.row]
            cell.comment = comment
            
            return cell
        }
    }
    
}

extension DetailViewController: UITableViewDelegate {
    
    /**
     每组头视图内容方法
     */
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section == 1 {
            let retweetButton = UIButton(frame: CGRect(x: 0, y: 0, width: kViewAdapter, height: kViewMargin))
            retweetButton.titleLabel?.font = UIFont.systemFont(ofSize: 12)
            retweetButton.setTitleColor(kCommonDarkColor, for: .normal)
            retweetButton.setTitle("转发 \(viewModel!.status.repostsCount)", for: .normal)
            retweetButton.addTarget(self, action: #selector(buttonDidClick(button:)), for: .touchUpInside)
            headerView.addSubview(retweetButton)
            
            let commentButton = UIButton(frame: CGRect(x: kViewAdapter, y: 0, width: kViewAdapter, height: kViewMargin))
            commentButton.titleLabel?.font = UIFont.systemFont(ofSize: 12)
            commentButton.setTitleColor(kCommonDarkColor, for: .normal)
            commentButton.setTitle("评论 \(viewModel!.status.commentsCount)", for: .normal)
            commentButton.addTarget(self, action: #selector(buttonDidClick(button:)), for: .touchUpInside)
            buttonDidClick(button: commentButton)
            headerView.addSubview(commentButton)
            
            let likeButton = UIButton(frame: CGRect(x: kScreenWidth - kViewAdapter, y: 0, width: kViewAdapter, height: kViewMargin))
            likeButton.titleLabel?.font = UIFont.systemFont(ofSize: 12)
            likeButton.setTitleColor(kCommonDarkColor, for: .normal)
            likeButton.setTitle("赞 \(viewModel!.status.attitudesCount)", for: .normal)
            likeButton.addTarget(self, action: #selector(buttonDidClick(button:)), for: .touchUpInside)
            headerView.addSubview(likeButton)
            
            return headerView
            
        } else {
            return nil
        }
    }
    
    /**
     每组头视图高度方法
     */
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if section == 1 {
            return kViewMargin
            
        } else {
            return 0
        }
    }
    
}

extension DetailViewController: BaseStatusCellDelegate {
    
    /**
     由URL显示网页视图方法
     */
    func statusCellDidShowWebViewWithURLString(cell: BaseStatusCell, urlString: String) {
        
        let webVC = WebViewController()
        webVC.loadWithURLString(urlString: urlString)
        navigationController?.pushViewController(webVC, animated: true)
    }

}
