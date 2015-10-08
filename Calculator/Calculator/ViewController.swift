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
        if userIsInTheMiddleOfTyping {
            enter()
        }
        switch operation{
        case "✖️": performOperatation {$0 * $1}
        case "➗": performOperatation {$1 / $0}
        case "➕": performOperatation {$0 + $1}
        case "➖": performOperatation {$1 - $0}
        case "√": performOperatation {sqrt($0)}
        default: break
        }
    }
    
    func performOperatation(operation: (Double,Double) -> Double){
        if operandStack.count >= 2 {
            displayValue=operation(operandStack.removeLast() , operandStack.removeLast())
            enter()
        }
    }
    func performOperatation(operation: (Double) -> Double){
        if operandStack.count >= 1 {
            displayValue=operation(operandStack.removeLast())
            enter()
        }
    }
    
    var operandStack = Array<Double>()
    
    @IBAction func enter() {
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

