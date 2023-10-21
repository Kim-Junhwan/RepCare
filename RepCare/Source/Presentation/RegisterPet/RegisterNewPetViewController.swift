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
    let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.dateFormat = "yyyy/MM/dd"
        return dateFormatter
    }()
    let disposeBag = DisposeBag()
    
    lazy var registerButton: UIBarButtonItem = {
        let barButton = UIBarButtonItem(title: "등록", style: .plain, target: self, action: #selector(tapRegisterButton))
        return barButton
    }()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
            button.rx.tap.bind { self.viewModel.gender.accept(gender) }.disposed(by: disposeBag)
        }
    }
    
    private func bindAdoptionDate() {
        viewModel.adoptionDate.subscribe { adopDate in
            guard let adopDate else { return }
            self.mainView.adoptionDateButton.datePickerButton.setTitle(self.dateFormatter.string(from: adopDate), for: .normal) }.disposed(by: disposeBag)
    }
    
    private func bindBirthDate() {
        viewModel.hatchDate.subscribe {
            guard let birthDate = $0 else { return }
            self.mainView.birthDayButton.datePickerButton.setTitle(self.dateFormatter.string(from: birthDate), for: .normal) }.disposed(by: disposeBag)
    }
    
    private func bindWeight() {
        mainView.weightTextField.textField.rx.text.orEmpty.subscribe { fetchWeight in
            guard let weightStr = fetchWeight.event.element else { return }
            self.viewModel.currentWeight.accept(Double(weightStr))
        }.disposed(by: disposeBag)
    }
    
    override func configureView() {
        title = "개체 등록"
        registerButton.isEnabled = false
        navigationItem.setRightBarButton(registerButton, animated: false)
        mainView.setDatePickerButton(viewController: self)
        mainView.speciesClassButton.actionButton.addTarget(self, action: #selector(showSpeciesView), for: .touchUpInside)
        mainView.adoptionDateButton.datePickerButton.actionClosure = { selectDate in
            self.viewModel.adoptionDate.accept(selectDate)
        }
        mainView.birthDayButton.datePickerButton.actionClosure = { selectDate in
            self.viewModel.hatchDate.accept(selectDate)
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
    
    @objc func showSpeciesView() {
        let speciesViewModel = ClassSpeciesMorphViewModel(repository: DefaultSpeciesRepository(speciesStroage: RealmSpeciesStorage()))
        let vc = ClassSpeciesMorphViewController(viewModel: speciesViewModel)
        speciesViewModel.tapRegisterClosure = { self.viewModel.overPetSpecies.accept($0) }
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
        if indexPath.row == 0 {
            showCameraOrImagePickerActionSheet()
        }
    }
    
    private func showCameraOrImagePickerActionSheet() {
        let alert = UIAlertController(title: "어떤 작업을 수행하시겠습니까?", message: nil, preferredStyle: .actionSheet)
        let camera = UIAlertAction(title: "카메라", style: .default) { _ in
            self.pick(sourceType: .camera)
        }
        let imagePicker = UIAlertAction(title: "앨범", style: .default) { _ in
            self.showImagePicker()
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
        var config = PHPickerConfiguration()
        config.selectionLimit = 5
        config.filter = .images
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = self
        present(picker, animated: true)
    }
}

extension RegisterNewPetViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true) {
            let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
            self.viewModel.petImageList.accept([.init(image: image!)])
        }
    }
}

extension RegisterNewPetViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        
        picker.dismiss(animated: true)
        let itemProviderList = results.map { $0.itemProvider }
        Observable.zip(itemProviderList.map { convertImage(provider: $0) }).subscribe { imageList in
            let petImageList = imageList.map { PetImageItem(image: $0) }
            DispatchQueue.main.async {
                self.viewModel.petImageList.accept(petImageList)
            }
        } onError: { error in
            print("error \(error)")
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
                        observer.onNext(convertImage)
                        observer.onCompleted()
                    }
                    
                }
            }
            return Disposables.create()
        }
    }
    
}
