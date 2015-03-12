//
//  ViewController.swift
//  Calculator
//
//  Created by Allen Lai on 5/03/2015.
//  Copyright (c) 2015 Allen. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  @IBOutlet weak var display: UILabel!
  
  var userIsInTheMiddleOfTypingNumber = false
  
  var brain = CalculatorBrain()
  
  @IBAction func appendDigit(sender: UIButton) {
    let digit = sender.currentTitle!
    if userIsInTheMiddleOfTypingNumber {
      display.text = display.text! + digit
    } else {
      display.text = digit
      userIsInTheMiddleOfTypingNumber = true
    }
//    println("digit = \(digit)")
  }
  
  @IBAction func operate(sender: UIButton) {
//    let operation = sender.currentTitle!
    if userIsInTheMiddleOfTypingNumber {
      enter()
    }
    if let operation = sender.currentTitle {
      if let result = brain.performOperation(operation) {
        displayValue = result
      } else {
        displayValue = 0
      }
    }
//    switch operation {
//    case "×": performOperation { $0 * $1 }
//    case "÷": performOperation { $1 / $0 }
//    case "+": performOperation { $0 + $1 }
//    case "−": performOperation { $1 - $0 }
//    case "√": performOp { sqrt($0) }
//    default: break
//    }
  }
  
//  func performOperation(operation: (Double, Double) -> Double) {
//    if operandStack.count >= 2 {
//      displayValue = operation(operandStack.removeLast(), operandStack.removeLast())
//      enter()
//    }
//  }
//  
//  func performOp(operation: Double -> Double) {
//    if operandStack.count >= 1 {
//      displayValue = operation(operandStack.removeLast())
//      enter()
//    }
//  }
  
//  var operandStack = Array<Double>()

  @IBAction func enter() {
    userIsInTheMiddleOfTypingNumber = false
    if let result = brain.pushOperand(displayValue) {
      displayValue = result
    } else {
      displayValue = 0
    }
//    operandStack.append(displayValue)
//    println("operandStack = \(operandStack)")
  }
  
  var displayValue: Double {
    get {
      return NSNumberFormatter().numberFromString(display.text!)!.doubleValue
    }
    set {
      display.text = "\(newValue)"
      userIsInTheMiddleOfTypingNumber = false
    }
  }
}

