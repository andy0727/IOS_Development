//
//  DropItBehavior.swift
//  Dropit
//
//  Created by Andy Zhu on 8/25/15.
//  Copyright (c) 2015 Andy Zhu. All rights reserved.
//

import UIKit

class DropItBehavior: UIDynamicBehavior {
    
    let gravity = UIGravityBehavior()
    
    lazy var collider : UICollisionBehavior = {
        let lazyCreatedCollider = UICollisionBehavior()
        lazyCreatedCollider.translatesReferenceBoundsIntoBoundary = true
        return lazyCreatedCollider
        }()
    
    lazy var dropBehavior : UIDynamicItemBehavior = {
        let lazyCreatedDropBehavior = UIDynamicItemBehavior()
        lazyCreatedDropBehavior.allowsRotation = true
        lazyCreatedDropBehavior.elasticity = 0.25
        return lazyCreatedDropBehavior
        }()
    override init(){
        super.init()
        addChildBehavior(gravity)
        addChildBehavior(collider)
        addChildBehavior(dropBehavior)
    }
    
    func addBarrier(path: UIBezierPath, name: String)
    {
        collider.removeBoundaryWithIdentifier(name)
        collider.addBoundaryWithIdentifier(name, forPath: path)
    }
    
    
    func addDrop(dropView: UIView){
        dynamicAnimator?.referenceView?.addSubview(dropView)
        gravity.addItem(dropView)
        collider.addItem(dropView)
        dropBehavior.addItem(dropView)
    }
    
    func removeDrop(dropView: UIView){
        gravity.removeItem(dropView)
        collider.removeItem(dropView)
        dropBehavior.removeItem(dropView)
        dropView.removeFromSuperview()
    }
}
