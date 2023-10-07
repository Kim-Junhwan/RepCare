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
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureCell() {
        layer.borderWidth = 1
        layer.borderColor = UIColor.black.cgColor
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.edges.equalToSuperview().inset(10)
        }
    }
}
