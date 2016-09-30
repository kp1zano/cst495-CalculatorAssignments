//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Karina Pizano on 9/14/16.
//  Copyright © 2016 Karina Pizano. All rights reserved.
//

import Foundation


enum CalculatorBrainEvaluationResult {
    case Success(Double)
    case Failure(String)
}

class CalculatorBrain{
    
    /* Creates an empty array - var opStack = Array<Op>()
     * Creates dictionary - var knownOps = Dictionary<String, Op>()
    */
    
    private enum Op : CustomStringConvertible{
        case operand(Double)
        case unaryOperation(String, (Double) -> Double)
        case binaryOperation(String, (Double, Double) -> Double)
        case variable(String)
        case constant(String, Double)
        
    
        var description: String{
            switch self {
            case .operand(let operand):
                return "\(operand)"
            case .unaryOperation(let symbol, _):
                return symbol
            case .binaryOperation(let symbol, _):
                return symbol
            case .variable(let symbol):
                return "\(symbol)"
            case .constant(let symbol, _):
                return "\(symbol)"
            }
        }
        
        var precedence: Int {
            switch self {
            case .operand(_), .variable(_), .constant(_, _), .unaryOperation(_, _):
                return Int.max
            case .binaryOperation(_, _):
                return Int.min
            }
        }
    }
    
    private var opStack = [Op]()
    private var knownOps = [String:Op]()
    var variableValues = [String:Double]()
    private var error: String?
    
//    
//    var description: String {
//        let (descriptionArray, _) = description([String](), ops: opStack)
//        return descriptionArray.joinWithSeparator(", ")
//    }
    
    /* Initializer for the Stack <<Constructor>>*/
    init(){
        
        func learnOp(_ op: Op){
            knownOps[op.description] = op
        }
        
        //Binary Operations
        learnOp(Op.binaryOperation("×", *))
        knownOps["+"] = Op.binaryOperation("+", +)
        knownOps["−"] = Op.binaryOperation("−") {$0 - $1}
        knownOps["÷"] = Op.binaryOperation("÷") {$1 / $0}
        
        //Unary Operations
        knownOps["sin"] = Op.unaryOperation("sin") {sin($0)}
        knownOps["cos"] = Op.unaryOperation("cos") {cos($0)}
        knownOps["√"] = Op.unaryOperation("√", sqrt)
        
    }
    
    
    fileprivate func evaluate(_ ops: [Op]) -> (result: Double?, remainingOps:[Op]){
        
        if(!ops.isEmpty){
            
            var remainingOps = ops
            let op = remainingOps.removeLast()
            switch op{
            case .variable(let symbol):
                if let variableValue = variableValues[symbol] {
                    return (variableValue, remainingOps)
                } else {
                    error = "\(symbol) is not set"
                    return (nil, remainingOps)
                }
            case .operand(let operand):
                return (operand, remainingOps)
            case .unaryOperation(_, let operation):
                let operandEvaluation = evaluate(remainingOps)
                if let operand = operandEvaluation.result{
                    return (operation(operand), operandEvaluation.remainingOps)
                }
            case .binaryOperation(_, let operation):
                let op1Evaluation = evaluate(remainingOps)
                if let operand1 = op1Evaluation.result{
                    let op2Evaluation = evaluate(op1Evaluation.remainingOps)
                    if let operand2 = op2Evaluation.result{
                        return (operation(operand1, operand2), op2Evaluation.remainingOps)
                    }
                }
            case .constant(_, let constantValue):
                return (constantValue, remainingOps)
            }
        }
        return(nil, ops)
    }
    
    func evaluate() -> Double? {
        let (result, remainder) = evaluate(opStack)
        print("\(opStack) = \(result) with \(remainder) left over ")
        return result
    }
    
    func evaluateAndReportErrors() -> CalculatorBrainEvaluationResult {
        if let evaluationResult = evaluate() {
            if evaluationResult.isInfinite {
                return CalculatorBrainEvaluationResult.Failure("Infinite value")
            } else if evaluationResult.isNaN {
                return CalculatorBrainEvaluationResult.Failure("Not a number")
            } else {
                return CalculatorBrainEvaluationResult.Success(evaluationResult)
            }
        } else {
            if let returnError = error {
                // We consumed the error, now set error back to nil
                error = nil
                return CalculatorBrainEvaluationResult.Failure(returnError)
            } else {
                return CalculatorBrainEvaluationResult.Failure("Error")
            }
        }
    }
    
    func pushOperand(_ operand: Double) -> Double? {
        opStack.append(Op.operand(operand))
        return evaluate()
    }
    
    func removeLastOpFromStack() {
        if opStack.last != nil {
            opStack.removeLast()
        }
    }
    
    func pushOperand(operand: Double) -> CalculatorBrainEvaluationResult? {
        opStack.append(Op.operand(operand))
        return evaluateAndReportErrors()
    }
    
    func pushOperand(symbol: String) -> CalculatorBrainEvaluationResult? {
        opStack.append(Op.variable(symbol))
        return evaluateAndReportErrors()
    }
    
    func pushConstant(symbol: String) -> CalculatorBrainEvaluationResult? {
        if let constant = knownOps[symbol] {
            opStack.append(constant)
        }
        return evaluateAndReportErrors()
    }

    func performOperation(_ symbol: String) -> CalculatorBrainEvaluationResult? {
        
        if let operation = knownOps[symbol] {
            opStack.append(operation)
        }
      //return evaluate()
        return evaluateAndReportErrors()
    }
    
    func emptyOpStack(){
        //opStack.removeAll()
        opStack = [Op]()
    }
}
    
    
    
