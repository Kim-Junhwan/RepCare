//
//  SpeciesCell.swift
//  RepCare
//
//  Created by JunHwan Kim on 2023/10/06.
//

import UIKit

final class SpeciesCell: UICollectionViewCell {
    
    let titleLabel: UILabel = {
       let label = UILabel()
        label.font = .systemFont(ofSize: 13.0)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var isSelected: Bool {
        didSet {
            backgroundColor = isSelected ? .opacityGreen : .white
            titleLabel.textColor = isSelected ? .deepGreen : .black
            layer.borderColor = isSelected ? UIColor.deepGreen.cgColor : UIColor.systemGray2.cgColor
        }
    }
    
    private func configureCell() {
        layer.borderWidth = 1.0
        layer.borderColor = UIColor.systemGray2.cgColor
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.top.bottom.equalToSuperview().inset(8)
            make.leading.trailing.equalToSuperview().inset(20)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.height/2
    }
}
