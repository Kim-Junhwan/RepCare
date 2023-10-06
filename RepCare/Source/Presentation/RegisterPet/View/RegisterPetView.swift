//
//  RegisterPetView.swift
//  RepCare
//
//  Created by JunHwan Kim on 2023/10/05.
//

import UIKit

class RegisterPetView: UIView {
    
    let imageCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: .init())
        collectionView.backgroundColor = .red
        return collectionView
    }()
    
    let mainStakView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.alignment = .fill
        stackView.spacing = 10
        return stackView
    }()
    
    let nameTextField: RegisterInputView = {
       let view = RegisterInputView(isButton: false, isEssential: true)
        view.descriptionLabel.text = "개체 이름"
        return view
    }()
    
    let speciesClassButton: RegisterInputView = {
        let view = RegisterInputView(isButton: true, isEssential: true)
        view.descriptionLabel.text = "종/모프"
         return view
     }()
    
    let genderStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.backgroundColor = .green
        return stackView
    }()
    
    let femaleButton: UIButton = {
       let button = UIButton()
        button.setTitle("암컷", for: .normal)
        return button
    }()
    
    let maleButton: UIButton = {
       let button = UIButton()
        button.setTitle("수컷", for: .normal)
        return button
    }()
    
    let dontKnowButton: UIButton = {
       let button = UIButton()
        button.setTitle("미구분", for: .normal)
        return button
    }()
    
    let dateButton: RegisterInputView = {
        let view = RegisterInputView(isButton: true, isEssential: true)
         view.descriptionLabel.text = "입양일"
         return view
     }()
    
    let birthDayButton: RegisterInputView = {
        let view = RegisterInputView(isButton: true, isEssential: false)
         view.descriptionLabel.text = "해칭일"
         return view
     }()
    
    let weightTextField: RegisterInputView = {
        let view = RegisterInputView(isButton: false, isEssential: false)
         view.descriptionLabel.text = "현재무게"
         return view
     }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func makePetImageCollectionViewFlowLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 100.0, height: 100.0)
        layout.minimumInteritemSpacing = 10.0
        return layout
    }
    
    func configureView() {
        addSubview(imageCollectionView)
        addSubview(mainStakView)
        genderStackView.addArrangedSubview(femaleButton)
        genderStackView.addArrangedSubview(maleButton)
        genderStackView.addArrangedSubview(dontKnowButton)
        for item in [nameTextField, speciesClassButton, genderStackView, dateButton, birthDayButton, weightTextField] {
            mainStakView.addArrangedSubview(item)
        }
    }
    
    func setConstraints() {
        imageCollectionView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(safeAreaLayoutGuide).inset(10)
            make.height.equalTo(100)
        }
        mainStakView.snp.makeConstraints { make in
            make.top.equalTo(imageCollectionView.snp.bottom)
            make.leading.trailing.equalTo(safeAreaLayoutGuide)
        }
    }
    
    

}
