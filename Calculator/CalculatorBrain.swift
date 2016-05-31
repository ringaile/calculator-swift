//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Ringaile Valiaugaite on 28/05/2016.
//  Copyright © 2016 ringaile. All rights reserved.
//

import Foundation

class CalculatorBrain {
    
    private var accumulator = 0.0
    private var internalProgram = [AnyObject]()
    
    func setOperand (operand : Double){
        accumulator = operand
        internalProgram.append(operand)
    }
    
    private var operations : Dictionary<String, Operation> = [
        "π" : Operation.Constant(M_PI), //M_PI,
        "e" : Operation.Constant(M_E), //M_E
        "±": Operation.UnaryOperation({ -$0 }),
        "√ ": Operation.UnaryOperation(sqrt), //sqrt,
        "cos:" : Operation.UnaryOperation(cos), //cos
        "*" : Operation.BinaryOperation({$0 * $1}),
        "/" : Operation.BinaryOperation({$0 / $1}),
        "+" : Operation.BinaryOperation({$0 + $1}),
        "-" : Operation.BinaryOperation({$0 - $1}),
        "=" : Operation.Equals
    ]
    
    private enum Operation {
        case Constant(Double)
        case UnaryOperation ((Double) -> Double)
        case BinaryOperation ((Double, Double) -> Double)
        case Equals
    }
    
    func performOperantion(symbol : String) {
        internalProgram.append(symbol)
        if let operation = operations[symbol] {
            switch operation {
            case .Constant (let value) : accumulator = value
            case .UnaryOperation (let function) :
                executePendingBinaryOperationInfo()
                accumulator = function(accumulator)
            case .BinaryOperation (let function ): pending = PendingBinaryOperationInfo(binaryFunction: function, firstOperand: accumulator)
            case .Equals :
                executePendingBinaryOperationInfo()
            }
        }
    }
    
    private func executePendingBinaryOperationInfo(){
        if  pending != nil {
            accumulator = pending!.binaryFunction(pending!.firstOperand, accumulator)
            pending = nil
        }
    }
    
    private var pending : PendingBinaryOperationInfo?
    
    struct PendingBinaryOperationInfo {
        var binaryFunction: (Double, Double) -> Double
        var firstOperand : Double
    }
    
    typealias PropertyList = AnyObject
    
    var program: PropertyList{
        get{
            return internalProgram
        }
        set{
            clear()
            if let arrayOfOps  = newValue as? [AnyObject]{
                for op in arrayOfOps{
                    if let operand = op as? Double{
                        setOperand(operand)
                    }else if let operand = op as? String{
                        performOperantion(operand)
                    }
                }
            }
        }
    }
    
    func clear(){
        accumulator = 0.0
        pending = nil
        internalProgram.removeAll()
    }
    
    var result : Double {
        get{
            return accumulator
        }
    }
}