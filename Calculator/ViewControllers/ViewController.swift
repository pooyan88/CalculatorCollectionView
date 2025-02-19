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
        collectionView.delegate = self
        collectionView.dataSource = self
    }

    private func reloadCollectionView() {
        collectionView.reloadData()
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

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CalculatorCollectionViewCell.getSize(itemsInARow: 4, item: viewModel!.items[indexPath.row])
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        5
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        4
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let item = viewModel?.items[indexPath.item] else { return }
        viewModel?.handleButtonPress(item: item)
        textField.text = viewModel?.textFieldText
    }
}
