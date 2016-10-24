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
        
        if userIsInTheMiddleOfTypingANumber{
            enter()
        }
        if let operation = sender.currentTitle{
            
            if let result = brain.performOperation(operation){
            history.text! = history.text! + operation
            display.text! = result
                
            }else{
                displayValue = 0
            }
        }
    }



    

    
    @IBAction func clear() {
        userIsInTheMiddleOfTypingANumber = false;
        display.text! = "0"
        history.text! = " "
        brain.emptyOpStack()
    }
    
    @IBAction func enter() {
        
        if let result = brain.pushOperand(displayValue){
            displayValue = result
        }
        else{
            userIsInTheMiddleOfTypingANumber = false
            displayValue = 0
        }

    }
    
    var displayValue: Double{
        get{
            return NumberFormatter().number(from: display.text!)!.doubleValue
        }
        set{
            display.text = "\(newValue)"
            userIsInTheMiddleOfTypingANumber = false
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





