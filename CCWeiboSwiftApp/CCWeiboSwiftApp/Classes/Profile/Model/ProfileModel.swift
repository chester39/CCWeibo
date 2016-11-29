//
//  ProfileModel.swift
//      CCWeiboSwiftApp
//		Chen Chen @ November 29th, 2016
//

import UIKit

class ProfileModel: NSObject {

    /// 选项名
    var title: String?
    /// 选项图片
    var icon: String?
    /// 选项备注
    var remark: String?
    
    // MARK: - 初始化方法
    
    /**
     字典初始化方法
     */
    init(dict: [String: Any]) {
        
        super.init()
        
        setValuesForKeys(dict)
    }
    
}
