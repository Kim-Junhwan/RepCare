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
        let imageView = UIImageView(image: .init(systemName: "plus"))
        
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
        layer.borderWidth = 1
        layer.borderColor = UIColor.black.cgColor
        contentView.addSubview(plusImageView)
        plusImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.edges.equalToSuperview().inset(10)
        }
    }
    
}
