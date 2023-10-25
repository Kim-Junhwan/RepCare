//
//  RegisterNewPetViewController.swift
//  RepCare
//
//  Created by JunHwan Kim on 2023/10/04.
//

import UIKit
import RxSwift
import RxCocoa
import PhotosUI

class RegisterNewPetViewController: BaseViewController {
    
    let mainView = RegisterPetView()
    let viewModel: RegisterPetViewModel = .init()
    let disposeBag = DisposeBag()
    
    lazy var registerButton: UIBarButtonItem = {
        let barButton = UIBarButtonItem(title: "등록", style: .plain, target: self, action: #selector(tapRegisterButton))
        return barButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureDatasource()
        bind()
        mainView.imageCollectionView.delegate = self
    }
    
    private func bind() {
        bindImage()
        bindRegisterButton()
        bindName()
        bindSpecies()
        bindGender()
        bindAdoptionDate()
        bindBirthDate()
        bindWeight()
    }
    
    private func bindImage() {
        viewModel.petImageList.subscribe(with: self) { owner, imageList in
            owner.mainView.updateImage(images: imageList)
        }.disposed(by: disposeBag)
    }
    
    private func bindRegisterButton() {
        viewModel.canRegister.subscribe(with: self) { $0.registerButton.isEnabled = $1 }.disposed(by: disposeBag)
    }
    
    private func bindName() {
        mainView.nameTextField.textField.rx.text.orEmpty.subscribe(with: self) { owner, input in
            owner.viewModel.petName.accept(input)
        }.disposed(by: disposeBag)
    }
    
    private func bindSpecies() {
        viewModel.overPetSpecies.compactMap { $0 }.subscribe(with: self) { owner, currentSpecies in
            var speciesArr: [String] = []
            speciesArr.append(currentSpecies.petClass.title)
            speciesArr.append(currentSpecies.petSpecies.title)
            if let detailSpecies = currentSpecies.detailSpecies?.title {
                speciesArr.append(detailSpecies)
            }
            if let morph = currentSpecies.morph?.title {
                speciesArr.append(morph)
            }
            
            owner.mainView.speciesClassButton.actionButton.setTitle("\(speciesArr.joined(separator: " > "))", for: .normal)
        }.disposed(by: disposeBag)
    }
    
    private func bindGender() {
        mainView.genderButtonList.forEach { button in
            guard let gender = GenderModel(rawValue: button.tag) else {  return }
            button.rx.tap.bind { [weak self] in self?.viewModel.gender.accept(gender) }.disposed(by: disposeBag)
        }
    }
    
    private func bindAdoptionDate() {
        viewModel.adoptionDate.subscribe(with: self) { owner, adopDate in
            guard let adopDate else { return }
            owner.mainView.adoptionDateButton.datePickerButton.setTitle(DateFormatter.yearMonthDateFormatter.string(from: adopDate), for: .normal) }.disposed(by: disposeBag)
    }
    
    private func bindBirthDate() {
        viewModel.hatchDate.subscribe(with: self) { owner, date in
            guard let birthDate = date else { return }
            owner.mainView.birthDayButton.datePickerButton.setTitle(DateFormatter.yearMonthDateFormatter.string(from: birthDate), for: .normal) }.disposed(by: disposeBag)
    }
    
    private func bindWeight() {
        mainView.weightTextField.textField.rx.text.orEmpty.subscribe(with: self) { owner, fetchWeight in
            owner.viewModel.currentWeight.accept(Double(fetchWeight))
        }.disposed(by: disposeBag)
    }
    
    override func configureView() {
        title = "개체 등록"
        view.addSubview(mainView)
        registerButton.isEnabled = false
        navigationItem.setRightBarButton(registerButton, animated: false)
        mainView.setDatePickerButton(viewController: self)
        mainView.speciesClassButton.actionButton.addTarget(self, action: #selector(showSpeciesView), for: .touchUpInside)
        mainView.adoptionDateButton.datePickerButton.actionClosure = { [weak self] selectDate in
            self?.viewModel.adoptionDate.accept(selectDate)
        }
        mainView.birthDayButton.datePickerButton.actionClosure = { [weak self] selectDate in
            self?.viewModel.hatchDate.accept(selectDate)
        }
    }
    
    func configureDatasource() {
        let imageCellRegistration = UICollectionView.CellRegistration<ImageCollectionViewCell, PetImageItem> { cell, indexPath, itemIdentifier in
            cell.configureCell(petImage: itemIdentifier)
            cell.deleteButton.identifier = self.viewModel.petImageList.value[indexPath.row-1].id
            cell.deleteButton.addTarget(self, action: #selector(self.deleteImage(_:)), for: .touchUpInside)
        }
        
        mainView.dataSource = UICollectionViewDiffableDataSource<ImageCollectionViewSection, PetImageItem>(collectionView: mainView.imageCollectionView, cellProvider: { [weak self] collectionView, indexPath, itemIdentifier in
            guard let self else { return .init() }
            if indexPath.row == 0 {
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RegisterImageCollectionViewCell.identifier, for: indexPath) as? RegisterImageCollectionViewCell else { return .init() }
                cell.configureCell(imageCount: viewModel.petImageList.value.count)
                return cell
            }
            return collectionView.dequeueConfiguredReusableCell(using: imageCellRegistration, for: indexPath, item: itemIdentifier)
        })
    }
    
    override func setContraints() {
        mainView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(10)
        }
    }
    
    @objc func tapRegisterButton() {
        
        do {
            try self.viewModel.register()
        } catch {
            showErrorAlert(title: "저장 에러", message: error.localizedDescription)
        }
        navigationController?.popViewController(animated: true)
    }
    
    @objc func deleteImage(_ sender: DeleteButton) {
        var imageList = viewModel.petImageList.value
        viewModel.petImageList.accept(imageList.filter { $0.id != sender.identifier })
    }
    
    @objc func showSpeciesView() {
        let speciesViewModel = ClassSpeciesMorphViewModel(repository: DefaultSpeciesRepository(speciesStroage: RealmSpeciesStorage()))
        let vc = ClassSpeciesMorphViewController(viewModel: speciesViewModel)
        speciesViewModel.tapRegisterClosure = { [weak self] in self?.viewModel.overPetSpecies.accept($0) }
        let nvc = UINavigationController(rootViewController: vc)
        nvc.modalPresentationStyle = .fullScreen
        present(nvc, animated: true)
    }
    
    deinit {
        print("deinit ReggisterNewPet")
    }
}

extension RegisterNewPetViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 0 && viewModel.petImageList.value.count < 5 {
            showCameraOrImagePickerActionSheet()
            return
        }
    }
    
    private func showCameraOrImagePickerActionSheet() {
        let alert = UIAlertController(title: "어떤 작업을 수행하시겠습니까?", message: nil, preferredStyle: .actionSheet)
        let camera = UIAlertAction(title: "카메라", style: .default) { [weak self] _ in
            self?.pick(sourceType: .camera)
        }
        let imagePicker = UIAlertAction(title: "앨범", style: .default) { [weak self] _ in
            self?.showImagePicker()
        }
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        alert.addAction(camera)
        alert.addAction(imagePicker)
        alert.addAction(cancel)
        present(alert, animated: true)
    }
    func pick(sourceType: UIImagePickerController.SourceType) {
        let picker = UIImagePickerController()
        picker.sourceType = sourceType
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    func showImagePicker() {
        var config = PHPickerConfiguration(photoLibrary: .shared())
        config.filter = .images
        config.preselectedAssetIdentifiers = viewModel.petImageList.value.filter { $0.imageType == .galleryImage }.map { $0.id }.compactMap { $0 }
        config.selectionLimit = 5 - (viewModel.petImageList.value.filter { $0.imageType == .cameraImage }.count)
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = self
        present(picker, animated: true)
    }
}

