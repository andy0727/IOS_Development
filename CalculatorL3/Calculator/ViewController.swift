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
    @IBOutlet weak var showHistory: UILabel!
    var userIsInTheMiddleOfTyping = false
    var isFloat = 0
    var brain = CalculatorBrain()
    
    @IBAction func appendDigit(sender: UIButton) {
        let digit=sender.currentTitle!
        if userIsInTheMiddleOfTyping{
            display.text = display.text! + digit
        }
        else{
            display.text=digit
            userIsInTheMiddleOfTyping=true
        }
    }
    
    @IBAction func appendFloat(sender: UIButton) {
        if let dis = displayValue{
            if isFloat == 0{
                display.text = userIsInTheMiddleOfTyping ?
                    display.text! + "." : "0."
                userIsInTheMiddleOfTyping = true
            }else{
                displayValue = nil
            }
            ++isFloat
        }
    }
    
    @IBAction func operate(sender: UIButton) {
        if userIsInTheMiddleOfTyping {
            enter()
        }
        if let operation=sender.currentTitle{
            displayValue = brain.performOperation(operation)
        }
    }
    
    @IBAction func MRelatd(sender: UIButton) {
        if sender.currentTitle! == "→M"{
            if let md = displayValue{
                brain.variableValues["M"] = md
            }
        }
        else if sender.currentTitle! == "M"{
            brain.pushOperand("M")
            
        }
        displayValue = brain.evaluate()
    }
    
    @IBAction func enter() {
        if let dis = displayValue{
            displayValue = brain.pushOperand(dis)
        }
    }
    
    @IBAction func clear() {
        brain.clear()
        displayValue = 0
    }
    
    var displayValue: Double? {
        get{
            if let dis = display.text , val = NSNumberFormatter().numberFromString(dis)?.doubleValue {
                return val
            }
            return nil
        }
        set{
            if let val = newValue{
                display.text = "\(val)"
                            }
            else {
                display.text = nil
            }
            userIsInTheMiddleOfTyping=false
            isFloat = 0
            showHistory.text = "\(brain)"
        }
        
    }
    
}

