//
//  WeightCollectionViewCell.swift
//  RepCare
//
//  Created by JunHwan Kim on 2023/10/16.
//

import UIKit

class WeightCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "WeightCollectionViewCell"
    
    lazy var allStackView: UIStackView = {
        let stackView = UIStackView()
         stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.alignment = .center
        stackView.distribution = .fill
         stackView.addArrangedSubview(weightstackView)
        stackView.addArrangedSubview(deleteButton)
        stackView.addArrangedSubview(spacingView)
         return stackView
    }()
    
    lazy var weightstackView: UIStackView = {
       let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.addArrangedSubview(dateLabel)
        stackView.addArrangedSubview(weightLabel)
        stackView.addArrangedSubview(changeWeightLabel)
        return stackView
    }()
    
    let deleteButton: UIButton = {
        var config = UIButton.Configuration.filled()
        var imageConfig = UIImage.SymbolConfiguration(pointSize: 10, weight: .light)
        config.image = UIImage(systemName: "xmark", withConfiguration: imageConfig)
        config.baseForegroundColor = .white
        config.baseBackgroundColor = .black
        let button = UIButton(configuration: config)
        button.clipsToBounds = true
        return button
    }()
    
    let spacingView: UIView = UIView(frame: .init(origin: .zero, size: .init(width: 30, height: 30)))
    
    let dateLabel: UILabel = .init()
    let weightLabel: UILabel = .init()
    let changeWeightLabel: UILabel = .init()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setConstriants()
        contentView.addSubview(allStackView)
        dateLabel.textAlignment = .center
        weightLabel.textAlignment = .center
        changeWeightLabel.textAlignment = .center
        allStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        spacingView.isHidden = true
    }
    
    private func setConstriants() {
        deleteButton.snp.makeConstraints { make in
            make.height.width.equalTo(30)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell(date: Date, weight: Double, change: Double) {
        dateLabel.text = DateFormatter.yearMonthDateFormatter.string(from: date)
        weightLabel.text = "\(weight)"
        changeWeightLabel.text = String(format: "%.2f", change)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        deleteButton.layer.cornerRadius = 15
    }
    
}
