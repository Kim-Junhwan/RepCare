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
    
    func checkPetHasDataAtDate(pet: PetObject, date: Date) -> Bool {
        let calendar = Calendar.current
        let checkDate = calendar.dateComponents([.year, .month, .day], from: date)
        for weight in pet.weights {
            let compareDate = calendar.dateComponents([.year, .month, .day], from: weight.date)
            if compareDate == checkDate {
                return true
            }
        }
        return false
    }
    
    func updateStroage(weightDTO: WeightDTO) throws {
        let pet = weightDTO.pet
        let calendar = Calendar.current
        let checkDate = calendar.dateComponents([.year, .month, .day], from: weightDTO.date)
        let updateWeight = pet.weights.first { weight in
            let compareDate = calendar.dateComponents([.year, .month, .day], from: weight.date)
            return compareDate == checkDate
        }
        guard let updateWeight else { throw WeightError.unknownWeight }
        try realm?.write({
            updateWeight.weight = weightDTO.weight
        })
    }
}
