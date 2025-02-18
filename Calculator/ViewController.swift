//
//  ViewController.swift
//  Calculator
//
//  Created by Pooyan J on 11/28/1403 AP.
//

import UIKit

class ViewController: UIViewController {

    enum OperatorType {
        case add, subtract, multiply, divide, minusPlus, radical, equal
    }

    enum ItemType {
        case number, operand(type: OperatorType), canceller, decimal
    }

    struct Item {
        var title: String
        var type: ItemType
        var backgroundColor: UIColor
    }

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var collectionView: UICollectionView!

    var items: [Item] = [
        Item(title: "AC", type: .canceller, backgroundColor: .darkGray),
        Item(title: "±", type: .operand(type: .minusPlus), backgroundColor: .darkGray),
        Item(title: "√", type: .operand(type: .radical), backgroundColor: .darkGray),
        Item(title: "C", type: .canceller, backgroundColor: .systemOrange),
        Item(title: "7", type: .number, backgroundColor: .lightGray),
        Item(title: "8", type: .number, backgroundColor: .lightGray),
        Item(title: "9", type: .number, backgroundColor: .lightGray),
        Item(title: "*", type: .operand(type: .multiply), backgroundColor: .systemOrange),
        Item(title: "4", type: .number, backgroundColor: .lightGray),
        Item(title: "5", type: .number, backgroundColor: .lightGray),
        Item(title: "6", type: .number, backgroundColor: .lightGray),
        Item(title: "+", type: .operand(type: .add), backgroundColor: .systemOrange),
        Item(title: "1", type: .number, backgroundColor: .lightGray),
        Item(title: "2", type: .number, backgroundColor: .lightGray),
        Item(title: "3", type: .number, backgroundColor: .lightGray),
        Item(title: "-", type: .operand(type: .subtract), backgroundColor: .systemOrange),
        Item(title: "0", type: .number, backgroundColor: .lightGray),
        Item(title: ".", type: .decimal, backgroundColor: .lightGray),
        Item(title: "=", type: .operand(type: .equal), backgroundColor: .systemOrange)
    ]

    // Calculator variables
    var currentInput = "0"
    var previousInput = ""
    var currentOperator: OperatorType?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
}

// MARK: - Setup Functions
extension ViewController {

    private func setupViews() {
        setupCollectionView()
        setupTextField()
    }

    private func setupTextField() {
        textField.textColor = .white
        textField.textAlignment = .right
        textField.isUserInteractionEnabled = false
        textField.text = currentInput
    }

    private func setupCollectionView() {
        collectionView.register(UINib(nibName: "CalculatorCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CalculatorCollectionViewCell")
        collectionView.delegate = self
        collectionView.dataSource = self
    }
}

// MARK: - CollectionView functions
extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CalculatorCollectionViewCell", for: indexPath) as! CalculatorCollectionViewCell
        let item = items[indexPath.item]
        cell.setup(config: CalculatorCollectionViewCell.Config(title: item.title, backgroundColor: item.backgroundColor))
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CalculatorCollectionViewCell.getSize(itemsInARow: 4, item: items[indexPath.row])
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 4
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .zero
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = items[indexPath.item]
        handleButtonPress(item: item)
    }
}

// MARK: - Actions
extension ViewController {

    private func handleButtonPress(item: Item) {
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
        guard let operatorType = currentOperator, let previousValue = Double(previousInput), let currentValue = Double(currentInput) else {
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
            if currentValue != 0 {
                result = previousValue / currentValue
            } else {
                result = 0
            }
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
        textField.text = currentInput
    }
}
