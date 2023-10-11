//
//  RegisterImageCollectionViewCell.swift
//  RepCare
//
//  Created by JunHwan Kim on 2023/10/11.
//

import UIKit

class RegisterImageCollectionViewCell: UICollectionViewCell {
    static let identifier = "RegisterImageCollectionViewCell"
    let plusImageView: UIImageView = UIImageView(image: .init(systemName: "plus"))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureView() {
        layer.borderWidth = 1.0
        layer.borderColor = UIColor.black.cgColor
        contentView.addSubview(plusImageView)
        plusImageView.snp.makeConstraints { make in
            make.width.height.equalTo(50)
            make.center.equalToSuperview()
        }
    }
}
