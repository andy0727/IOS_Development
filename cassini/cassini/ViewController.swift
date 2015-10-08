//
//  ViewController.swift
//  cassini
//
//  Created by Andy Zhu on 8/16/15.
//  Copyright (c) 2015 Andy Zhu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let ivc = segue.destinationViewController as? ImageViewController{
            if let identifier = segue.identifier{
                switch identifier{
                case "cassiniDetail":
                    ivc.imageUrl = DemoURL.nasa.cassini
                    ivc.title = "Cassini"
                case "earthDetail":
                    ivc.imageUrl = DemoURL.nasa.earth
                    ivc.title = "Earth"
                case "saturnDetail":
                    ivc.imageUrl = DemoURL.nasa.saturn
                    ivc.title = "Saturn"
                default: ivc.imageUrl = nil
                }
            }
        }
    }
}

