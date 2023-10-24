//
//  RegisterCollectionViewCell.swift
//  RepCare
//
//  Created by JunHwan Kim on 2023/10/08.
//

import UIKit

class RegisterCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "RegisterCollectionViewCell"
    
    let plusImageView: UIImageView = {
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 13, weight: .medium)
        let imageView = UIImageView(image: .init(systemName: "plus", withConfiguration: imageConfig))
        imageView.tintColor = .systemGray2
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureView() {
        layer.borderWidth = 1.0
        layer.borderColor = UIColor.systemGray2.cgColor
        contentView.addSubview(plusImageView)
        plusImageView.snp.makeConstraints { make in
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
