//
//  RealmWeightStorage.swift
//  RepCare
//
//  Created by JunHwan Kim on 2023/10/22.
//

import Foundation
import RealmSwift

enum WeightError: Error {
    case unknownWeight
}

final class RealmWeightStorage: WeightStorage {
    
    private let realm: Realm
    
    init(realm: Realm) {
        self.realm = realm
    }
    
    func registerWeight(weight: WeightDTO) throws {
        let pet = weight.pet
        try realm.write {
            pet.weights.append(.init(date: weight.date, weight: weight.weight))
        }
    }
    
    func fetchWeightList(pet: PetObject) -> [WeightObject] {
        return Array(pet.weights)
    }
    
    func checkPetHasDataAtDate(pet: PetObject, date: Date) -> Bool {
        for weight in pet.weights {
            if weight.date.isEqualDay(date) {
                return true
            }
        }
        return false
    }
    
    func updateStroage(weightDTO: WeightDTO) throws {
        let pet = weightDTO.pet
        let updateWeight = pet.weights.first { weight in
            return weightDTO.date.isEqualDay(weight.date)
        }
        guard let updateWeight else { throw WeightError.unknownWeight }
        try realm.write({
            updateWeight.weight = weightDTO.weight
        })
    }
    
    func deleteWeight(weightId: String) throws {
        guard let weightObjId = try? ObjectId(string: weightId) else { return }
        guard let weightObj = realm.object(ofType: WeightObject.self, forPrimaryKey: weightObjId) else { return }
        try realm.write {
            realm.delete(weightObj)
        }
    }
    
    func deleteWeight(pet: PetObject, date: Date) throws {
        guard let deleteWeight = pet.weights.filter({ $0.date == date }).first else { return }
        try realm.write {
            realm.delete(deleteWeight)
        }
    }
}
