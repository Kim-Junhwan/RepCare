//
//  DetailPetHeaderView.swift
//  RepCare
//
//  Created by JunHwan Kim on 2023/10/14.
//

import UIKit

class DetailPetHeaderView: UIView {

    lazy var imagePageViewController: UIPageViewController = {
        let pageView = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
        return pageView
    }()
    
    let pageControl: UIPageControl = UIPageControl()
    
    lazy var onStackView: UIStackView = {
        let stackView = UIStackView()
         stackView.addArrangedSubview(nameStackView)
        stackView.addArrangedSubview(adoptionLabel)
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
         return stackView
     }()
    
    lazy var nameStackView: UIStackView = {
       let stackView = UIStackView()
        stackView.addArrangedSubview(nameLabel)
        stackView.addArrangedSubview(genderImageView)
        stackView.axis = .horizontal
        stackView.spacing = 5
        return stackView
    }()
    let nameLabel:UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 25)
        return label
    }()
    let genderImageView: UIImageView = .init()
    let adoptionLabel: UILabel = UILabel()
    
    lazy var speciesStackView: UIStackView = {
        let stackView = UIStackView()
         stackView.addArrangedSubview(speciesLabel)
        stackView.addArrangedSubview(separLabel)
         stackView.addArrangedSubview(morphLabel)
         stackView.axis = .horizontal
         stackView.spacing = 5
         return stackView
     }()
    let speciesLabel: UILabel = UILabel()
    let separLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightDeepGreen
        label.text = "·"
        return label
    }()
    let morphLabel: UILabel = UILabel()
    
    lazy var petInfoStackView: UIStackView = {
        let stackView = UIStackView()
         stackView.addArrangedSubview(onStackView)
         stackView.addArrangedSubview(speciesStackView)
         stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fillEqually
         stackView.spacing = 5
         return stackView
     }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureView() {
        addSubview(imagePageViewController.view)
        addSubview(pageControl)
        addSubview(petInfoStackView)
    }
    
    private func setConstraints() {
        imagePageViewController.view.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.8)
        }
        pageControl.snp.makeConstraints { make in
            make.centerX.equalTo(imagePageViewController.view.snp.centerX)
            make.bottom.equalTo(imagePageViewController.view.snp.bottom)
        }
        petInfoStackView.snp.makeConstraints { make in
            make.top.equalTo(imagePageViewController.view.snp.bottom).offset(10)
            make.leading.trailing.bottom.equalToSuperview().inset(10)
        }
        onStackView.snp.makeConstraints { make in
            make.width.equalToSuperview()
        }
        genderImageView.snp.makeConstraints { make in
            make.height.equalToSuperview()
            make.width.equalTo(genderImageView.snp.height).multipliedBy(1.0)
        }
        speciesLabel.textColor = .deepGreen
        morphLabel.textColor = .deepGreen
    }
    
    func setPetInfo(pet: PetModel) {
        nameLabel.text = pet.name
        genderImageView.image = UIImage(named: pet.sex.image)
        guard let difference = Calendar.current.dateComponents([.day], from: Date(), to: pet.adoptionDate).day else { return }
        adoptionLabel.text = "입양한지 \(abs(difference))일째"
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
