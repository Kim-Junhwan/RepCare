//
//  SpeciesHeaderView.swift
//  RepCare
//
//  Created by JunHwan Kim on 2023/10/06.
//

import UIKit

final class SpeciesHeaderView: UICollectionReusableView {
    
    static let identifider = "SpeciesHeaderView"
    
    let titleLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureView() {
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(10)
            make.bottom.equalToSuperview().offset(-10)
            make.top.equalToSuperview().offset(30)
        }
    }
}
