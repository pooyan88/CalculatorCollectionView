//
//  CalculatorCollectionViewCell.swift
//  Calculator
//
//  Created by Pooyan J on 11/28/1403 AP.
//

import UIKit

class CalculatorCollectionViewCell: UICollectionViewCell {

    static func getSize(itemsInARow: Int, item: CalculatorViewModel.Item) -> CGSize {
        let totalWidth = UIScreen.main.bounds.width
        let padding: CGFloat = 4
        let itemWidth = (totalWidth - CGFloat(itemsInARow + 1) * padding) / CGFloat(itemsInARow)
        let itemHeight = itemWidth
        if item.title == "0" {
            return CGSize(width: itemWidth * 2 + padding, height: itemHeight)
        } else {
            return CGSize(width: itemWidth, height: itemHeight)
        }
    }

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
