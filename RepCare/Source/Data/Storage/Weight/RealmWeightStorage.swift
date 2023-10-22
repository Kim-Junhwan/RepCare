//
//  RealmWeightStorage.swift
//  RepCare
//
//  Created by JunHwan Kim on 2023/10/22.
//

import Foundation
import RealmSwift

final class RealmWeightStorage: WeightStorage {
    private let realm: Realm? = {
        guard let realmPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("repcare.realm", conformingTo: .data) else {fatalError()}
        let bundleRealm = try? Realm(fileURL: realmPath)
        return bundleRealm
    }()
    
    func registerWeight(weight: WeightDTO) throws {
        guard let realm else { return }
        let pet = weight.pet
        try realm.write {
            pet.weights.append(.init(date: weight.date, weight: weight.weight))
        }
    }
    
    func fetchWeightList(pet: PetObject) -> [WeightObject] {
        return Array(pet.weights)
    }
    
    
}
