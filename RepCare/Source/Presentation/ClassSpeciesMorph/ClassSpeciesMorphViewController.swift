//
//  ClassSpeciesMorphViewController.swift
//  RepCare
//
//  Created by JunHwan Kim on 2023/10/05.
//

import UIKit
import RxSwift

class ClassSpeciesMorphViewController: UIViewController {
    
    let mainView = SpeciesView()
    let viewModel: ClassSpeciesMorphViewModel
    lazy var registerButton: UIBarButtonItem = {
        let barButton = UIBarButtonItem(title: "등록", style: .plain, target: self, action: #selector(tapRegisterButton))
        return barButton
    }()
    lazy var dismissButton: UIBarButtonItem = {
        let barButton = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(tapDismissButton))
        return barButton
    }()
    
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
        configureCollectionView()
        bind()
        viewModel.viewDidLoad()
        navigationItem.setLeftBarButton(dismissButton, animated: false)
        navigationItem.setRightBarButton(registerButton, animated: false)
        registerButton.isEnabled = false
    }
    
    private func bind() {
        viewModel.speciesList.subscribe(with: self) { $0.mainView.applyData(section: $1) }.disposed(by: disposeBag)
        viewModel.canRegister.subscribe(with: self) { $0.registerButton.isEnabled = $1 }.disposed(by: disposeBag)
    }
    
    func configureCollectionView() {
        mainView.collectionView.delegate = self
        title = "종 선택"
    }
    
    @objc func tapRegisterButton() {
        viewModel.registerSpecies()
        self.dismiss(animated: true)
    }

    @objc func tapDismissButton() {
        self.dismiss(animated: true)
    }
}

extension ClassSpeciesMorphViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let selectSection = Section(rawValue: indexPath.section) else { return }
        let selectSectionArr = viewModel.speciesList.value[selectSection]
        
        if indexPath.section != 0 && indexPath.row+1 == selectSectionArr?.count {
            guard let registerSection = Section(rawValue: indexPath.section) else { return }
            showRegisterAlert(section: registerSection)
            return
        }
        if indexPath.section == 0 {
            let selectClass = viewModel.fetchPetClassList[indexPath.row]
            viewModel.selectPetClass.accept(selectClass)
        } else if indexPath.section == 1 {
            let selectPetSpecies = viewModel.fetchSpeciesList[indexPath.row]
            viewModel.selectSpecies.accept(selectPetSpecies)
        } else if indexPath.section == 2 {
            let selectDetailSpecies = viewModel.fetchDetailSpeciesList[indexPath.row]
            viewModel.selectDetailSpecies.accept(selectDetailSpecies)
        } else if indexPath.section == 3 {
            let selectMorph = viewModel.fetchMorphList[indexPath.row]
            viewModel.selectMorph.accept(selectMorph)
        }
        
        for item in 0..<selectSectionArr!.count {
            if item == indexPath.row {
                continue
            }
            collectionView.deselectItem(at: IndexPath(row: item, section: indexPath.section), animated: false)
        }
    }
    
    private func showRegisterAlert(section: Section) {
        let alert = UIAlertController(title: "종 등록", message: "텍스트를 입력하여 종을 등록하세요.", preferredStyle: .alert)
        alert.addTextField()
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        let ok = UIAlertAction(title: "확인", style: .default) { _ in
            guard let inputText = alert.textFields?.first?.text else { return }
            do {
                try self.viewModel.registerNewSpecies(section: section, title: inputText)
            } catch {
                print(fatalError())
            }
            
        }
        alert.addAction(cancel)
        alert.addAction(ok)
        present(alert, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            viewModel.selectPetClass.accept(nil)
        } else if indexPath.section == 1 {
            viewModel.selectSpecies.accept(nil)
        } else if indexPath.section == 2 {
            viewModel.selectDetailSpecies.accept(nil)
        } else if indexPath.section == 3 {
            viewModel.selectMorph.accept(nil)
        }
        viewModel.removeSection(sectionIndex: indexPath.section)
    }
}
