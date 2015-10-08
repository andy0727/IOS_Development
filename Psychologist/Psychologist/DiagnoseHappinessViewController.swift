
//
//  File.swift
//  Psychologist
//
//  Created by Andy Zhu on 8/16/15.
//  Copyright (c) 2015 Andy Zhu. All rights reserved.
//

import Foundation
import UIKit
class DiagnoseHappinessViewController : HappinessViewController, UIPopoverPresentationControllerDelegate
{
    override var happiness: Int {
        didSet{
            DiagnoseHistory += [happiness]
        }
    }
    private let defaults = NSUserDefaults.standardUserDefaults()
    
    var DiagnoseHistory: [Int]{
        get{
            return defaults.objectForKey(History.key) as? [Int] ?? [Int]()
        }
        set{
            defaults.setObject(newValue, forKey: History.key)
        }
    }
    
    private struct History{
        static let SegueId = "showDiagnosticHistory"
        static let key = "DiagnoseHappinessViewController.DiagnoseHistory"
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let id = segue.identifier{
            switch id{
            case History.SegueId:
                if let tvc = segue.destinationViewController as? TextUIViewController
                {
                    if let ppc = tvc.popoverPresentationController{
                        ppc.delegate = self
                    }
                    tvc.text = "\(DiagnoseHistory)"
                }
            default: break
            }
        }
    }
    
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController!, traitCollection: UITraitCollection!) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.None
    }
}