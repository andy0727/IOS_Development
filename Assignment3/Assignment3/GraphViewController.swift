//
//  GraphViewController.swift
//  Assignment3
//
//  Created by Andy Zhu on 8/18/15.
//  Copyright (c) 2015 Andy Zhu. All rights reserved.
//

import UIKit

class GraphViewController: UIViewController, GraphViewDatasource{

    @IBOutlet weak var graphView: GraphView!
    {
        didSet
        {
            //set datasource, add gesture
            graphView.datasource = self
        }
        
    }
    weak var cvc: CalculatorViewController!
    
    @IBAction func TapZoom(sender: UITapGestureRecognizer) {
        sender.numberOfTapsRequired = 2
        if sender.state == .Ended{
            graphView.center = sender.locationInView(graphView.superview)
        }
    }
    
    @IBAction func Scale(sender: UIPinchGestureRecognizer) {
        if sender.state == .Changed{
            graphView.transform = CGAffineTransformScale(graphView.transform, sender.scale, sender.scale)
            sender.scale = 1
        }
    }
    @IBAction func MoveScreen(sender: UIPanGestureRecognizer) {
        switch sender.state{
        case .Ended: fallthrough
        case .Changed:
            let translation = sender.translationInView(graphView)
            graphView.center = CGPoint(x: graphView.center.x +  translation.x,
                            y: graphView.center.y + translation.y)
            sender.setTranslation( CGPointZero, inView: graphView)
        default: break
        }
    }
    
    func pointsForGraphView(sender: GraphView) -> [CGPoint]? {
        if let inputx = sender.inputx{
            //convert xs
            var xs = [Double]()
            for x in inputx{
                xs.append(Double((x - graphView.bounds.midX) / graphView.pointsPerUnit))
            }
            //convert ys
            if let ys = cvc?.computeY(xs){
                var inputy = [CGFloat]()
                for y in ys{
                    inputy.append( graphView.bounds.midY - CGFloat(y) * graphView.pointsPerUnit )
                }
                
                //make cgpoints
                var ps = [CGPoint]()
                for (index, y) in enumerate(inputy){
                    ps.append(CGPoint(x: inputx[index], y: y) )
                }
                //println(ps)
                return ps
            }else{return nil}

        }
        return nil
    }
}


extension CalculatorViewController
{
    func computeY(xs: [Double]?) -> [Double]?{
        let temp = brain.variableValues["M"]
        var res = [Double]()
        if let xs = xs{
            for x in xs {
                brain.variableValues["M"] = x
                if let y = brain.evaluate(){
                    res.append(y)
                }else {
                    return nil
                }
            }
            return res
        }
        
        return nil
    }
}


