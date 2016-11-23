//
//  ProgressView.swift
//      CCWeiboSwiftApp
//		Chen Chen @ November 23rd, 2016
//

import UIKit

class ProgressView: UIView {

    /// 当前进度
    var progress: CGFloat = 0.0 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    /**
     绘制图形方法
     */
    override func draw(_ rect: CGRect) {
        
        if progress >= 1.0 {
            return
        }
        
        let width = rect.size.width / 4
        let height = rect.size.height / 4
        let center = CGPoint(x: rect.size.width / 2, y: rect.size.height / 2)
        let radius = min(width, height)
        let start: CGFloat = -CGFloat(M_PI_2)
        let end = CGFloat(M_PI) * 2 * progress + start
        
        let path = UIBezierPath(arcCenter: center, radius: radius, startAngle: start, endAngle: end, clockwise: true)
        path.addLine(to: center)
        path.close()
        ProgressBackgroundColor.setFill()
        path.fill()
    }

}
