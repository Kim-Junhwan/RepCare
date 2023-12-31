//
//  RegisterPetView.swift
//  RepCare
//
//  Created by JunHwan Kim on 2023/10/05.
//

import UIKit

struct PetImageItem: Hashable {
    enum ImageType {
        case cameraImage
        case galleryImage
    }
    let image: UIImage
    let imageType: ImageType
    let id: String
}

enum ImageCollectionViewSection {
    case main
}

class RegisterPetView: UIView {
    
    let imageLabel: UILabel = {
       let label = UILabel()
        label.text = "개체 사진"
        label.font = .boldSystemFont(ofSize: 17)
        return label
    }()
    lazy var imageCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: makePetImageCollectionViewFlowLayout())
        collectionView.register(RegisterImageCollectionViewCell.self, forCellWithReuseIdentifier: RegisterImageCollectionViewCell.identifier)
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    let mainStakView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.alignment = .fill
        stackView.spacing = 10
        return stackView
    }()
    
    let nameTextField: RegisterInputView = {
        let view = RegisterInputView(inputView: .textField, isEssential: true)
        view.descriptionLabel.text = "개체 이름"
        return view
    }()
    
    let speciesClassButton: RegisterInputView = {
        let view = RegisterInputView(inputView: .button, isEssential: true)
        view.descriptionLabel.text = "종/모프"
         return view
     }()
    
    lazy var genderView: RegisterInputView = {
        let view = RegisterInputView(inputView: .button, isEssential: true)
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
        stackView.spacing = 5
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
    
    lazy var adoptionDateButton: RegisterInputView = {
        let view = RegisterInputView(inputView: .datePicker, isEssential: true)
         view.descriptionLabel.text = "입양일"
        view.actionButton = DatePickerButton()
         return view
     }()
    
    lazy var birthDayButton: RegisterInputView = {
        let view = RegisterInputView(inputView: .datePicker, isEssential: false)
         view.descriptionLabel.text = "해칭일"
        view.actionButton = DatePickerButton()
         return view
     }()
    
    let weightTextField: RegisterInputView = {
        let view = RegisterInputView(inputView: .textField, isEssential: false)
         view.descriptionLabel.text = "현재무게 (g)"
        view.textField.keyboardType = .decimalPad
         return view
     }()
    
    var dataSource: UICollectionViewDiffableDataSource<ImageCollectionViewSection, PetImageItem>?
    
    
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
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 90, height: 90)
        layout.minimumInteritemSpacing = 10.0
        return layout
    }
    
    func configureView() {
        addSubview(imageLabel)
        addSubview(imageCollectionView)
        addSubview(mainStakView)
        genderStackView.addArrangedSubview(femaleButton)
        genderStackView.addArrangedSubview(maleButton)
        genderStackView.addArrangedSubview(dontKnowButton)
        for item in [nameTextField, speciesClassButton, genderView, adoptionDateButton, birthDayButton, weightTextField] {
            mainStakView.addArrangedSubview(item)
        }
        
        for num in 0..<genderButtonList.count {
            let button = genderButtonList[num]
            button.tag = num
            button.addTarget(self, action: #selector(tapGenderButton), for: .touchUpInside)
        }
    }
    
    @objc func tapGenderButton(_ sender: UIButton) {
        genderButtonList.forEach { $0.isSelected = false }
        sender.isSelected = true
    }
    
    private func setConstraints() {
        imageLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(10)
            make.leading.trailing.equalTo(safeAreaLayoutGuide)
        }
        imageCollectionView.snp.makeConstraints { make in
            make.top.equalTo(imageLabel.snp.bottom)
            make.leading.trailing.equalTo(safeAreaLayoutGuide)
            make.height.equalTo(100)
        }
        mainStakView.snp.makeConstraints { make in
            make.top.equalTo(imageCollectionView.snp.bottom)
            make.leading.trailing.equalTo(safeAreaLayoutGuide)
            make.bottom.lessThanOrEqualTo(safeAreaLayoutGuide)
        }
    }
    
    @objc private func tapView() {
        endEditing(false)
    }
    
    func setDatePickerButton(viewController: UIViewController) {
        adoptionDateButton.datePickerButton.viewController = viewController
        birthDayButton.datePickerButton.viewController = viewController
    }
    
    func updateImage(images: [PetImageItem]) {
        var snapshot = NSDiffableDataSourceSnapshot<ImageCollectionViewSection,PetImageItem>()
        snapshot.appendSections([.main])
        var fetchImages = images
        let registerCell = PetImageItem(image: .init(), imageType: .cameraImage, id: UUID().uuidString)
        fetchImages.insert(registerCell, at: 0)
        snapshot.appendItems(fetchImages)
        dataSource?.apply(snapshot)
    }

    deinit {
        print("deinit RegisterPetView")
    }
}
