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

    //This is an optinal that we get unwrap, so we dont always have to unwrap when using it.
    @IBOutlet weak var display: UILabel!
    @IBOutlet weak var history: UILabel!
    
    var userIsInTheMiddleOfTypingANumber = false
    var userEnteredAFloatingPointNumber = false;

    //User clicks on a digit it will show on the label.
    @IBAction func appendDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        
        if userIsInTheMiddleOfTypingANumber{
            //More than one number.
            if(digit == "." && userEnteredAFloatingPointNumber == false){
                userEnteredAFloatingPointNumber = true
                display.text = display.text! + digit
                history.text! = history.text! + display.text! + digit
            
            }
            else if(digit != "."){
                display.text = display.text! + digit
                history.text! = history.text! + display.text! + digit
            }
        }else{
            //The user entered the first number.
            display.text = digit
            history.text! = history.text! + digit
            userIsInTheMiddleOfTypingANumber = true
        }
        
        print("digit = \(digit)")
    }
    
    

    //Makes sure the user entered a number.
    @IBAction func operate(sender: UIButton) {
        let operation = sender.currentTitle!
        if userIsInTheMiddleOfTypingANumber{
            history.text! = history.text! + operation
            enter()
        }
        
        switch operation{
            case"×": performOperation {$0 * $1}
            case"÷": performOperation {$1 / $0}
            case"+": performOperation {$0 + $1}
            case"−": performOperation {$0 - $1}
            case"√": performOperations {sqrt($0)}
            case"sin": performOperations {sin($0)}
            case"cos": performOperations {cos($0)}
            case"π": displayPI()


            default: break
        }
    }

    func displayPI(){

        displayValue = M_PI
        enter()
    }
    
    //The operation background.
    func performOperation(operation: (Double, Double) -> Double) {
        if operandStack.count >= 2{
            displayValue = operation(operandStack.removeLast(), operandStack.removeLast())
            enter()
        }
    }
    
    func performOperations(operation: Double -> Double) {
        if operandStack.count >= 1{
            displayValue = operation(operandStack.removeLast())
            enter()
        }
    }
    
    @IBAction func clear() {
        userIsInTheMiddleOfTypingANumber = false;
        display.text! = "0"
        history.text! = " "
        operandStack.removeAll()
    }
    
    //When the user presses enter, all in the label will pushed in the stack.
    var operandStack = Array<Double>()
    @IBAction func enter() {
        userIsInTheMiddleOfTypingANumber = false
        operandStack.append(displayValue)
        print("OperandStack = \(operandStack)")
    }
    
    var displayValue: Double{
        get{
            return NSNumberFormatter().numberFromString(display.text!)!.doubleValue
        }
        set{
            display.text = "\(newValue)"
            userIsInTheMiddleOfTypingANumber = false
        }
    }
}

