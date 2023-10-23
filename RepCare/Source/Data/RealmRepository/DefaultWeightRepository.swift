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
    
    func registerWeight(petId: String, date: Date, weight: Double) throws {
        guard let pet = petStorage.fetchPet(id: petId) else { throw RepositoryError.unknownPet }
        try weightStroage.registerWeight(weight: .init(pet: pet, weight: weight, date: date))
    }
    
    func fetchAllWeight(petId: String) -> [Weight] {
        guard let pet = petStorage.fetchPet(id: petId) else { return [] }
        return weightStroage.fetchWeightList(pet: pet).map { .init(id: $0._id.stringValue, date: $0.date, weight: $0.weight) }.sorted { $0.date < $1.date }
    }
    
    func updateWeightAtDate(petId: String, date: Date, weight: Double) throws {
        guard let pet = petStorage.fetchPet(id: petId) else { throw RepositoryError.unknownPet }
        try weightStroage.updateStroage(weightDTO: .init(pet: pet, weight: weight, date: date))
    }
    
    func checkRegisterWeightInDay(petId: String, date: Date) -> hasData {
        guard let pet = petStorage.fetchPet(id: petId) else { return false }
        return weightStroage.checkPetHasDataAtDate(pet: pet, date: date)
    }
    
}
