//
//	iOS培训
//		小码哥
//		Chen Chen @ August 1st, 2016
//

import UIKit

class TitleButton: UIButton {

    // MARK: - 初始化方法
    
    /**
     自定义初始化方法
     */
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        setupUI()
    }
    
    /**
     XIB初始化方法
     */
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 覆盖方法
    
    /**
     设置标题方法
     */
    override func setTitle(title: String?, forState state: UIControlState) {
        
        super.setTitle((title ?? "") + "  ", forState: state)
    }
    
    /**
     更新父控件尺寸方法
     */
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        titleLabel?.frame.origin.x = 0
        imageView?.frame.origin.x = titleLabel!.frame.width
    }
    
    
    // MARK: - 界面方法
    
    /**
     初始化UI方法
     */
    private func setupUI() {
        
        setImage(UIImage(named: "navigationbar_arrow_down"), forState: UIControlState.Normal)
        setImage(UIImage(named: "navigationbar_arrow_up"), forState: UIControlState.Selected)
        
        setTitleColor(UIColor.darkGrayColor(), forState: UIControlState.Normal)
        sizeToFit()
    }
    
}
