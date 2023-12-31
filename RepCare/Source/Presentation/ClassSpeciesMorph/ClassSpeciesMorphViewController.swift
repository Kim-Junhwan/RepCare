//
//  ClassSpeciesMorphViewController.swift
//  RepCare
//
//  Created by JunHwan Kim on 2023/10/05.
//

import UIKit
import RxSwift

class ClassSpeciesMorphViewController: BaseViewController {
    
    let mainView = SpeciesView()
    let viewModel: ClassSpeciesMorphViewModel
    lazy var registerButton: UIBarButtonItem = {
        let barButton = UIBarButtonItem(title: viewModel.registerButtonTitle, style: .plain, target: self, action: #selector(tapRegisterButton))
        return barButton
    }()
    lazy var dismissButton: UIBarButtonItem = {
        let barButton = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(tapDismissButton))
        barButton.tintColor = .red
        return barButton
    }()
    var isEditSpecies: Bool = false
    
    let disposeBag = DisposeBag()
    
    init(viewModel: ClassSpeciesMorphViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.configureDatasource(dataSource: makeDataource())
        configureCollectionView()
        viewModel.viewDidLoad()
        navigationItem.setLeftBarButton(dismissButton, animated: false)
        navigationItem.setRightBarButton(registerButton, animated: false)
        registerButton.isEnabled = false
        bind()
        loadSelected()
    }
    
    func loadSelected() {
        guard let tempSpecies = viewModel.temporaryPetSpeceis else { return }
        guard let petClass = tempSpecies.petClass else { return }
        guard let selectPetClassIndex = viewModel.fetchPetClassList.enumerated().first(where: { $0.element == petClass })?.offset else { return }
        mainView.collectionView.selectItem(at: IndexPath(row: selectPetClassIndex, section: 0), animated: false, scrollPosition: .init())
        guard let selectSpeciesIndex = viewModel.fetchSpeciesList.enumerated().first(where: { $0.element.id == tempSpecies.petSpecies?.id })?.offset else { return }
        mainView.collectionView.selectItem(at: IndexPath(row: selectSpeciesIndex, section: 1), animated: false, scrollPosition: .init())
        guard let selectDetailSpeciesIndex = viewModel.fetchDetailSpeciesList.enumerated().first(where: { $0.element.id == tempSpecies.detailSpecies?.id })?.offset else { return }
        mainView.collectionView.selectItem(at: IndexPath(row: selectDetailSpeciesIndex, section: 2), animated: false, scrollPosition: .init())
        guard let selectMorphIndex = viewModel.fetchMorphList.enumerated().first(where: { $0.element.id == tempSpecies.morph?.id })?.offset else { return }
        mainView.collectionView.selectItem(at: IndexPath(row: selectMorphIndex, section: 3), animated: false, scrollPosition: .init())
    }
    
    private func bind() {
        viewModel.speciesList.subscribe(with: self) { $0.mainView.applyData(section: $1) }.disposed(by: disposeBag)
        viewModel.canRegister.drive(with: self) { $0.registerButton.isEnabled = $1 }.disposed(by: disposeBag)
    }
    
    func configureCollectionView() {
        mainView.collectionView.delegate = self
        title = viewModel.title
    }
    
    @objc func tapRegisterButton() {
        viewModel.registerSpecies()
        self.dismiss(animated: true)
    }
    
    @objc func tapDismissButton() {
        self.dismiss(animated: true)
    }
    
    func makeDataource() -> UICollectionViewDiffableDataSource<Section, Item> {
        let cellRegistration = UICollectionView.CellRegistration<SpeciesCell, Item> { cell, indexPath, itemIdentifier in
            cell.titleLabel.text = itemIdentifier.title
            if indexPath.section != 0 {
                let interaction = UIContextMenuInteraction(delegate: self)
                cell.addInteraction(interaction)
            }
        }
        
        return UICollectionViewDiffableDataSource<Section, Item>(collectionView: mainView.collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            if itemIdentifier.isRegisterCell {
                return collectionView.dequeueReusableCell(withReuseIdentifier: RegisterCollectionViewCell.identifier, for: indexPath)
            }
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
        })
    }
    
    deinit {
        print("deinit ClassSpeciesMorphViewController")
    }
}

