//
//  DefaultWeightRepository.swift
//  RepCare
//
//  Created by JunHwan Kim on 2023/10/22.
//

import Foundation

final class DefaultWeightRepository: WeightRepository {
    
    let weightStroage: WeightStorage
    let petStorage: PetStorage
    
    init(weightStroage: WeightStorage, petStorage: PetStorage) {
        self.weightStroage = weightStroage
        self.petStorage = petStorage
    }
    
    func registerWeight(petId: String, weight: Weight) throws {
        guard let pet = petStorage.fetchPet(id: petId) else { throw RepositoryError.unknownPet }
        try weightStroage.registerWeight(weight: .init(pet: pet, weight: weight.weight, date: weight.date))
    }
    
    func fetchAllWeight(petId: String) -> [Weight] {
        guard let pet = petStorage.fetchPet(id: petId) else { return [] }
        return weightStroage.fetchWeightList(pet: pet).map { .init(date: $0.date, weight: $0.weight) }
    }
    
}
