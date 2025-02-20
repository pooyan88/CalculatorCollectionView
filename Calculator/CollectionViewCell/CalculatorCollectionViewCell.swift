//
//  CalculatorCollectionViewCell.swift
//  Calculator
//
//  Created by Pooyan J on 11/28/1403 AP.
//

import UIKit

class CalculatorCollectionViewCell: UICollectionViewCell {

    struct Config {
        var title: String
        var backgroundColor: String
    }

    @IBOutlet weak var parentView: UIView!
    @IBOutlet weak var label: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        parentView.layer.cornerRadius = parentView.frame.height / 2
    }
}

// MARK: - Setup Functions
extension CalculatorCollectionViewCell {

    func setup(config: Config) {
        parentView.backgroundColor = UIColor(hex: config.backgroundColor)
        label.text = config.title
    }
}
