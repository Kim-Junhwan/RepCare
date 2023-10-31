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
    
    lazy var addPetButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(showRegisterPetView))
        button.tintColor = .deepGreen
        return button
    }()
    
    let mainView = PetListView()
    let viewModel: PetListViewModel
    let disposeBag = DisposeBag()
    
    init(viewModel: PetListViewModel) {
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
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        bind()
        navigationItem.setRightBarButton(addPetButton, animated: false)
        selectPetClassCode(petClass: .all)
    }
    
    func selectPetClassCode(petClass: PetClassModel) {
        mainView.petClassCollectionView.selectItem(at: .init(row: petClass.rawValue, section: 0), animated: false, scrollPosition: .init())
        mainView.collectionView(mainView.petClassCollectionView, didSelectItemAt: .init(row: petClass.rawValue, section: 0))
    }
    
    private func bind() {
        viewModel.petList.asDriver().drive(with: self) { owner, petList in
            if petList.isEmpty {
                owner.mainView.emptyLabel.isHidden = false
                owner.mainView.petListCollectionView.isHidden = true
                return
            }
            owner.mainView.emptyLabel.isHidden = true
            owner.mainView.petListCollectionView.isHidden = false
            owner.mainView.petListCollectionView.reloadData()
        }.disposed(by: disposeBag)
        
        viewModel.queryDriver.drive(with: self) { owner, query in
            owner.mainView.petClassCollectionView.selectItem(at: .init(row: PetClassModel(petClass: query.petClass).rawValue, section: 0), animated: false, scrollPosition: .init())
        }.disposed(by: disposeBag)
        
        viewModel.isApplyFilter.drive(with: self) { owner, isFiltering in
            owner.mainView.setFilterButtonIsFilteringStatus(isFiltering: isFiltering)
        }.disposed(by: disposeBag)
    }
    
    override func configureView() {
        mainView.delegate = self
        mainView.petClassCollectionView.dataSource = self
        mainView.petListCollectionView.dataSource = self
    }
    
    @objc func showRegisterPetView() {
        let registerVC = viewModel.diContainer.makeRegisterViewController()
        registerVC.tapRegisterButtonClosure = { [weak self] in
            self?.viewModel.reloadPetList()
        }
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
    
    func tapFilterButton() {
        let petClass: PetClassModel? = viewModel.currentQuery.petClass == .all ? nil : .init(petClass: viewModel.currentQuery.petClass)
        let speceis: PetSpeciesModel? = viewModel.currentQuery.species.flatMap { .init(petSpecies: $0) }
        let detailSpecies: DetailPetSpeciesModel? = viewModel.currentQuery.detailSpecies.flatMap { .init(detailSpecies: $0) }
        let morph: MorphModel? = viewModel.currentQuery.morph.flatMap { .init(morph: $0) }
        let vc = viewModel.diContainer.makeFilterSpeciesViewController(petClass: petClass, species: speceis, detailSpecies: detailSpecies, morph: morph)
        let nvc = UINavigationController(rootViewController: vc)
        vc.viewModel.tapRegisterClosure = { [weak self] overSpecies in
            guard let filterPetClass = overSpecies.petClass else { return }
            self?.viewModel.fetchFilteringPetList(petClass: filterPetClass, species: overSpecies.petSpecies, detailSpecies: overSpecies.detailSpecies, morph: overSpecies.morph, gender: nil)
        }
        present(nvc, animated: true)
    }
    
    func searchPetList(searchKeyword: String) {
        viewModel.searchPet(keyword: searchKeyword)
    }
    
    func reloadPetList(completion: @escaping () -> Void) {
        viewModel.reloadPetList()
        completion()
    }
    
    func selectPetClass(petClass: PetClassModel) {
        viewModel.fetchFilterPetClassPetList(petClass: petClass)
    }
    
    func selectPet(at index: Int) {
        let detailViewController = viewModel.diContainer.makeDetailPetViewController(pet: viewModel.petList.value[index])
        detailViewController.updateClosure = {
            self.viewModel.reloadPetList()
        }
        navigationController?.pushViewController(detailViewController, animated: true)
    }
    
    func loadNextPage(completion: (() -> Void)?) {
        viewModel.loadNextPage()
    }
}
