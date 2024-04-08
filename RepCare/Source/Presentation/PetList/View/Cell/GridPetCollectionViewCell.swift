//
//  PetCollectionViewCell.swift
//  RepCare
//
//  Created by JunHwan Kim on 2023/10/02.
//

import UIKit

class GridPetCollectionViewCell: PetListCell {
    
    static let identifier = "GridPetCollectionViewCell"
    
    let basePetImageView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray5
        return view
    }()
    
    lazy var descriptionStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fill
        stackView.spacing = 10
        stackView.addArrangedSubview(petNameStackView)
        stackView.addArrangedSubview(morphStackView)
        return stackView
    }()
    
    let petNameStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.alignment = .center
        return stackView
    }()
    
    let sexImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .heavy)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    let morphStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .leading
        stackView.spacing = 5
        return stackView
    }()
    
    let speciesLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.8
        return label
    }()
    
    let morphLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.8
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
        petModel = nil
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
    
    override func whenPetImageCannotRender(petClass: PetClassModel) {
        petImageView.image = UIImage(named: petClass.image)?.withRenderingMode(.alwaysTemplate)
        petImageView.snp.remakeConstraints { make in  make.width.height.equalTo(basePetImageView.snp.width).multipliedBy(0.5)
            make.center.equalToSuperview()
        }
    }
    
    func configureCell(pet: PetModel) {
        petModel = pet
        nameLabel.text = pet.name
        sexImageView.image = UIImage(named: pet.sex.image)
        if pet.imagePath.isEmpty {
            whenPetImageCannotRender(petClass: pet.overSpecies.petClass ?? .reptile)
        }
        if let morph = pet.overSpecies.morph {
            speciesLabel.text = pet.overSpecies.detailSpecies?.title
            morphLabel.text = morph.title
        } else if let detailSpecies = pet.overSpecies.detailSpecies?.title {
            speciesLabel.text = pet.overSpecies.petSpecies?.title
            morphLabel.text = detailSpecies
        } else {
            speciesLabel.text = pet.overSpecies.petClass?.title
            morphLabel.text = pet.overSpecies.petSpecies?.title
        }
    }
}
