//
//  PetListViewController.swift
//  RepCare
//
//  Created by JunHwan Kim on 2023/09/29.
//

import UIKit
import RealmSwift
import RxSwift

final class PetListViewController: BaseViewController {
    
    let mainView = PetListView()
    let viewModel = PetListViewModel(fetchPetListUseCase: DefaultFetchPetListUseCase(petRepository: DefaultPetRepository(petStorage: RealmPetStorage(), speciesStroage: RealmSpeciesStorage())))
    let disposeBag = DisposeBag()
    
    override func loadView() {
        view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        viewModel.fetchFilteringPetList(petClass: .all, species: nil, detailSpecies: nil, morph: nil, gender: nil)
    }
    
    private func bind() {
        viewModel.petList.subscribe { petList in
            self.mainView.petListCollectionView.reloadData()
        }.disposed(by: disposeBag)
    }
    
    override func configureView() {
        mainView.delegate = self
        mainView.petClassCollectionView.dataSource = self
        mainView.petListCollectionView.dataSource = self
        mainView.addPetButton.addTarget(self, action: #selector(showRegisterPetView), for: .touchUpInside)
    }
    
    @objc func showRegisterPetView() {
        let registerVC = RegisterNewPetViewController()
        navigationController?.pushViewController(registerVC, animated: true)
    }

}

extension PetListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == mainView.petClassCollectionView {
            return PetClassModel.allCases.count
        } else {
            return viewModel.petList.value.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == mainView.petClassCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PetClassCollectionViewCell.identifier, for: indexPath) as? PetClassCollectionViewCell else { return .init() }
            cell.configureCell(petClass: .init(rawValue: indexPath.row) ?? .etc)
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PetCollectionViewCell.identifier, for: indexPath) as? PetCollectionViewCell else { return .init() }
            cell.configureCell(pet: viewModel.petList.value[indexPath.row])
            return cell
        }
    }
    
    
}

extension PetListViewController: PetListViewDelegate {
    
    func reloadPetList(completion: @escaping () -> Void) {
        viewModel.reloadPetList()
        completion()
    }
    
    func selectPetClass(petClass: PetClassModel) {
        viewModel.fetchFilterPetClassPetList(petClass: petClass)
    }
    
    func selectPet(at index: Int) {
        <#code#>
    }
}
