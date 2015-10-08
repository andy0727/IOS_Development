//
//  BezierPathView.swift
//  Dropit
//
//  Created by Andy Zhu on 8/26/15.
//  Copyright (c) 2015 Andy Zhu. All rights reserved.
//

import UIKit

class BezierPathView: UIView {

    private var bezierPaths = [String: UIBezierPath]()
    
    func setPath(path: UIBezierPath?, name: String){
        bezierPaths[name] = path
        setNeedsDisplay()
    }
    
    override func drawRect(rect: CGRect) {
        for(_,path) in bezierPaths {
            path.stroke()
        }
    }

}