extension ClassSpeciesMorphViewController: UIContextMenuInteractionDelegate {
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
        guard let cellLocation = interaction.view?.frame.origin else {return nil}
        guard let indexPath = mainView.collectionView.indexPathForItem(at: cellLocation) else { return nil }
        guard let section = Section(rawValue: indexPath.section ), let currentSectionList = viewModel.speciesList.value[section] else { return nil }
        if currentSectionList.count == indexPath.row+1 {
            return nil
        }
        
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { suggestAction in
            
            let updateAction = UIAction(title: "수정", image: UIImage(systemName: "pencil")) { [weak self] action in
                guard let self else { return }
                self.showTextFiledAlert(title: "수정", message: "적용할 내용을 입력해주세요.", textFieldText: currentSectionList[indexPath.row].title) { text in
                    do {
                        try self.viewModel.updateSpecies(section: section, row: indexPath.row, editTitle: text)
                        guard let modifyItem = self.viewModel.speciesList.value[section]?[indexPath.row] else { return }
                        self.mainView.reloadItem(item: modifyItem)
                    } catch {
                        self.showErrorAlert(title: "수정 실패", message: error.localizedDescription)
                    }
                }
            }
            
            let deleteAction = UIAction(title: "삭제", image: UIImage(systemName: "trash"), attributes: .destructive) { [weak self] _ in
                guard let self else { return }
                guard let section = Section(rawValue: indexPath.section ) else { return }
                self.showTaskAlert(title: "경고", message: "해당 작업을 수행하면 하위에 저장된 종 역시 삭제됩니다. 또한 기존에 저장된 애완동물의 종 역시 변경 될 수 있습니다.") {
                    do {
                        try self.viewModel.deleteSpecies(section: section, row: indexPath.row)
                    } catch {
                        self.showErrorAlert(title: "삭제 실패", message: error.localizedDescription)
                    }
                }
                
            }
            if indexPath.section == 0 || indexPath.section == 1 {
                return UIMenu(title: "", children: [updateAction])
            }
            return UIMenu(title: "", children: [updateAction, deleteAction])
        }
    }
    
}

extension ClassSpeciesMorphViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let selectSection = Section(rawValue: indexPath.section) else { return }
        let selectSectionArr = viewModel.speciesList.value[selectSection]
        if indexPath.section != 0 && indexPath.row+1 == selectSectionArr?.count {
            guard let registerSection = Section(rawValue: indexPath.section) else { return }
            showRegisterAlert(title: "종 등록", message: "텍스트를 입력하여 종을 등록하세요.", section: registerSection)
            collectionView.deselectItem(at: indexPath, animated: false)
            return
        }
        if indexPath.section == 0 {
            let selectClass = viewModel.fetchPetClassList[indexPath.row]
            viewModel.selectPetClass(petClass: selectClass)
        } else if indexPath.section == 1 {
            let selectPetSpecies = viewModel.fetchSpeciesList[indexPath.row]
            viewModel.selectPetSpecies(species: selectPetSpecies)
        } else if indexPath.section == 2 {
            let selectDetailSpecies = viewModel.fetchDetailSpeciesList[indexPath.row]
            viewModel.selectDetailSpecies(detailSpecies: selectDetailSpecies)
        } else if indexPath.section == 3 {
            let selectMorph = viewModel.fetchMorphList[indexPath.row]
            viewModel.selectMorph(morph: selectMorph)
        }
        for item in 0..<selectSectionArr!.count {
            if item == indexPath.row {
                continue
            }
            collectionView.deselectItem(at: IndexPath(row: item, section: indexPath.section), animated: false)
        }
        
    }
    
    func showTextFiledAlert(title: String, message: String, textFieldText: String? = nil, action: ((String)-> Void)?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addTextField { textField in
            textField.text = textFieldText
        }
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        let ok = UIAlertAction(title: "확인", style: .default) { _ in
            guard let text = alert.textFields?.first?.text else { return }
            action?(text)
        }
        
        alert.addAction(cancel)
        alert.addAction(ok)
        present(alert, animated: true)
    }
    
    private func showRegisterAlert(title: String, message: String ,section: Section) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addTextField()
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        let ok = UIAlertAction(title: "확인", style: .default) { [weak self] _ in
            guard let self else { return }
            guard let inputText = alert.textFields?.first?.text?.trimmingCharacters(in: .whitespaces), !inputText.isEmpty else { return }
            if self.viewModel.checkCanRegisterNewSpecies(section: section, title: inputText) {
                do {
                    try self.viewModel.registerNewSpecies(section: section, title: inputText)
                } catch {
                    showErrorAlert(title: "저장 실패", message: error.localizedDescription)
                }
            } else {
                self.showErrorAlert(title: "중복된 이름", message: "이미 같은 이름을 가진 종이 존재합니다.")
            }
        }
        alert.addAction(cancel)
        alert.addAction(ok)
        present(alert, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            viewModel.selectPetClass(petClass: nil)
        } else if indexPath.section == 1 {
            viewModel.selectPetSpecies(species: nil)
        } else if indexPath.section == 2 {
            viewModel.selectDetailSpecies(detailSpecies: nil)
        } else if indexPath.section == 3 {
            viewModel.selectMorph(morph: nil)
        }
        viewModel.removeSection(sectionIndex: indexPath.section)
    }
}
