//
//  PetTableCollectionViewCell.swift
//  RepCare
//
//  Created by JunHwan Kim on 2024/03/29.
//

import UIKit

class TablePetCollectionViewCell: UICollectionViewCell {
    static let identifier = "TablePetCollectionViewCell"
    
    let basePetImageView: UIView = {
       let view = UIView()
        view.backgroundColor = .systemGray5
        return view
    }()
    
    let petImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.tintColor = .systemGray3
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    lazy var descriptionStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .equalSpacing
        stackView.addArrangedSubview(petNameStackView)
        stackView.addArrangedSubview(adoptionDateLabel)
        stackView.addArrangedSubview(morphStackView)
        return stackView
    }()
    
    let petNameStackView: UIStackView = {
       let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 5
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
         stackView.axis = .horizontal
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
    
    let adoptionDateLabel: UILabel = {
       let label = UILabel()
        label.textColor = .systemGray
        label.font = .systemFont(ofSize: 14, weight: .semibold)
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
    }
    
    private func setConstraints() {
        backgroundColor = .brightLightGreen
        layer.cornerRadius = 10.0
        clipsToBounds = true
        basePetImageView.snp.makeConstraints { make in
            make.top.bottom.leading.equalToSuperview()
            make.width.equalTo(basePetImageView.snp.height).multipliedBy(1.0)
        }
        petImageView.snp.makeConstraints { make in
            make.width.height.equalTo(basePetImageView.snp.width)
            make.center.equalToSuperview()
        }
        sexImageView.snp.makeConstraints { make in
            make.height.width.equalTo(20)
        }
        descriptionStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.bottom.trailing.equalToSuperview().offset(-10)
            make.leading.equalTo(basePetImageView.snp.trailing).offset(10)
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
        let adoptionDate = DateFormatter.yearMonthDateFormatter.string(from: pet.adoptionDate)
        adoptionDateLabel.text = "입양일: \(adoptionDate)"
        if pet.imagePath.isEmpty {
            whenPetImageCannotRender(petClass: pet.overSpecies.petClass ?? .reptile)
        } else {
            guard let imagePath = pet.imagePath.first?.imagePath else { return }
            do {
                try petImageView.configureImageFromFilePath(path: imagePath)
            } catch {
                whenPetImageCannotRender(petClass: pet.overSpecies.petClass ?? .reptile)
            }
        }
        setPetSpeciesLabel(species: pet.overSpecies)
    }
    
    private func setPetSpeciesLabel(species: PetOverSpeciesModel) {
        var speciesArr: [String?] = []
        speciesArr.append(species.petClass?.title)
        speciesArr.append(species.petSpecies?.title)
        speciesArr.append(species.detailSpecies?.title)
        speciesArr.append(species.morph?.title)
        speciesLabel.text = speciesArr.compactMap({ $0 }).joined(separator: " · ")
    }
}
