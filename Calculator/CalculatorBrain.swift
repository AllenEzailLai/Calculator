//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Allen Lai on 9/03/2015.
//  Copyright (c) 2015 Allen. All rights reserved.
//

import Foundation

class CalculatorBrain {
  private enum Op: Printable {
    case Operand(Double)
    case UnaryOperation(String, Double -> Double)
    case BinaryOperation(String, (Double, Double) -> Double)
    
    var description: String {
      get {
        switch self {
        case .Operand(let operand):
          return "\(operand)"
        case .UnaryOperation(let symbol, _):
          return symbol
        case .BinaryOperation(let symbol, _):
          return symbol
        }
      }
    }
   }
  
//  var opStack = Array<Op>()
  private var opStack = [Op]()
  
//  var knowOps = Dictionary<String, Op>()
  private var knowOps = [String: Op]()
  
  init() {
//    func learnOp(op: Op) {
//      knowOps[op.description] = op
//    }
//    knowOps["×"] = Op.BinaryOperation("×") { $0 * $1 }
    knowOps["×"] = Op.BinaryOperation("×", *)
//    learnOp(Op.BinaryOperation("×", *))
    knowOps["÷"] = Op.BinaryOperation("÷") { $1 / $0 }
    knowOps["+"] = Op.BinaryOperation("+", +)
    knowOps["−"] = Op.BinaryOperation("−") { $1 - $0 }
    knowOps["√"] = Op.UnaryOperation("√", sqrt)
    
    
  }
  
  typealias PropertyList = AnyObject
  
  var program: PropertyList {
    get {
      return opStack.map { $0.description }
//      var returnValue = Array<String>()
//      for op in opStack {
//        returnValue.append(op.description)
//      }
//      return returnValue
    }
    set {
      if let opSymbols = newValue as? Array<String> {
        var newOpStack = [Op]()
        for opSymbol in opSymbols {
          if let op = knowOps[opSymbol] {
            newOpStack.append(op)
          } else if let operand = NSNumberFormatter().numberFromString(opSymbol)?.doubleValue {
            newOpStack.append(.Operand(operand))
          }
        }
      }
    }
  }
  
  private func evaluate(ops: [Op]) -> (result: Double?, remainingOps: [Op]) {
    if !ops.isEmpty {
      var remainingOps = ops
      let op = remainingOps.removeLast()
      switch op {
      case .Operand(let operand):
        return (operand, remainingOps)
      case .UnaryOperation(_, let operation):
        let operationEvaluation = evaluate(remainingOps)
        if let operand = operationEvaluation.result {
          return (operation(operand), operationEvaluation.remainingOps)
        }
      case .BinaryOperation(_, let operation):
        let op1Evaluation = evaluate(remainingOps)
        if let operand1 = op1Evaluation.result {
          let op2Evaluation = evaluate(op1Evaluation.remainingOps)
          if let operand2 = op2Evaluation.result {
            return (operation(operand1, operand2), op2Evaluation.remainingOps)
          }
        }
      }
    }
    return (nil, ops)
  }
  
  func evaluate() -> Double? {
    let (result, remainder) = evaluate(opStack)
    println("\(opStack) = \(result) with \(remainder) left over")
    return result
  }
  
  func pushOperand(operand: Double) -> Double? {
    opStack.append(Op.Operand(operand))
    return evaluate()
  }
  
  func performOperation(symbol: String) -> Double? {
    if let operation = knowOps[symbol] {
      opStack.append(operation)
    }
    return evaluate()
  }
}