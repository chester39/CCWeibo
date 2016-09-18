//
//  PhotoPickerController.swift
//		CCWeiboAPP
//		Chen Chen @ September 17th, 2016
//

import UIKit
import Photos

import Cartography
import TZImagePickerController

class PhotoPickerController: UIViewController {
    
    /// 照片数组
    private var imageArray = [(image: UIImage, asset: PHAsset)]()
    /// 最大图片数
    private let maxPhotoCount = 9
    /// 照片集合视图
    private lazy var photoView: UICollectionView = {
        let collectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: PhotoPickerLayout())
        collectionView.backgroundColor = CommonLightColor
        collectionView.contentInset = UIEdgeInsets(top: kViewEdge, left: kViewEdge, bottom: kViewEdge, right: kViewEdge)
        collectionView.dataSource = self
        collectionView.registerClass(PhotoPickerCell.self, forCellWithReuseIdentifier: kPhotoPickerReuseIdentifier)
        
        return collectionView
    }()
    
    // MARK: - 初始化方法
    
    /**
     无参数初始化方法
     */
    init() {
        
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

        view.addSubview(photoView)
    }
    
    /**
     初始化约束方法
     */
    private func setupConstraints() {
        
        constrain(photoView) { (photoView) in
            photoView.edges == inset(photoView.superview!.edges, 0)
        }
    }
    
}

extension PhotoPickerController: UICollectionViewDataSource {
    
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
        
        return min(maxPhotoCount, imageArray.count + 1)
    }
    
    /**
     每集内容方法
     */
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(kPhotoPickerReuseIdentifier, forIndexPath: indexPath) as! PhotoPickerCell
        cell.delegate = self
        if indexPath.item < imageArray.count {
            cell.image = imageArray[indexPath.item].image
        } else {
            cell.image = nil
        }
        
        return cell
    }
    
}

extension PhotoPickerController: PhotoPickerCellDelegate {
    
    /**
     图片按钮点击方法
     */
    func photoPickerCellImageButtonDidClick(cell: PhotoPickerCell) {
        
        let photoArray = imageArray.map {
            $0.image
        }
        let assetArray = imageArray.map {
            $0.asset
        }
        
        let indexPath = photoView.indexPathForCell(cell)!
        let ipc = TZImagePickerController(selectedAssets: NSMutableArray(array: assetArray), selectedPhotos: NSMutableArray(array: photoArray), index: indexPath.item)
        ipc.maxImagesCount = maxPhotoCount
        ipc.sortAscendingByModificationDate = false
        ipc.allowPickingOriginalPhoto = true
        ipc.allowPickingVideo = false
        ipc.pickerDelegate = self
        ipc.didFinishPickingPhotosHandle = {(photos: [UIImage]!, assets: [AnyObject]!, isSelectOriginalPhoto: Bool) -> Void in
            self.imageArray.removeAll()
            for i in 0 ..< photos.count {
                let existImage = self.imageArray.contains{
                    $0.image == photos[i] || $0.asset == assets[i] as! PHAsset
                }
                if self.imageArray.count < self.maxPhotoCount && existImage == false {
                    self.imageArray.append((image: photos[i], asset: assets[i] as! PHAsset))
                }
            }
            
            self.photoView.reloadData()
        }
        
        presentViewController(ipc, animated: true, completion: nil)
    }
    
    /**
     添加按钮点击方法
     */
    func photoPickerCellAddButtonDidClick(cell: PhotoPickerCell) {
        
        let ipc = TZImagePickerController(maxImagesCount: maxPhotoCount, delegate: self)
        ipc.sortAscendingByModificationDate = false
        ipc.allowPickingOriginalPhoto = true
        ipc.allowPickingVideo = false
        
        let array = imageArray.map {
            $0.asset
        }
        ipc.selectedAssets = NSMutableArray(array: array)
        presentViewController(ipc, animated: true, completion: nil)
    }
    
    /**
     删除按钮点击方法
     */
    func photoPickerCellRemoveButtonDidClick(cell: PhotoPickerCell) {
        
        if let image = cell.image {
            let index = imageArray.indexOf {
                $0.image == image
            }
            imageArray.removeAtIndex(index!)
            photoView.reloadData()
        }
    }
    
}

extension PhotoPickerController: TZImagePickerControllerDelegate {
    
    /**
     完成照片选择方法
     */
    func imagePickerController(picker: TZImagePickerController!, didFinishPickingPhotos photos: [UIImage]!, sourceAssets assets: [AnyObject]!, isSelectOriginalPhoto: Bool) {
        
        imageArray.removeAll()
        for i in 0 ..< photos.count {
            let existImage = imageArray.contains{
                $0.image == photos[i] || $0.asset == assets[i] as! PHAsset
            }
            if imageArray.count < maxPhotoCount && existImage == false {
                imageArray.append((image: photos[i], asset: assets[i] as! PHAsset))
            }
        }
        
        photoView.reloadData()
    }

}

class PhotoPickerLayout: UICollectionViewFlowLayout {
    
    /**
     准备布局方法
     */
    override func prepareLayout() {
        
        super.prepareLayout()
        
        itemSize = CGSize(width: kViewAdapter, height: kViewAdapter)
        minimumInteritemSpacing = kViewPadding
        minimumLineSpacing = kViewPadding

        collectionView?.bounces = false
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.showsVerticalScrollIndicator = false
    }
    
}