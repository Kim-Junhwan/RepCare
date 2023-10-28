//
//  PetCollectionViewCell.swift
//  RepCare
//
//  Created by JunHwan Kim on 2023/10/02.
//

import UIKit

class PetCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "PetCollectionViewCell"
    
    let basePetImageView: UIView = {
       let view = UIView()
        view.backgroundColor = .systemGray5
        return view
    }()
    
    let petImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.tintColor = .systemGray3
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    lazy var descriptionStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .equalSpacing
        stackView.spacing = 10
        stackView.addArrangedSubview(petNameStackView)
        stackView.addArrangedSubview(morphStackView)
        return stackView
    }()
    
    let petNameStackView: UIStackView = {
       let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.distribution = .fill
        return stackView
    }()
    
    let sexImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
         return imageView
     }()
    
    let nameLabel: UILabel = {
       let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    let morphStackView: UIStackView = {
        let stackView = UIStackView()
         stackView.axis = .horizontal
         stackView.distribution = .fill
        stackView.alignment = .leading
        stackView.spacing = 5
         return stackView
     }()
    
    let speciesLabel: UILabel = {
        let label = UILabel()
        label.adjustsFontSizeToFitWidth = true
         return label
    }()
    
    let boundaryLabel: UILabel = {
        let label = UILabel()
        label.text = "|"
        return label
    }()
    
    let morphLabel: UILabel = {
       let label = UILabel()
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        petImageView.image = nil
        nameLabel.text = nil
        speciesLabel.text = nil
        morphLabel.text = nil
        petImageView.snp.remakeConstraints { make in  make.width.height.equalTo(basePetImageView.snp.width)
            make.center.equalToSuperview()
        }
    }
    
    private func configureView() {
        contentView.addSubview(basePetImageView)
        basePetImageView.addSubview(petImageView)
        contentView.addSubview(descriptionStackView)
        petNameStackView.addArrangedSubview(nameLabel)
        petNameStackView.addArrangedSubview(sexImageView)
        morphStackView.addArrangedSubview(speciesLabel)
        morphStackView.addArrangedSubview(boundaryLabel)
        morphStackView.addArrangedSubview(morphLabel)
    }
    
    private func setConstraints() {
        backgroundColor = .brightLightGreen
        layer.cornerRadius = 10.0
        clipsToBounds = true
        basePetImageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(basePetImageView.snp.width).multipliedBy(1.0)
        }
        petImageView.snp.makeConstraints { make in
            make.width.height.equalTo(basePetImageView.snp.width)
            make.center.equalToSuperview()
        }
        sexImageView.snp.makeConstraints { make in
            make.height.width.equalTo(snp.width).multipliedBy(0.1)
        }
        descriptionStackView.snp.makeConstraints { make in
            make.top.equalTo(basePetImageView.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(10)
        }
        petNameStackView.snp.makeConstraints { make in
            make.width.equalToSuperview()
        }
    }
    
    private func whenPetImageCannotRender(petClass: PetClassModel) {
        petImageView.image = UIImage(named: petClass.image)?.withRenderingMode(.alwaysTemplate)
        petImageView.snp.remakeConstraints { make in  make.width.height.equalTo(basePetImageView.snp.width).multipliedBy(0.5)
            make.center.equalToSuperview()
        }
    }
    
    func configureCell(pet: PetModel) {
        nameLabel.text = pet.name
        sexImageView.image = UIImage(named: pet.sex.image)
        if pet.imagePath.isEmpty {
            whenPetImageCannotRender(petClass: pet.overSpecies.petClass)
        } else {
            guard let imagePath = pet.imagePath.first?.imagePath else { return }
            do {
                try petImageView.configureImageFromFilePath(path: imagePath)
            } catch {
                whenPetImageCannotRender(petClass: pet.overSpecies.petClass)
            }
        }
        if let morph = pet.overSpecies.morph {
            speciesLabel.text = pet.overSpecies.detailSpecies?.title
            morphLabel.text = morph.title
        } else if let detailSpecies = pet.overSpecies.detailSpecies?.title {
            speciesLabel.text = pet.overSpecies.petSpecies.title
            morphLabel.text = detailSpecies
        } else {
            speciesLabel.text = pet.overSpecies.petClass.title
            morphLabel.text = pet.overSpecies.petSpecies.title
        }
    }
    
}
