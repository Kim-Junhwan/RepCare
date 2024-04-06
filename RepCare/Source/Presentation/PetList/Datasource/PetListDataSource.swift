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
    private let imageFetcher = ImageFetcher()
    
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
        let pet = petList[indexPath.row]
        cell.configureCell(pet: pet)
        if let petImage = pet.imagePath.first?.imagePath {
            imageFetcher.fetchImage(id: pet.id, imagePath: petImage) { result in
                switch result {
                case .success(let fetchImage):
                    DispatchQueue.main.async {
                        cell.petImageView.image = fetchImage
                    }
                case .failure(_):
                    print("Image fetch Fail")
                }
            }
        }
        return cell
    }
    
    private func tableCollectionViewReusableCell(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TablePetCollectionViewCell.identifier, for: indexPath) as? TablePetCollectionViewCell else { fatalError() }
        let pet = petList[indexPath.row]
        cell.configureCell(pet: petList[indexPath.row])
        if let petImage = pet.imagePath.first?.imagePath {
            imageFetcher.fetchImage(id: pet.id, imagePath: petImage) { result in
                switch result {
                case .success(let fetchImage):
                    DispatchQueue.main.async {
                        cell.petImageView.image = fetchImage
                    }
                case .failure(_):
                    print("Image fetch Fail")
                }
            }
        }
        return cell
    }
}

extension PetListDataSource: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            let pet = petList[indexPath.row]
            guard let fetchImage = pet.imagePath.first?.imagePath else { return }
            imageFetcher.fetchImage(id: pet.id, imagePath: fetchImage)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            let pet = petList[indexPath.row]
            imageFetcher.cancelFetchImage(id: pet.id)
        }
    }
}
