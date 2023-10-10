//
//  RegisterNewPetViewController.swift
//  RepCare
//
//  Created by JunHwan Kim on 2023/10/04.
//

import UIKit
import RxSwift
import RxCocoa

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
        
    }
    
    private func bind() {
        bindRegisterButton()
        bindName()
        bindSpecies()
        bindGender()
        bindAdoptionDate()
        bindBirthDate()
        bindWeight()
    }
    
    private func bindRegisterButton() {
        viewModel.canRegister.subscribe { self.registerButton.isEnabled = $0 }.disposed(by: disposeBag)
    }
    
    private func bindName() {
        mainView.nameTextField.textField.rx.text.orEmpty.subscribe { input in
            guard let inputStr = input.event.element else { return }
            self.viewModel.petName.accept(inputStr)
        }.disposed(by: disposeBag)
    }
    
    private func bindSpecies() {
        viewModel.overPetSpecies.subscribe { currentSpecies in
            guard let species = currentSpecies.element else { return }
            var speciesArr: [String] = []
            speciesArr.append(species.petClass.title)
            speciesArr.append(species.petSpecies.title)
            if let detailSpecies = species.detailSpecies?.title {
                speciesArr.append(detailSpecies)
            }
            if let morph = species.morph?.title {
                speciesArr.append(morph)
            }
            
            self.mainView.speciesClassButton.actionButton.setTitle("\(speciesArr.joined(separator: " > "))", for: .normal)
        }.disposed(by: disposeBag)
    }
    
    private func bindGender() {
        mainView.genderButtonList.forEach { button in
            guard let gender = GenderModel(rawValue: button.tag) else {  return }
            button.rx.tap.bind { self.viewModel.gender.accept(gender) }.disposed(by: disposeBag)
        }
    }
    
    private func bindAdoptionDate() {
        viewModel.adoptionDate.subscribe { self.mainView.adoptionDateButton.datePickerButton.setTitle(self.dateFormatter.string(from: $0), for: .normal) }.disposed(by: disposeBag)
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
        
    }
    
    @objc func showSpeciesView() {
        let viewModel = ClassSpeciesMorphViewModel(repository: DefaultSpeciesRepository(speciesStroage: RealmSpeciesStorage()))
        let vc = ClassSpeciesMorphViewController(viewModel: viewModel)
        viewModel.tapRegisterClosure = { self.viewModel.overPetSpecies.accept($0) }
        let nvc = UINavigationController(rootViewController: vc)
        nvc.modalPresentationStyle = .fullScreen
        present(nvc, animated: true)
    }
}
