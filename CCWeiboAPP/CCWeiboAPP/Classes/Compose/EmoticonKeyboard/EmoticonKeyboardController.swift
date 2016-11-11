//
//  EmoticonKeyboardController.swift
//		CCWeiboAPP
//		Chen Chen @ September 11th, 2016
//

import UIKit

import Cartography

class EmoticonKeyboardController: UIViewController {

    /// 表情包数组
    var managerArray: [EmoticonManager] = EmoticonManager.loadEmoticonManagerArray()
    /// 数字数组
    var numberArray: [Int] = [0, 0, 0, 0]
    /// 基础标记
    var baseTag = 100
    /// 闭包回调
    var emoticonCallback: (emoticon: EmoticonModel) -> ()
    /// 选中按钮
    private lazy var selectedButton = UIButton(type: .Custom)
    /// Cell重用标识符
    private let reuseIdentifier = "EmoticonKeyboardCell"
    
    /// 表情组工具栏
    private lazy var emoticonBar: UIToolbar = {
        let toolbar = UIToolbar()
        toolbar.tintColor = StatusTabBarTextColor
        
        var itemArray = [UIBarButtonItem]()
        var index = self.baseTag
        for manager in self.managerArray {
            let title = manager.groupNameCn
            let button = UIButton()
            button.setTitle(title, forState: .Normal)
            button.setTitleColor(CommonDarkColor, forState: .Normal)
            button.setTitleColor(AuxiliaryTextColor, forState: .Selected)
            button.sizeToFit()
            button.addTarget(self, action: #selector(itemButtonDidClick(_:)), forControlEvents: .TouchUpInside)
            button.tag = index
            if index == self.baseTag {
                self.changeSelectedButton(button)
            }
            
            index += 1
            let item = UIBarButtonItem(customView: button)
            itemArray.append(item)
            
            let flexibleItem = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil)
            itemArray.append(flexibleItem)
        }
        
        itemArray.removeLast()
        toolbar.items = itemArray
        
        return toolbar
    }()
    
    /// 表情键盘视图
    private lazy var emoticonView: UICollectionView = {
        let collectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: EmoticonKeyboardLayout())
        collectionView.backgroundColor = ClearColor
        collectionView.dataSource = self
        collectionView.delegate = self
        
        return collectionView
    }()
    
    /// 页码指示器
    private lazy var pageControl: UIPageControl = {
        let page = UIPageControl()
        page.pageIndicatorTintColor = CommonLightColor
        page.currentPageIndicatorTintColor = AuxiliaryTextColor
        
        return page
    }()
    
    // MARK: - 初始化方法
    
    /**
     回调初始化方法
     */
    init(callback: (emoticon: EmoticonModel) -> ()) {
        
        self.emoticonCallback = callback
        
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
        setupConstraints()
        
        for i in 0 ..< managerArray.count {
            numberArray[i] = managerArray[i].emoticonArray?.count ?? 0
        }
    }
    
    // MARK: - 界面方法
    
    /**
     初始化界面方法
     */
    private func setupUI() {
        
        emoticonView.registerClass(EmoticonKeyboardCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        view.addSubview(emoticonView)
        
        view.addSubview(emoticonBar)
        
        pageControl.numberOfPages = 0
        view.addSubview(pageControl)
        
    }
    
    /**
     初始化约束方法
     */
    private func setupConstraints() {
        
        constrain(emoticonView, emoticonBar) { (emoticonView, emoticonBar) in
            emoticonView.top == emoticonView.superview!.top
            emoticonView.bottom == emoticonBar.top
            
            emoticonBar.height == kNavigationBarHeight
            emoticonBar.bottom == emoticonBar.superview!.bottom
            
            align(left: emoticonView.superview!, emoticonView, emoticonBar)
            align(right: emoticonView.superview!, emoticonView, emoticonBar)
        }
        
        constrain(pageControl) { (pageControl) in
            pageControl.centerX == pageControl.superview!.centerX
            pageControl.bottom == pageControl.superview!.bottom - kViewMargin
        }
    }
    
    // MARK: - 按钮方法
    
    /**
     组件按钮已经点击方法
     */
    @objc private func itemButtonDidClick(button: UIButton) {
        
        let indexPath = NSIndexPath(forItem: 0, inSection: button.tag - baseTag)
        let manager = managerArray[indexPath.section]
        let pageCount = (manager.emoticonArray?.count ?? 0) / manager.maxEmoticonCount
        pageControl.numberOfPages = pageCount
        pageControl.currentPage = 0
        
        emoticonView.scrollToItemAtIndexPath(indexPath, atScrollPosition: .Left, animated: false)
        changeSelectedButton(button)
    }
    
    /**
     改变选中按钮方法
     */
    private func changeSelectedButton(button: UIButton) {
        
        selectedButton.selected = false
        selectedButton.backgroundColor = ClearColor
        
        button.selected = true
        button.backgroundColor = MainColor
        selectedButton = button
    }

}

extension EmoticonKeyboardController: UICollectionViewDataSource {
    
    /**
     共有组数方法
     */
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        
        return managerArray.count
    }
    
    /**
     每组集数方法
     */
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return managerArray[section].emoticonArray?.count ?? 0
    }
    
    /**
     每集内容方法
     */
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! EmoticonKeyboardCell
        let manager = managerArray[indexPath.section]
        cell.emoticon = manager.emoticonArray![indexPath.item]
        
        return cell
    }
    
}

extension EmoticonKeyboardController: UICollectionViewDelegate {
    
    /**
     选中集合方法
     */
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        let manager = managerArray[indexPath.section]
        let emoticon = manager.emoticonArray![indexPath.item]
        emoticon.count += 1
        if emoticon.isRemoveButton == false {
            managerArray[0].appendRecentEmoticon(emoticon)
        }
        
        emoticonCallback(emoticon: emoticon)
    }

}

extension EmoticonKeyboardController: UIScrollViewDelegate {
    
    /**
     已经停止滚动方法
     */
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        
        let indexPath = emoticonView.indexPathsForVisibleItems().first!
        let manager = managerArray[indexPath.section]
        let pageCount = (manager.emoticonArray?.count ?? 0) / manager.maxEmoticonCount
        
        var tempPage = 1
        switch indexPath.section {
        case 0:
            tempPage = 0
        case 1:
            tempPage = 1
        case 2:
            tempPage += numberArray[1] / manager.maxEmoticonCount
        case 3:
            tempPage += (numberArray[1] + numberArray[2]) / manager.maxEmoticonCount
        default:
            break
        }
        
        let page = Int(scrollView.contentOffset.x / kScreenWidth)
        pageControl.numberOfPages = pageCount
        pageControl.currentPage = page - tempPage
        
        let button = emoticonBar.viewWithTag(indexPath.section + baseTag) as! UIButton
        changeSelectedButton(button)
    }
    
}

class EmoticonKeyboardLayout: UICollectionViewFlowLayout {
    
    /**
     准备布局方法
     */
    override func prepareLayout() {
        
        super.prepareLayout()
        
        let width = kScreenWidth / 7
        let height = collectionView!.bounds.height / 3
        itemSize = CGSize(width: width, height: height)
        minimumInteritemSpacing = 0
        minimumLineSpacing = 0
        
        scrollDirection = .Horizontal
        collectionView?.pagingEnabled = true
        collectionView?.bounces = false
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.showsVerticalScrollIndicator = false
    }
    
}