extension RegisterNewPetViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true) { [weak self] in
            guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else { return }
            guard let self else { return }
            self.viewModel.petImageList.accept(self.viewModel.petImageList.value+[PetImageItem(image: image.downSamplingImage(maxSize: UIScreen.main.bounds.width), imageType: .cameraImage, id: UUID().uuidString)])
        }
    }
}

extension RegisterNewPetViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        let newImages = results.filter { result in
            return !viewModel.petImageList.value.contains { $0.id == result.assetIdentifier }
        }
        if newImages.isEmpty {
            return
        }
        LoadingView.show()
        Observable.zip(newImages.map{ convertImage(provider: $0.itemProvider) }).subscribe(with: self) { owner, imageList in
            var petImageItemList: [PetImageItem] = []
            imageList.enumerated().forEach { element in
                guard let imageIdentifier = newImages[element.offset].assetIdentifier else { return }
                petImageItemList.append(.init(image: imageList[element.offset], imageType: .galleryImage, id: imageIdentifier))
            }
            owner.viewModel.petImageList.accept(owner.viewModel.petImageList.value + petImageItemList)
            LoadingView.hide()
        }.disposed(by: disposeBag)
    }
    
    func convertImage(provider: NSItemProvider) -> Observable<UIImage> {
        return Observable<UIImage>.create { observer in
            if provider.canLoadObject(ofClass: UIImage.self) {
                provider.loadObject(ofClass: UIImage.self) { image, error in
                    if let errror = error {
                        observer.onError(error!)
                    } else {
                        guard let convertImage = image as? UIImage else { return }
                        DispatchQueue.main.async { [weak self] in
                            guard let self else { return }
                            let resizingImage = convertImage.downSamplingImage(maxSize: self.view.frame.width)
                            observer.onNext(resizingImage)
                            observer.onCompleted()
                        }
                    }
                    
                }
            }
            return Disposables.create()
        }
    }
    
}
