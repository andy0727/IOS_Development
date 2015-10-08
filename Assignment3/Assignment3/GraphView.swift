//
//  Grapher.swift
//  Assignment3
//
//  Created by Andy Zhu on 8/18/15.
//  Copyright (c) 2015 Andy Zhu. All rights reserved.
//

import Foundation
import UIKit


protocol GraphViewDatasource: class {
    func pointsForGraphView (sender: GraphView) -> [CGPoint]?
}


@IBDesignable
class GraphView: UIView {
    
    @IBInspectable
    var color: UIColor = UIColor.greenColor(){didSet{setNeedsDisplay()}}
    
    @IBInspectable
    var graphcenter: CGPoint
    {
        return center
    }
    
    @IBInspectable
    var pointsPerUnit: CGFloat = 40.0 {
        didSet{setNeedsDisplay()}
    }
    
    var inputx: [CGFloat]?{
        var res = [CGFloat]()
        for var x = bounds.minX; x < bounds.maxX; x+=1{
            res.append(x)
        }
        return res
    }
    
    var datasource: GraphViewDatasource?
    
    var axes: AxesDrawer = AxesDrawer()
    override func drawRect(rect: CGRect) {
        //prepare inputx
        
        let ps = datasource?.pointsForGraphView(self) ?? [CGPoint] ()

        if ps.count > 0{
            color.set()
            let path = UIBezierPath()
            path.moveToPoint(ps[0])
            for var index = 1; index < ps.count; ++index {
                path.addLineToPoint(ps[index])
                path.moveToPoint(ps[index])
            }
            path.stroke()
        }

        axes.drawAxesInRect(bounds, origin: graphcenter, pointsPerUnit: pointsPerUnit)
    }
}