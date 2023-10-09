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
        mainView.delegate = self
    }
    
    @objc func tapRegisterButton() {
        self.dismiss(animated: true)
    }

}

extension ClassSpeciesMorphViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectSectionArr = viewModel.speciesList.value[Section(rawValue: indexPath.section)!]
        
        if indexPath.section != 0 && indexPath.row+1 == selectSectionArr?.count {
            
            return
        }
        if indexPath.section == 0 {
            viewModel.selectPetClass.accept(.init(rawValue: indexPath.row+1)!)
        } else if indexPath.section == 1 {
            viewModel.selectSpecies.accept(indexPath.row)
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

extension ClassSpeciesMorphViewController: SpeciesViewDelegate {
    func getSectionItemCount(section: Section) -> Int {
        guard let sectionItem = viewModel.speciesList.value[section] else { return 0 }
        return sectionItem.count
    }
    
}
