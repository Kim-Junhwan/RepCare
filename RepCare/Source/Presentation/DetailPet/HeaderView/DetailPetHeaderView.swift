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
    let nameLabel: UILabel = UILabel()
    let genderImageView: UIImageView = .init()
    let adoptionLabel: UILabel = UILabel()
    
    lazy var speciesStackView: UIStackView = {
        let stackView = UIStackView()
         stackView.addArrangedSubview(speciesLabel)
         stackView.addArrangedSubview(morphLabel)
         stackView.axis = .horizontal
         stackView.spacing = 5
         return stackView
     }()
    let speciesLabel: UILabel = UILabel()
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
        nameLabel.text = "이름"
        adoptionLabel.text = "입양한지 100일째"
        speciesLabel.text = "고양이"
        morphLabel.text = "치즈냥이"
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
            make.top.equalTo(imagePageViewController.view.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
        onStackView.snp.makeConstraints { make in
            make.width.equalToSuperview()
        }
        genderImageView.snp.makeConstraints { make in
            make.height.equalToSuperview()
            make.width.equalTo(genderImageView.snp.height).multipliedBy(1.0)
        }
    }
}
