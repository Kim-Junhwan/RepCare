//
//  PetCollectionViewCell.swift
//  RepCare
//
//  Created by JunHwan Kim on 2023/10/02.
//

import UIKit

class PetCollectionViewCell: UICollectionViewCell {
    let petImageView: UIImageView = {
       let imageView = UIImageView()
        return imageView
    }()
    
    let petNameStackView: UIStackView = {
       let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        return stackView
    }()
    
    let sexImageView: UIImageView = {
        let imageView = UIImageView()
         return imageView
     }()
    
    let nameLabel: UILabel = {
       let label = UILabel()
        return label
    }()
    
    let speciesLabel: UILabel = {
        let label = UILabel()
         return label
    }()
    
    let morphLabel: UILabel = {
       let label = UILabel()
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
        setConstraints()
        petImageView.image = UIImage(systemName: "heart")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureView() {
        contentView.addSubview(petImageView)
        petNameStackView.addArrangedSubview(nameLabel)
        petNameStackView.addArrangedSubview(sexImageView)
    }
    
    private func setConstraints() {
        backgroundColor = .systemGray5
        layer.cornerRadius = 10.0
        clipsToBounds = true
        petImageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(petImageView.snp.width).multipliedBy(1.0)
        }
//        petNameStackView.snp.makeConstraints { make in
//            make.top.equalTo(petImageView).offset(10)
//            make.leading.equalTo(snp.leading).offset(10)
//            
//        }
    }
}
