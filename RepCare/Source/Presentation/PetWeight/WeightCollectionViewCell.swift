//
//  WeightCollectionViewCell.swift
//  RepCare
//
//  Created by JunHwan Kim on 2023/10/16.
//

import UIKit

class WeightCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "WeightCollectionViewCell"
    
    lazy var stackView: UIStackView = {
       let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.addArrangedSubview(dateLabel)
        stackView.addArrangedSubview(weightLabel)
        stackView.addArrangedSubview(changeWeightLabel)
        return stackView
    }()
    let dateLabel: UILabel = .init()
    let weightLabel: UILabel = .init()
    let changeWeightLabel: UILabel = .init()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(stackView)
        dateLabel.textAlignment = .center
        weightLabel.textAlignment = .center
        changeWeightLabel.textAlignment = .center
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell(date: Date, weight: Double, change: Double) {
        dateLabel.text = date.description
        weightLabel.text = "\(weight)"
        changeWeightLabel.text = "\(change)"
    }
    
}
