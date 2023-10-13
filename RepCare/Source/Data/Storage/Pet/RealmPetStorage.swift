//
//  RealmPetStroage.swift
//  RepCare
//
//  Created by JunHwan Kim on 2023/10/12.
//

import Foundation
import RealmSwift

final class RealmPetStorage {
    private let realm: Realm? = {
        guard let realmPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("repcare.realm", conformingTo: .data) else {fatalError()}
        let bundleRealm = try? Realm(fileURL: realmPath)
        return bundleRealm
    }()
}

extension RealmPetStorage: PetStorage {
    
    func fetchPetList(request: FetchPetListRequestDTO) -> FetchPetListResponseDTO {
        guard let realm else { return .init(totalPetCount: 0, startIndex: 0, petList: []) }
        let petList = realm.objects(PetObject.self)
        
        return .init(totalPetCount: petList.count, startIndex: request.startIndex, petList: Array(petList))
    }
    
    func registerPet(request: RegisterPetRequestDTO) throws -> PetObject {
        guard let realm else { return .init() }
        let pet = PetObject(name: request.name, gender: request.gender, petClass: request.petClass, petSpecies: request.petSpecies, detailSpecies: request.detailSpecies, morph: request.morph, adoptionDate: request.adoptionDate, weights: request.weight, birthDate: request.birthDate, imagePathList: request.imagePathList)
        try realm.write {
            realm.add(pet)
        }
        return pet
    }
    
}
