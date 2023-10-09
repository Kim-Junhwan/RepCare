//
//  RegisterPetView.swift
//  RepCare
//
//  Created by JunHwan Kim on 2023/10/05.
//

import UIKit

protocol RegisterPetViewDelegate: AnyObject {
    func setDateTime() -> Date 
}

class RegisterPetView: UIView {
    
    let datePicker: UIDatePicker = {
       let datePicker = UIDatePicker()
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.locale = .init(identifier: "ko-KR")
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .inline
        return datePicker
    }()
    
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
    
    lazy var genderView: RegisterInputView = {
        let view = RegisterInputView(isButton: true, isEssential: true)
        view.actionButton.isHidden = true
        view.mainStackView.addArrangedSubview(genderStackView)
        view.descriptionLabel.text = "성별"
        genderStackView.snp.makeConstraints { make in
            make.width.equalToSuperview()
        }
        return view
    }()
    
    lazy var genderStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    lazy var genderButtonList: [UIButton] = [femaleButton, maleButton, dontKnowButton]
    
    let femaleButton: ActionButton = {
       let button = ActionButton()
        button.setTitle("암컷", for: .normal)
        return button
    }()
    
    let maleButton: ActionButton = {
       let button = ActionButton()
        button.setTitle("수컷", for: .normal)
        return button
    }()
    
    let dontKnowButton: ActionButton = {
       let button = ActionButton()
        button.setTitle("미구분", for: .normal)
        return button
    }()
    
    lazy var dateButton: RegisterInputView = {
        let view = RegisterInputView(isButton: false, isEssential: true)
         view.descriptionLabel.text = "입양일"
        view.textField.inputView = datePicker
         return view
     }()
    
    lazy var birthDayButton: RegisterInputView = {
        let view = RegisterInputView(isButton: false, isEssential: false)
         view.descriptionLabel.text = "해칭일"
        view.textField.inputView = datePicker
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
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapView)))
        genderStackView.addArrangedSubview(femaleButton)
        genderStackView.addArrangedSubview(maleButton)
        genderStackView.addArrangedSubview(dontKnowButton)
        for item in [nameTextField, speciesClassButton, genderView, dateButton, birthDayButton, weightTextField] {
            mainStakView.addArrangedSubview(item)
        }
        
        for i in genderButtonList {
            i.addTarget(self, action: #selector(tapGenderButton), for: .touchUpInside)
        }
    }
    
    @objc func tapGenderButton(_ sender: UIButton) {
        genderButtonList.forEach { $0.isSelected = false }
        sender.isSelected = true
    }
    
    private func setConstraints() {
        imageCollectionView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(safeAreaLayoutGuide).inset(10)
            make.height.equalTo(100)
        }
        mainStakView.snp.makeConstraints { make in
            make.top.equalTo(imageCollectionView.snp.bottom)
            make.leading.trailing.equalTo(safeAreaLayoutGuide)
        }
    }
    
    @objc private func tapView() {
        endEditing(false)
    }

}
