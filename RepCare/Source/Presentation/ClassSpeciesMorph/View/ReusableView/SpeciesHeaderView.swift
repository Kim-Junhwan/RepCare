//
//  SpeciesHeaderView.swift
//  RepCare
//
//  Created by JunHwan Kim on 2023/10/06.
//

import UIKit

final class SpeciesHeaderView: UICollectionReusableView {
    
    static let identifider = "SpeciesHeaderView"
    
    lazy var labelStackView: UIStackView = {
       let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 5
        stackView.addArrangedSubview(descriptionLabel)
        stackView.addArrangedSubview(titleLabel)
        return stackView
    }()
    
    let titleLabel = UILabel()
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .italicSystemFont(ofSize: 14)
        label.textColor = .systemGray3
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        descriptionLabel.isHidden = true
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureView() {
        addSubview(labelStackView)
        labelStackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(10)
            make.bottom.equalToSuperview().offset(-10)
        }
    }
}
