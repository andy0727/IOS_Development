//
//  ViewController.swift
//  Calculator
//
//  Created by Andy Zhu on 6/8/15.
//  Copyright (c) 2015 Andy Zhu. All rights reserved.
//

import UIKit

class ViewController: UIViewController
{

    @IBOutlet weak var display: UILabel!  //still optional but told to always unwrap
    var userIsInTheMiddleOfTyping = false
    @IBAction func appendDigit(sender: UIButton) {
        let digit=sender.currentTitle!
        if userIsInTheMiddleOfTyping{
            display.text=display.text! + digit
        }
        else{
            display.text=digit
            userIsInTheMiddleOfTyping=true
        }
        println("digit=\(digit)")
            
        
    }
    @IBAction func operate(sender: UIButton) {
        let operation=sender.currentTitle!
        
        switch operation{
        case "✖️":
            if operandStack.count >= 2 {
                displayValue=operandStack.removeLast()
                enter(sender)
            } 
//        case "➗":
//        case "➕":
//        case "➖":
        default: break
        }
    }
    
    
    var operandStack = Array<Double>()
    
    @IBAction func enter(sender: UIButton) {
        userIsInTheMiddleOfTyping=false
        operandStack.append(displayValue)
        println("operandStack = \(operandStack)")
        
    }
    var displayValue: Double {
        get{
            return NSNumberFormatter().numberFromString(display.text!)!.doubleValue
        }
        set{
            display.text = "\(newValue)"
            userIsInTheMiddleOfTyping=false
        }
        
    }
    
}

