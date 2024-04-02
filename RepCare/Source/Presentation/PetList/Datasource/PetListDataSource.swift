//
//  PetListDataSource.swift
//  RepCare
//
//  Created by JunHwan Kim on 2024/04/02.
//

import Foundation
import UIKit

final class PetListDataSource: NSObject, UICollectionViewDataSource {
    
    var petList: [PetModel]
    var petListMode: PetListMode
    
    init(petList: [PetModel], petListMode: PetListMode) {
        self.petList = petList
        self.petListMode = petListMode
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return petList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if petListMode == .grid {
            return gridCollectionViewReusableCell(collectionView, cellForItemAt: indexPath)
        } else {
            return tableCollectionViewReusableCell(collectionView, cellForItemAt: indexPath)
        }
    }
    
    private func gridCollectionViewReusableCell(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GridPetCollectionViewCell.identifier, for: indexPath) as? GridPetCollectionViewCell else { fatalError() }
        cell.configureCell(pet: petList[indexPath.row])
        return cell
    }
    
    private func tableCollectionViewReusableCell(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TablePetCollectionViewCell.identifier, for: indexPath) as? TablePetCollectionViewCell else { fatalError() }
        cell.configureCell(pet: petList[indexPath.row])
        return cell
    }
}
