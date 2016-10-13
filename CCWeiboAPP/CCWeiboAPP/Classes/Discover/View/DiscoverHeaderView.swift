//
//  DiscoverHeaderView.swift
//		CCWeiboAPP
//		Chen Chen @ October 11th, 2016
//

import UIKit

import Cartography
import SwiftyJSON

class DiscoverHeaderView: UIView {
    
    /// 主题Cell重用标识符
    private let themeReuseIdentifier = "ThemeCell"
    /// 话题Cell重用标识符
    private let topicReuseIdentifier = "TopicCell"
    /// 分割线
    private var divideLine = UIView()

    /// 主题数组
    private var themeArray: [[String: AnyObject]] = {
        var array = [[String: AnyObject]]()
        if let data = NSData(contentsOfFile: NSBundle.mainBundle().pathForResource("DiscoverTheme", ofType: "json")!) {
            let json = JSON(data: data)
            if let jsonArray = json.arrayObject {
                for dict in jsonArray {
                    array.append(dict as! [String : AnyObject])
                }
            }
        }
        
        return array
    }()
    
    /// 主题集合视图
    private lazy var themeView: UICollectionView = {
        let collectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: ThemeLayout())
        collectionView.backgroundColor = CommonLightColor
        collectionView.dataSource = self
        
        return collectionView
    }()
    
    /// 话题数组
    private var topicArray: [[String: AnyObject]] = {
        var array = [[String: AnyObject]]()
        if let data = NSData(contentsOfFile: NSBundle.mainBundle().pathForResource("DiscoverTopic", ofType: "json")!) {
            let json = JSON(data: data)
            if let jsonArray = json.arrayObject {
                for dict in jsonArray {
                    array.append(dict as! [String : AnyObject])
                }
            }
        }
        
        return array
    }()
    
    /// 话题集合视图
    private lazy var topicView: UICollectionView = {
        let collectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: TopicLayout())
        collectionView.backgroundColor = CommonLightColor
        collectionView.dataSource = self
        
        return collectionView
    }()
    
    // MARK: - 初始化方法
    
    /**
     自定义初始化方法
     */
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        setupUI()
        setupConstraints()
    }
    
    /**
     数据解码XIB初始化方法
     */
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 界面方法
    
    /**
     初始化界面方法
     */
    private func setupUI() {
        
        themeView.registerClass(ThemeCell.self, forCellWithReuseIdentifier: themeReuseIdentifier)
        addSubview(themeView)
        
        divideLine.backgroundColor = DivideLineColor
        addSubview(divideLine)
        
        topicView.registerClass(TopicCell.self, forCellWithReuseIdentifier: topicReuseIdentifier)
        addSubview(topicView)
    }
    
    /**
     初始化约束方法
     */
    private func setupConstraints() {
        
        constrain(themeView, topicView) { (themeView, topicView) in
            themeView.height == kViewDistance
            themeView.top == themeView.superview!.top
            themeView.left == themeView.superview!.left
            themeView.right == themeView.superview!.right
            
            topicView.top == themeView.bottom + kViewBorder
            topicView.left == topicView.superview!.left
            topicView.bottom == topicView.superview!.bottom
            topicView.right == topicView.superview!.right
        }
        
        constrain(divideLine, themeView) { (divideLine, themeView) in
            divideLine.height == 1
            divideLine.top == themeView.bottom + kViewPadding
            divideLine.left == themeView.superview!.left + kViewEdge
            divideLine.right == themeView.superview!.right - kViewEdge
        }
    }
    
}

extension DiscoverHeaderView: UICollectionViewDataSource {
    
    /**
     共有组数方法
     */
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        
        return 1
    }
    
    /**
     每组集数方法
     */
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == themeView {
            return themeArray.count
            
        } else {
            return topicArray.count
        }
    }
    
    /**
     每集内容方法
     */
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        if collectionView == themeView {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(themeReuseIdentifier, forIndexPath: indexPath) as! ThemeCell
            let dict = themeArray[indexPath.item]
            let title = dict["title"] as? String
            let icon = dict["icon"] as? String
            
            cell.button.setTitle(title, forState: .Normal)
            cell.button.setImage(UIImage(named: icon!), forState: .Normal)
            
            return cell
            
        } else {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(topicReuseIdentifier, forIndexPath: indexPath) as! TopicCell
            let dict = topicArray[indexPath.item]
            let title = dict["title"] as? String
            let icon = dict["icon"] as? String
            
            if indexPath.item == 3 {
                cell.titleLabel.text = title
                
            } else {
                cell.titleLabel.text = "#\(title!)#"
            }
            
            cell.iconView.image = UIImage(named: icon!)
            
            return cell
        }
    }
    
}
