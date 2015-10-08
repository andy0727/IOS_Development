//
//  ViewController.swift
//  Psychologist
//
//  Created by Andy Zhu on 8/16/15.
//  Copyright (c) 2015 Andy Zhu. All rights reserved.
//

import UIKit

class PsychologistViewController: UIViewController {

    @IBAction func nothingAction(sender: UIButton) {
        performSegueWithIdentifier("nothing", sender: nil)
        
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var dest = segue.destinationViewController as? UIViewController
        if let navcon = dest as? UINavigationController{
            dest = navcon.visibleViewController
        }
        if let hvc = dest as? HappinessViewController{
            if let id = segue.identifier{
                switch id {
                case "bearId": hvc.happiness = 0
                case "dancingId": hvc.happiness = 100
                case "buckeyeId": hvc.happiness = 50
                case "nothing" : hvc.happiness = 25
                default: break
                }
            }
        }
    }


}

