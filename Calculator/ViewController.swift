//
//  ViewController.swift
//  Calculator
//
//  Created by Karina Pizano on 9/6/16.
//  Copyright © 2016 Karina Pizano. All rights reserved.
//

import UIKit
import Foundation

class ViewController: UIViewController {

    @IBOutlet weak var display: UILabel!
    @IBOutlet weak var history: UILabel!
    
    var operandStack = Array<Double>()
    
    var userIsInTheMiddleOfTypingANumber = false
    var userEnteredAFloatingPointNumber = false;
    
    var brain = CalculatorBrain()
    
    
    private struct DefaultDisplayResult {
        static let Startup: Double = 0
        static let Error = "Error!"
    }

    //User clicks on a digit it will show on the label.
    @IBAction func appendDigit(_ sender: UIButton) {
        let digit = sender.currentTitle!
        
        if userIsInTheMiddleOfTypingANumber{
            if(digit == "." && userEnteredAFloatingPointNumber == false){
                userEnteredAFloatingPointNumber = true
                if(display.text == "Error"){
                    //print("Too many")
                    display.text = digit
                    history.text! = history.text! + display.text! + digit
                }else{
                    display.text = display.text! + digit
                    history.text! = history.text! + digit
                    //userEnteredAFloatingPointNumber = false;
                }
                
            }
            else if(digit != "."){
                //userEnteredAFloatingPointNumber = false;
                display.text = display.text! + digit
                history.text! = history.text! + digit
            }
            else if(digit == "." && userEnteredAFloatingPointNumber == true){
                display.text = "Error"
            }
        }else{
            //The user entered the first number.
            display.text = digit
            history.text! = history.text! + digit
            userIsInTheMiddleOfTypingANumber = true
            userEnteredAFloatingPointNumber = false
        }
        
        //print("digit = \(digit)")
    }
    
    
    //Makes sure the user entered a number.
    @IBAction func operate(_ sender: UIButton) {
        
//        if userIsInTheMiddleOfTypingANumber{
//            enter()
//        }
//        if let operation = sender.currentTitle{
//            
//            if let result = brain.performOperation(operation){
//            history.text! = history.text! + operation
//            displayValue = result
//                
//            }else{
//                displayValue = 0
//            }
//        }
        
        if userIsInTheMiddleOfTypingANumber {
            enter()
        }
        if let operation = sender.currentTitle {
            displayResult = brain.performOperation(operation)
        }
    }
    @IBAction func Sign() {
        
        if userIsInTheMiddleOfTypingANumber {
            if displayValue != nil {
                displayResult = CalculatorBrainEvaluationResult.Success(displayValue! * -1)
                
                // set userIsInTheMiddleOfTypingANumber back to true as displayResult will set it to false
                userIsInTheMiddleOfTypingANumber = true
            }
        } else {
            displayResult = brain.performOperation("ᐩ/-")
        }

    }


    @IBAction func pi() {
        
        if userIsInTheMiddleOfTypingANumber {
            enter()
        }
        displayResult = brain.pushConstant(symbol: "π")
    }

    @IBAction func Undo() {
        
        if userIsInTheMiddleOfTypingANumber == true {
            if display.text!.characters.count > 1 {
                display.text = String(display.text!.characters.dropLast())
            } else {
                displayResult = CalculatorBrainEvaluationResult.Success(DefaultDisplayResult.Startup)
            }
        } else {
            brain.removeLastOpFromStack()
            displayResult = brain.evaluateAndReportErrors()
        }
    }
    
    
    @IBAction func setM() {
        
        userIsInTheMiddleOfTypingANumber = false
        if displayValue != nil {
            brain.variableValues["M"] = displayValue!
        }
        displayResult = brain.evaluateAndReportErrors()
    }
    

    
    @IBAction func clear() {
        userIsInTheMiddleOfTypingANumber = false;
        display.text! = "0"
        history.text! = " "
        brain.emptyOpStack()
    }
    
    @IBAction func enter() {
        
//        if let result = brain.pushOperand(displayValue){
//            displayValue = result
//        }
//        else{
//            userIsInTheMiddleOfTypingANumber = false
//            displayValue = 0
//        }
        
        userIsInTheMiddleOfTypingANumber = false
        if displayValue != nil {
            //displayValue = brain.pushOperand(displayValue!)
            display.text! = "M"
        }
    }
    
    var displayValue: Double?{
        if let displayValue = NumberFormatter().number(from: display.text!) {
            return displayValue.doubleValue
        }
        return nil
    }
    
    
    
    var displayResult: CalculatorBrainEvaluationResult? {
        get {
            if let displayValue = displayValue {
                return .Success(displayValue)
            }
            if display.text != nil {
                return .Failure(display.text!)
            }
            return .Failure("Error")
        }
        set {
            if newValue != nil {
                switch newValue! {
                case let .Success(displayValue):
                    display.text = "\(displayValue)"
                case let .Failure(error):
                    display.text = error
                }
            } else {
                //display.text = DefaultDisplayResult.Error
                display.text = ""
            }
            userIsInTheMiddleOfTypingANumber = false
            
            //            if !brain.description.isEmpty {
            //                history.text = " \(brain.description) ="
            //            } else {
            //                history.text = defaultHistoryText
            //            }
        }
    }
}







//            switch operation
//            {
//            case "×": currentOperation = "×"; performOperation { $0 * $1 }
//            case "÷": currentOperation = "÷"; performOperation { $1 / $0 }
//            case "+": currentOperation = "+"; performOperation { $0 + $1 }
//            case "−": currentOperation = "−"; performOperation { $1 - $0 }
//            case "√": currentOperation = "√"; performOperation { sqrt($0) }
//            case "sin": currentOperation = "sin"; performOperation { sin($0) }
//            case "cos": currentOperation = "cos"; performOperation { cos($0) }
//
//            default: break
//            }

//    private func performOperation(operation: (Double, Double) -> Double) {
//        if operandStack.count >= 2 {
//            displayValue = operation(operandStack.removeLast(), operandStack.removeLast())
//            enter()
//        }
//    }
//
//    private func performOperation(operation: Double -> Double) {
//        if operandStack.count >= 1 {
//            displayValue = operation(operandStack.removeLast())
//            enter()
//        }
//    }





