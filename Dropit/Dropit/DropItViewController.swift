//
//  DropItViewController.swift
//  Dropit
//
//  Created by Andy Zhu on 8/25/15.
//  Copyright (c) 2015 Andy Zhu. All rights reserved.
//

import UIKit

class DropItViewController: UIViewController, UIDynamicAnimatorDelegate {
    
    
    @IBOutlet weak var gameView: BezierPathView!
   
    let dropItBehavior = DropItBehavior()
    
    var attachment: UIAttachmentBehavior?{
        willSet{
            animator.removeBehavior(attachment)
            gameView.setPath(nil, name: PathNames.attachment)
        }
        didSet{
            if attachment != nil{
                animator.addBehavior(attachment)
                attachment?.action = { [unowned self] in
                    if let attachedView = self.attachment?.items.first as? UIView{
                        let path = UIBezierPath()
                        path.moveToPoint(self.attachment!.anchorPoint)
                        path.addLineToPoint(attachedView.center)
                        self.gameView.setPath(path, name: PathNames.attachment)
                    }
                }
            }
        }
    }
    
    
    lazy var animator: UIDynamicAnimator = {  //be careful only to use it when you know it is set
        let lazilycreatedAnimator = UIDynamicAnimator(referenceView: self.gameView)
        lazilycreatedAnimator.delegate = self
        return lazilycreatedAnimator
    }()
    
    var dropsPerRow = 10
    
    var dropSize: CGSize {
        let size = gameView.bounds.size.width / CGFloat(dropsPerRow)
        return CGSize(width: size, height: size)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        animator.addBehavior(dropItBehavior)
    }
    struct PathNames {
        static let middileBarrier = "Middle Barrier"
        static let attachment = "Attachment"
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let barrierSize = dropSize
        let barrierOrigin = CGPoint(x: gameView.bounds.midX - barrierSize.width/2 , y: gameView.bounds.midY - barrierSize.height/2)
        let path = UIBezierPath(ovalInRect: CGRect(origin: barrierOrigin, size: barrierSize))
        dropItBehavior.addBarrier(path, name: PathNames.middileBarrier)
        gameView.setPath(path, name: PathNames.middileBarrier)
        
    }
    
    func dynamicAnimatorDidPause(animator: UIDynamicAnimator) {
        removeCompletedRow()
    }
    
    @IBAction func drop(sender: UITapGestureRecognizer) {
        drop()
    }

    func drop()
    {
        
        var frame = CGRect(origin: CGPointZero, size: dropSize)
        frame.origin.x = CGFloat.random(dropsPerRow) * dropSize.width
        let dropView = UIView(frame: frame)
        dropView.backgroundColor = UIColor.random
        
        gameView.addSubview(dropView)
        
        dropItBehavior.addDrop(dropView)
        
        lastDropView = dropView
    }
    
    var lastDropView: UIView?
    
    @IBAction func dragDrop(sender: UIPanGestureRecognizer) {
        let gesturePoint = sender.locationInView(gameView)
        
        switch sender.state{
        case .Began:
            if let viewToAttachTo = lastDropView{
            attachment = UIAttachmentBehavior(item: viewToAttachTo, attachedToAnchor: gesturePoint)
                lastDropView = nil
            }
        case .Changed:
            attachment?.anchorPoint = gesturePoint
        case .Ended:
            attachment = nil
        default: break
        }
    }
    func removeCompletedRow()
    {
        println("i am here")
        var dropsToRemove=[UIView]()
        var dropFrame = CGRect(x: 0, y: gameView.frame.maxY, width: dropSize.width, height: dropSize.height)
        
        do{
            dropFrame.origin.y -= dropSize.height
            dropFrame.origin.x = 0
            var dropsFound = [UIView]()
            var rowIsComplete = true
            for _ in 0 ..< dropsPerRow {
                if let hitView = gameView.hitTest(CGPoint(x: dropFrame.midX, y: dropFrame.midY), withEvent: nil){
                    if hitView.superview == gameView{
                        dropsFound.append(hitView)
                    }else{
                        rowIsComplete = false
                    }
                }
                dropFrame.origin.x += dropSize.width
            }
            if rowIsComplete{
                dropsToRemove += dropsFound
            }
        }while dropsToRemove.count == 0 && dropFrame.origin.y > 0
        
        for drop in dropsToRemove{
            dropItBehavior.removeDrop(drop)
        }
    }
}

private extension CGFloat{
    static func random (max: Int) -> CGFloat
    {
        return CGFloat(arc4random() % UInt32(max))
    }
    
}

private extension UIColor{
    class var random: UIColor{
        switch(arc4random() % 5){
        case 0: return UIColor.greenColor()
        case 1: return UIColor.blueColor()
        case 2: return UIColor.orangeColor()
        case 3: return UIColor.redColor()
        case 4: return UIColor.purpleColor()
        default: return UIColor.blackColor()
        }
    }
}
