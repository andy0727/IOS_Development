//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Andy Zhu on 8/14/15.
//  Copyright (c) 2015 Andy Zhu. All rights reserved.
//

import Foundation
class CalculatorBrain: Printable{
    
    private enum Op: Printable{ //protocol means implements whatever in this protocol
        case operand(Double)
        case operation(String, Double -> Double)
        case binaryOperation(String, (Double, Double) -> Double)
        case variable(String)
        
        var description: String{
            switch self {
            case .operand(let value):
                return "\(value)"
            case .operation(let value, _):
                return value
            case .binaryOperation(let value, _):
                return value
            case .variable(let str):
                return str
            }
        }
    }
    
    private var opStack = [Op]()
    private var knownOps = [String:Op]()
    
    
    var description: String{
        return describe()
    }
    
    var program: AnyObject {//guarantee to be property list
        get{
            return opStack.map {$0.description}
        }
        set{
            if let opSymbols = newValue as? [String]{
                var newOpstack=[Op]()
                for each in opSymbols{
                    if let op = knownOps[each]{
                        newOpstack.append(op)
                    } else{
                        if let operand = NSNumberFormatter().numberFromString(each)?.doubleValue{
                            newOpstack.append(.operand(operand))
                        }
                    }
                }
                opStack=newOpstack

            }
        }
    }
    
    var variableValues = [String : Double]()
    init(){
        func learnOp(op:Op){
            knownOps[op.description] = op
        }
        learnOp(Op.binaryOperation("×", *))
        knownOps["÷"] = Op.binaryOperation("÷") {$1 / $0}
        knownOps["+"] = Op.binaryOperation("+", +)
        knownOps["−"] = Op.binaryOperation("−") {$1 - $0}
        knownOps["√"] = Op.operation("√",sqrt)
        knownOps["π"] = Op.variable("π")
        learnOp(Op.operation("cos", cos))
        learnOp(Op.operation("sin", sin))
        variableValues["π"] = M_PI
        
    }
    
    
    func pushOperand(Operand: Double) -> Double?{
        opStack.append(Op.operand(Operand ))
        return evaluate()
    }
    
    func performOperation(Symbol:String) -> Double?{
        if let f = knownOps[Symbol]{
            opStack.append(f)
        }
        return evaluate()
    }
    
    
    private func evaluate(ops:[Op])-> (result: Double?,remainingOps: [Op]) {
        if !ops.isEmpty{
            var remainingOps = ops
            let top = remainingOps.removeLast()
            switch top{
            case .operand(let value):
                return (value, remainingOps)
            case .operation(_, let f):
                let (result,rm) = evaluate(remainingOps)
                if let first = result {
                    return (f(first), rm)
                }
            case .binaryOperation(_,let f):
                let (result,rm) = evaluate(remainingOps)
                if let first = result{
                    let (result2 , rm2) = evaluate(rm)
                    if let second = result2 {
                        return (f(first, second), rm2)
                    }
                }
            case .variable(let str):
                if let val = variableValues[str]{
                    println("i have m with value \(val)")
                    return (val, remainingOps)
                }
            }
            
        }
        return (nil,ops)
    }
    
    
    
    func evaluate()-> Double? {
        let (result,rm) = evaluate(opStack)
        println("\(opStack) = \(result) with \(rm) left over")
        return result
    }
    
    
    func clear(){
        opStack.removeAll()
        variableValues.removeValueForKey("M")
    }
    
    
    func pushOperand(symbol: String) -> Double?{
        opStack.append(Op.variable(symbol))
        return evaluate()
    }
    
    func describe() -> String {
        var res = ""
        var workingstack = opStack
        while !workingstack.isEmpty{
            let (str, ws , or) = describe(workingstack)
            workingstack = ws
            if let strstr = str{
                res += (res.isEmpty ? "" : " , ") + strstr
            } else{
                break
            }
        }
        return res
    }
    
    private func describe(ops:[Op]) -> (String?, [Op], Int){
        if !ops.isEmpty{
            var str = ""
            var remainingOps = ops
            let top = remainingOps.removeLast()
            switch top{
            case .operand(let val): return ("\(val)", remainingOps, 0)
            case .variable(let str): return (str, remainingOps, 0)
            case .operation(let o, _):
                let (arg1, rm1, or) = describe(remainingOps)
                if let val = arg1{
                    return (o+"("+val+")", rm1, 0)
                }else{
                    return (o+"(?)", rm1, 0)

                }
            case .binaryOperation(let o, _):
                var or = 0
                switch o{
                case "×", "÷": or = 1
                case "+", "-": or = 2
                default: or = 2
                }
                let (arg1, rm1, or1) = describe(remainingOps)
                if let val1 = arg1 {
                    var val = " \(o) " + ( or < or1 ? "(\(val1))" : val1 )
                    let (arg2, rm2, or2) = describe(rm1)
                    if let val2 = arg2{
                        val = ( or < or2 ? "(\(val2))" : val2 ) + val
                        return(val, rm2, or)
                    }else{
                        val = "?" + val
                        return (val, rm2, or)
                    }
                }else{
                    return ("?" + " \(o) " + "?", rm1, or)
                }
            }
        }
        return (nil, ops, 0)
    }
}
