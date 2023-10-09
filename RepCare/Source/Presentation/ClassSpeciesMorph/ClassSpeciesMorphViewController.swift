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
    let viewModel: ClassSpeciesMorphViewModel = .init(repository: DefaultSpeciesRepository(speciesStroage: RealmSpeciesStorage()))
    lazy var registerButton: UIBarButtonItem = {
        let barButton = UIBarButtonItem(title: "등록", style: .plain, target: self, action: #selector(tapRegisterButton))
        return barButton
    }()
    let disposeBag = DisposeBag()
    
    override func loadView() {
        view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        bind()
        viewModel.viewDidLoad()
        navigationItem.setRightBarButton(registerButton, animated: false)
    }
    
    private func bind() {
        viewModel.speciesList.subscribe { self.mainView.applyData(section: $0) }.disposed(by: disposeBag)
    }
    
    func configureCollectionView() {
        mainView.collectionView.delegate = self
    }
    
    @objc func tapRegisterButton() {
        self.dismiss(animated: true)
    }

}

extension ClassSpeciesMorphViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let selectSection = Section(rawValue: indexPath.section) else { return }
        let selectSectionArr = viewModel.speciesList.value[selectSection]
        
        if indexPath.section != 0 && indexPath.row+1 == selectSectionArr?.count {
            
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
        }
        
        for item in 0..<selectSectionArr!.count {
            if item == indexPath.row {
                continue
            }
            collectionView.deselectItem(at: IndexPath(row: item, section: indexPath.section), animated: false)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        viewModel.removeSection(sectionIndex: indexPath.section)
    }
}
