//
//  HappinessViewController.swift
//  Happiness
//
//  Created by Andy Zhu on 8/14/15.
//  Copyright (c) 2015 Andy Zhu. All rights reserved.
//

import UIKit

class HappinessViewController: UIViewController, FaceViewDataSource {
    @IBOutlet weak var faceView: FaceView! {
        didSet{
            faceView.datasource = self
            faceView.addGestureRecognizer(
                UIPinchGestureRecognizer(target: faceView, action: "scale:"))
        }
    }
    
    private struct Constant{
        static let happinessScale : CGFloat = 4
    }
    @IBAction func changeHappiness(sender: UIPanGestureRecognizer) {
        
        switch sender.state{
        case .Ended: fallthrough
        case .Changed:
            let translation = sender.translationInView(faceView)
            let happinesschange = -Int(translation.y / Constant.happinessScale)
            if happinesschange != 0 {
                happiness += happinesschange
                sender.setTranslation(CGPointZero, inView: faceView)
            }
        default: break
        }
    }

    var happiness : Int = 10 {
        //0 is sad and 100 is most ecstatic
        didSet{
            happiness = max(min(100, happiness), 0)
            println("happiness1 = \(happiness)")
            updateUI()
        }
    }
    func updateUI(){
        faceView?.setNeedsDisplay()
        title = "\(happiness)"
    }
    func smilinessforFaceView(sender: FaceView) -> Double? {
        return Double(happiness - 50 ) / 50
    }
}

