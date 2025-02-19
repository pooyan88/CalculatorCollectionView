//
//  CalculatorViewModel.swift
//  Calculator
//
//  Created by Pooyan J on 12/1/1403 AP.
//

import Foundation

final class CalculatorViewModel {

    enum OperatorType {
        case add, subtract, multiply, divide, minusPlus, radical, equal
    }

    enum ItemType {
        case number, operand(type: OperatorType), canceller, decimal
    }

    struct Item {
        var title: String
        var type: ItemType
        var backgroundColor: String
    }

    var items: [Item] = [
        Item(title: "AC", type: .canceller, backgroundColor: .darkGray),
        Item(title: "±", type: .operand(type: .minusPlus), backgroundColor: .darkGray),
        Item(title: "√", type: .operand(type: .radical), backgroundColor: .darkGray),
        Item(title: "C", type: .canceller, backgroundColor: .calculatorOrange),
        Item(title: "7", type: .number, backgroundColor: .lightGray),
        Item(title: "8", type: .number, backgroundColor: .lightGray),
        Item(title: "9", type: .number, backgroundColor: .lightGray),
        Item(title: "*", type: .operand(type: .multiply), backgroundColor: .calculatorOrange),
        Item(title: "4", type: .number, backgroundColor: .lightGray),
        Item(title: "5", type: .number, backgroundColor: .lightGray),
        Item(title: "6", type: .number, backgroundColor: .lightGray),
        Item(title: "+", type: .operand(type: .add), backgroundColor: .calculatorOrange),
        Item(title: "1", type: .number, backgroundColor: .lightGray),
        Item(title: "2", type: .number, backgroundColor: .lightGray),
        Item(title: "3", type: .number, backgroundColor: .lightGray),
        Item(title: "-", type: .operand(type: .subtract), backgroundColor: .calculatorOrange),
        Item(title: "0", type: .number, backgroundColor: .lightGray),
        Item(title: ".", type: .decimal, backgroundColor: .lightGray),
        Item(title: "=", type: .operand(type: .equal), backgroundColor: .calculatorOrange)
    ]

    var reloadCollectionView: () -> Void
    var textFieldText = ""
    var currentInput = "0"
    var previousInput = ""
    var currentOperator: OperatorType?

    init(reloadCollectionView: @escaping () -> Void) {
        self.reloadCollectionView = reloadCollectionView
    }
}

// MARK: - Actions
extension CalculatorViewModel {

    func handleButtonPress(item: Item) {
        switch item.type {
        case .number:
            handleNumberPress(number: item.title)
        case .operand(let operatorType):
            handleOperandPress(operatorType: operatorType)
        case .decimal:
            handleDecimalPress()
        case .canceller:
            handleCancelPress()
        }
    }

    private func handleNumberPress(number: String) {
        if currentInput == "0" {
            currentInput = number
        } else {
            currentInput += number
        }
        updateTextField()
    }

    private func handleOperandPress(operatorType: OperatorType) {
        if operatorType == .equal {
            performCalculation()
        } else {
            if !previousInput.isEmpty {
                performCalculation()
            }
            currentOperator = operatorType
            previousInput = currentInput
            currentInput = "0"
        }
        updateTextField()
    }

    private func handleDecimalPress() {
        if !currentInput.contains(".") {
            currentInput += "."
        }
        updateTextField()
    }

    private func handleCancelPress() {
        currentInput = "0"
        previousInput = ""
        currentOperator = nil
        updateTextField()
    }

    private func performCalculation() {
        guard let operatorType = currentOperator,
              let previousValue = Double(previousInput),
              let currentValue = Double(currentInput) else {
            return
        }

        var result: Double = 0
        switch operatorType {
        case .add:
            result = previousValue + currentValue
        case .subtract:
            result = previousValue - currentValue
        case .multiply:
            result = previousValue * currentValue
        case .divide:
            result = currentValue != 0 ? previousValue / currentValue : 0
        case .minusPlus:
            result = currentValue * -1
        case .radical:
            result = sqrt(currentValue)
        case .equal:
            return
        }
        currentInput = String(result)
        previousInput = ""
        currentOperator = nil
        updateTextField()
    }

    private func updateTextField() {
        textFieldText = currentInput
    }
}
