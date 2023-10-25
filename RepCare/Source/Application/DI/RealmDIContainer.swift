//
//  RealmDIContainer.swift
//  RepCare
//
//  Created by JunHwan Kim on 2023/10/25.
//

import Foundation
import RealmSwift

protocol StorageDIContainer {
    var petStorage: PetStorage { get }
    var speciesStorage: SpeciesStorage { get }
    var taskStroage: TaskStorage { get }
    var weightStorage: WeightStorage { get }
}

final class RealmDIContainer: StorageDIContainer {
    
    let realm: Realm = {
        guard let realmPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("repcare.realm", conformingTo: .data) else {fatalError()}
        do {
            let bundleRealm = try Realm(fileURL: realmPath)
            return bundleRealm
        } catch {
            fatalError(error.localizedDescription)
        }
    }()
    
    lazy var petStorage: PetStorage = {
       let petStorage = RealmPetStorage(realm: realm)
        return petStorage
    }()
    
    lazy var speciesStorage: SpeciesStorage = {
        let speciesStorage = RealmSpeciesStorage(realm: realm)
        return speciesStorage
    }()
    
    lazy var taskStroage: TaskStorage = {
        let taskStorage = RealmTaskStorage(realm: realm)
        return taskStorage
    }()
    
    lazy var weightStorage: WeightStorage = {
        let weightStorage = RealmWeightStorage(realm: realm)
        return weightStorage
    }()
}
