//
//  FaceView.swift
//  Happiness
//
//  Created by Andy Zhu on 8/14/15.
//  Copyright (c) 2015 Andy Zhu. All rights reserved.
//

import UIKit


protocol FaceViewDataSource : class{
    func smilinessforFaceView(sender: FaceView) -> Double?
    
}

class FaceView: UIView {
    
    @IBInspectable
    var linewidth: CGFloat = 3.0 {didSet{setNeedsDisplay()}}  //but desinable interface may replace them
    @IBInspectable
    var color: UIColor = UIColor.blueColor(){didSet{setNeedsDisplay()}}
    @IBInspectable
    var scale: CGFloat = 0.90 {didSet{setNeedsDisplay()}}
    
    weak var datasource : FaceViewDataSource?
    
    
    func scale(gesture: UIPinchGestureRecognizer){
        if gesture.state == .Changed{
            scale *= gesture.scale
            gesture.scale = 1
        }
    }
    
    private struct Scaling{
        static let FaceRadiusToEyeRadiusRatio: CGFloat = 10
        static let FaceRadiusToEyeOffsetRatio: CGFloat = 3
        static let FaceRadiusToEyeSeperationRatio: CGFloat = 1.5
        static let FaceRadiusToMouthWidthRatio: CGFloat = 1
        static let FaceRadiusToMouthHeightRatio: CGFloat = 3
        static let FaceRadiusToMouthOffsetRatio: CGFloat = 3
    }
    
    private enum Eye{case left, right}
    private func bezierPathEye(whichEye: Eye) -> UIBezierPath{
        let eyeRadius = faceRadius / Scaling.FaceRadiusToEyeRadiusRatio
        let eyeVerticalOffset = faceRadius / Scaling.FaceRadiusToEyeOffsetRatio
        let eyeHorizontalOffset = faceRadius / Scaling.FaceRadiusToEyeSeperationRatio
        
        var eyeCenter = faceCenter
        eyeCenter.y -= eyeVerticalOffset
        switch whichEye{
        case .left: eyeCenter.x -= eyeHorizontalOffset
        case .right: eyeCenter.x += eyeHorizontalOffset
        }
        
        let path = UIBezierPath(arcCenter: eyeCenter, radius: eyeRadius,
            startAngle: 0, endAngle: CGFloat(2 * M_PI), clockwise: true)
        
        path.lineWidth = linewidth
        return path
    }
    
    private func bezierPathSmile(fractionSmile: Double) -> UIBezierPath{
        let mouthVerticalOffset = faceRadius / Scaling.FaceRadiusToMouthOffsetRatio
        let mouthWidth = faceRadius / Scaling.FaceRadiusToMouthWidthRatio
        let mouthHeight = faceRadius / Scaling.FaceRadiusToMouthHeightRatio
        
        let smileHeight = CGFloat(max(min(fractionSmile, 1), -1)) * mouthHeight
        
        let start = CGPoint(x: faceCenter.x - mouthWidth / 2, y: faceCenter.y + mouthVerticalOffset)
        let end = CGPoint(x: start.x + mouthWidth , y: start.y)
        let cp1 = CGPoint(x: start.x + mouthWidth / 3 , y: start.y + smileHeight)
        let cp2 = CGPoint(x: end.x - mouthWidth / 3, y: cp1.y )
        
        let path = UIBezierPath()
        path.moveToPoint(start)
        path.addCurveToPoint(end, controlPoint1: cp1, controlPoint2: cp2)
        path.lineWidth = linewidth
        return path
    }

    var faceCenter: CGPoint{
        return convertPoint(center, fromView: superview)
    }
    
    var faceRadius: CGFloat{
        return min(bounds.size.height, bounds.size.width)/2 * scale
        
    }
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
        let facepath:UIBezierPath = UIBezierPath(arcCenter: faceCenter, radius: faceRadius,
            startAngle: 0, endAngle: CGFloat(2 * M_PI), clockwise: true)
        color.set()
        facepath.stroke()
        let smiliness = datasource?.smilinessforFaceView(self) ?? 0.0
        bezierPathEye(.left).stroke()
        bezierPathEye(.right).stroke()
        bezierPathSmile(smiliness).stroke()
        
    }
    

}
