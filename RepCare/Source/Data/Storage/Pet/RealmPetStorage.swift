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
        var petList = realm.objects(PetObject.self)
        if request.petClass != nil {
            petList = petList.where { $0.petClass == request.petClass }
        }
        
        return .init(totalPetCount: petList.count, startIndex: request.startIndex, petList: Array(petList))
    }
    
    func registerPet(request: RegisterPetRequestDTO) throws -> PetObject {
        guard let realm else { return .init() }
        let pet = PetObject(name: request.name, gender: request.gender, petClass: request.petClass, petSpecies: request.petSpecies, detailSpecies: request.detailSpecies, morph: request.morph, adoptionDate: request.adoptionDate, weights: request.weight, birthDate: request.birthDate, imagePathList: [])
        let imagePathList = request.imagePathList.map { "\(pet._id.stringValue)/\($0)" }
        pet.imagePathList.append(objectsIn: imagePathList)
        try realm.write {
            realm.add(pet)
        }
        return pet
    }
    
    func fetchPet(id: String) -> PetObject? {
        guard let realm, let objectId = try? ObjectId(string: id) else { return .init() }
        let pet = realm.object(ofType: PetObject.self, forPrimaryKey: objectId)
        return pet
    }
    
}
