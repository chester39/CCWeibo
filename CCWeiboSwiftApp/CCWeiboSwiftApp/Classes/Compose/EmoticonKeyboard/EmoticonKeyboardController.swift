//
//  EmoticonKeyboardController.swift
//      CCWeiboSwiftApp
//		Chen Chen @ November 22nd, 2016
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
    var emoticonCallback: (_ emoticon: EmoticonModel) -> ()
    /// 选中按钮
    private lazy var selectedButton = UIButton(type: .custom)
    /// Cell重用标识符
    fileprivate let reuseIdentifier = "EmoticonKeyboardCell"
    
    /// 表情组工具栏
    fileprivate lazy var emoticonBar: UIToolbar = {
        let toolbar = UIToolbar()
        toolbar.tintColor = StatusTabBarTextColor
        
        var itemArray = [UIBarButtonItem]()
        var index = self.baseTag
        for manager in self.managerArray {
            let title = manager.groupNameCn
            let button = UIButton()
            button.setTitle(title, for: .normal)
            button.setTitleColor(CommonDarkColor, for: .normal)
            button.setTitleColor(AuxiliaryTextColor, for: .selected)
            button.sizeToFit()
            button.addTarget(self, action: #selector(itemButtonDidClick(button:)), for: .touchUpInside)
            button.tag = index
            if index == self.baseTag {
                self.changeSelectedButton(button: button)
            }
            
            index += 1
            let item = UIBarButtonItem(customView: button)
            itemArray.append(item)
            
            let flexibleItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
            itemArray.append(flexibleItem)
        }
        
        itemArray.removeLast()
        toolbar.items = itemArray
        
        return toolbar
    }()
    
    /// 表情键盘视图
    fileprivate lazy var emoticonView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: EmoticonKeyboardLayout())
        collectionView.backgroundColor = ClearColor
        collectionView.dataSource = self
        collectionView.delegate = self
        
        return collectionView
    }()
    
    /// 页码指示器
    fileprivate lazy var pageControl: UIPageControl = {
        let page = UIPageControl()
        page.pageIndicatorTintColor = CommonLightColor
        page.currentPageIndicatorTintColor = AuxiliaryTextColor
        
        return page
    }()
    
    // MARK: - 初始化方法
    
    /**
     回调初始化方法
     */
    init(callback: @escaping (_ emoticon: EmoticonModel) -> ()) {
        
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
        
        emoticonView.register(EmoticonKeyboardCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        view.addSubview(emoticonView)
        
        view.addSubview(emoticonBar)
        
        pageControl.numberOfPages = 0
        view.addSubview(pageControl)
        
    }
    
    /**
     初始化约束方法
     */
    private func setupConstraints() {
        
        constrain(emoticonView, emoticonBar) { emoticonView, emoticonBar in
            emoticonView.top == emoticonView.superview!.top
            emoticonView.bottom == emoticonBar.top
            
            emoticonBar.height == kNavigationBarHeight
            emoticonBar.bottom == emoticonBar.superview!.bottom
            
            align(left: emoticonView.superview!, emoticonView, emoticonBar)
            align(right: emoticonView.superview!, emoticonView, emoticonBar)
        }
        
        constrain(pageControl) { pageControl in
            pageControl.centerX == pageControl.superview!.centerX
            pageControl.bottom == pageControl.superview!.bottom - kViewMargin
        }
    }
    
    // MARK: - 按钮方法
    
    /**
     组件按钮已经点击方法
     */
    @objc private func itemButtonDidClick(button: UIButton) {
        
        let indexPath = IndexPath.init(item: 0, section: button.tag - baseTag)
        let manager = managerArray[indexPath.section]
        let pageCount = (manager.emoticonArray?.count ?? 0) / manager.maxEmoticonCount
        pageControl.numberOfPages = pageCount
        pageControl.currentPage = 0
        
        emoticonView.scrollToItem(at: indexPath, at: .left, animated: false)
        changeSelectedButton(button: button)
    }
    
    /**
     改变选中按钮方法
     */
    fileprivate func changeSelectedButton(button: UIButton) {
        
        selectedButton.isSelected = false
        selectedButton.backgroundColor = ClearColor
        
        button.isSelected = true
        button.backgroundColor = MainColor
        selectedButton = button
    }
    
}

extension EmoticonKeyboardController: UICollectionViewDataSource {
    
    /**
     共有组数方法
     */
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return managerArray.count
    }
    
    /**
     每组集数方法
     */
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return managerArray[section].emoticonArray?.count ?? 0
    }
    
    /**
     每集内容方法
     */
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! EmoticonKeyboardCell
        let manager = managerArray[indexPath.section]
        cell.emoticon = manager.emoticonArray![indexPath.item]
        
        return cell
    }
    
}

extension EmoticonKeyboardController: UICollectionViewDelegate {
    
    /**
     选中集合方法
     */
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let manager = managerArray[indexPath.section]
        let emoticon = manager.emoticonArray![indexPath.item]
        emoticon.count += 1
        if emoticon.isRemoveButton == false {
            managerArray[0].appendRecentEmoticon(emoticon: emoticon)
        }
        
        emoticonCallback(emoticon)
    }
    
}

extension EmoticonKeyboardController: UIScrollViewDelegate {
    
    /**
     已经停止滚动方法
     */
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let indexPath = emoticonView.indexPathsForVisibleItems.first!
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
        changeSelectedButton(button: button)
    }
    
}

class EmoticonKeyboardLayout: UICollectionViewFlowLayout {
    
    /**
     准备布局方法
     */
    override func prepare() {
        
        super.prepare()
        
        let width = kScreenWidth / 7
        let height = collectionView!.bounds.height / 3
        itemSize = CGSize(width: width, height: height)
        minimumInteritemSpacing = 0
        minimumLineSpacing = 0
        
        scrollDirection = .horizontal
        collectionView?.isPagingEnabled = true
        collectionView?.bounces = false
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.showsVerticalScrollIndicator = false
    }
    
}
