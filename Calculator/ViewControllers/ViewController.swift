//
//  ViewController.swift
//  Calculator
//
//  Created by Pooyan J on 11/28/1403 AP.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var collectionView: UICollectionView!

    var viewModel: CalculatorViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewModel()
        setupViews()
    }
}

// MARK: - Setup Functions
extension ViewController {

    private func setupViewModel() {
        viewModel = CalculatorViewModel(reloadCollectionView: { [weak self] in
            self?.reloadCollectionView()
        })
    }

    private func setupViews() {
        setupCollectionView()
        setupTextField()
    }

    private func setupTextField() {
        textField.textColor = .white
        textField.textAlignment = .right
        textField.isUserInteractionEnabled = false
        textField.text = viewModel?.currentInput
    }

    private func setupCollectionView() {
        collectionView.register(UINib(nibName: "CalculatorCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CalculatorCollectionViewCell")
        collectionView.collectionViewLayout = createLayout()
        collectionView.delegate = self
        collectionView.dataSource = self
    }

    private func reloadCollectionView() {
        collectionView.reloadData()
    }

    private func createLayout() -> UICollectionViewCompositionalLayout {
        // none zero items size
        let regularItem = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.25),
                                                                                     heightDimension: .fractionalHeight(1.0)))

        // zero item size
        let zeroItem = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5),
                                                                                  heightDimension: .fractionalHeight(1.0)))
        var rows: [NSCollectionLayoutGroup] = []
        for _ in 0..<4 {
            let row = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                                                           heightDimension: .absolute(90)),
                                                        subitems: [regularItem, regularItem, regularItem, regularItem])
            row.interItemSpacing = .fixed(5) // Horizontal spacing between none zero items row
            rows.append(row)
        }

        // Create the 5th row (with "0" item includes 2 columns)
        let row5 = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                                                         heightDimension: .absolute(90)),
                                                      subitems: [zeroItem, regularItem, regularItem]) // "0" spans two columns
        row5.interItemSpacing = .fixed(5) // Horizontal spacing between items in the same row
        rows.append(row5)

        // Combine all rows into a vertical stack (a single group)
        let fullGroup = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                                                          heightDimension: .estimated(500)),
                                                         subitems: rows)

        fullGroup.interItemSpacing = .fixed(5)

        let section = NSCollectionLayoutSection(group: fullGroup)
        section.interGroupSpacing = 5 // Vertical spacing between rows
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }

}

// MARK: - CollectionView functions
extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.items.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CalculatorCollectionViewCell", for: indexPath) as! CalculatorCollectionViewCell
        let item = viewModel?.items[indexPath.item]
        guard let title = item?.title, let color = item?.backgroundColor else { return cell }
        cell.setup(config: CalculatorCollectionViewCell.Config(title: title, backgroundColor: color))
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let item = viewModel?.items[indexPath.item] else { return }
        viewModel?.handleButtonPress(item: item)
        textField.text = viewModel?.textFieldText
    }
}
