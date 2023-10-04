//
//  PetListViewController.swift
//  RepCare
//
//  Created by JunHwan Kim on 2023/09/29.
//

import UIKit
import RealmSwift

final class PetListViewController: BaseViewController {
    
    let mainView = PetListView()
    let viewModel = PetListViewModel()
    
    override func loadView() {
        view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureView() {
        mainView.petClassCollectionView.dataSource = self
        mainView.petListCollectionView.dataSource = self
    }

}

extension PetListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == mainView.petClassCollectionView {
            return PetClassItemViewModel.allCases.count
        } else {
            return viewModel.petList.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == mainView.petClassCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PetClassCollectionViewCell.identifier, for: indexPath) as? PetClassCollectionViewCell else { return .init() }
            cell.configureCell(petClass: .init(rawValue: indexPath.row) ?? .etc)
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PetClassCollectionViewCell.identifier, for: indexPath) as? PetClassCollectionViewCell else { return .init() }
            
            return cell
        }
    }
    
    
}
