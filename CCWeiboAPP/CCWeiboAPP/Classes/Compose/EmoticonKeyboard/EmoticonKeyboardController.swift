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
    /// 闭包回调
    var emoticonCallback: (emoticon: EmoticonModel) -> ()
    /// 选中按钮
    private lazy var selectedButton = UIButton(type: .Custom)
    /// Cell重用标识符
    private let reuseIdentifier: String = "EmoticonKeyboardCell"
    
    /// 表情组工具栏
    private lazy var emoticonBar: UIToolbar = {
        let toolbar = UIToolbar()
        toolbar.tintColor = StatusTabBarTextColor
        
        var itemArray = [UIBarButtonItem]()
        var index = 0
        for manager in self.managerArray {
            let title = manager.groupNameCn
            let button = UIButton()
            button.setTitle(title, forState: .Normal)
            button.setTitleColor(CommonDarkColor, forState: .Normal)
            button.setTitleColor(AuxiliaryTextColor, forState: .Selected)
            button.sizeToFit()
            button.addTarget(self, action: #selector(itemButtonDidClick(_:)), forControlEvents: .TouchUpInside)
            button.tag = index
            if index == 0 {
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
    }
    
    // MARK: - 界面方法
    
    /**
     初始化界面方法
     */
    private func setupUI() {
        
        emoticonView.registerClass(EmoticonKeyboardCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        view.addSubview(emoticonView)
        
        view.addSubview(emoticonBar)
        
        pageControl.numberOfPages = managerArray.count
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
     改变选中按钮方法
     */
    private func changeSelectedButton(button: UIButton) {
        
        selectedButton.selected = false
        selectedButton.backgroundColor = ClearColor
        
        button.selected = true
        button.backgroundColor = MainColor
        selectedButton = button
    }
    
    /**
     组件按钮已经点击方法
     */
    @objc private func itemButtonDidClick(button: UIButton) {
        
        let indexPath = NSIndexPath(forItem: 0, inSection: button.tag)
        emoticonView.scrollToItemAtIndexPath(indexPath, atScrollPosition: .Left, animated: false)
        changeSelectedButton(button)
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
        
        let page = Int(scrollView.contentOffset.x / kScreenWidth)
        pageControl.currentPage = page
        
        let indexPath = emoticonView.indexPathsForVisibleItems().first!
        let button = emoticonBar.viewWithTag(indexPath.section) as! UIButton
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