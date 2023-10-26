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
        bind()
        mainView.petClassCollectionView.selectItem(at: [0,0], animated: false, scrollPosition: .init())
        mainView.collectionView(mainView.petClassCollectionView, didSelectItemAt: .init(row: 0, section: 0))
    }
    
    private func bind() {
        viewModel.petList.asDriver().drive(with: self) { owner, petList in
            owner.mainView.petListCollectionView.reloadData()
        }.disposed(by: disposeBag)
    }
    
    override func configureView() {
        mainView.delegate = self
        mainView.petClassCollectionView.dataSource = self
        mainView.petListCollectionView.dataSource = self
        mainView.addPetButton.addTarget(self, action: #selector(showRegisterPetView), for: .touchUpInside)
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
}
