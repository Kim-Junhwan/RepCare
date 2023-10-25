//
//  RealmPetStroage.swift
//  RepCare
//
//  Created by JunHwan Kim on 2023/10/12.
//

import Foundation
import RealmSwift

final class RealmPetStorage {
    private let realm: Realm
    
    init(realm: Realm) {
        self.realm = realm
    }
}

extension RealmPetStorage: PetStorage {
    
    func fetchPetList(request: FetchPetListRequestDTO) -> FetchPetListResponseDTO {
        var petList = realm.objects(PetObject.self)
        
        if request.petClass != nil {
            petList = petList.where { $0.petClass == request.petClass }
        }
        if let searchKeyword = request.searchKeyword, !searchKeyword.isEmpty {
            petList = petList.where { $0.petSpecies.title.contains(searchKeyword) || $0.name.contains(searchKeyword) || $0.detailSpecies.title.contains(searchKeyword) || $0.morph.title.contains(searchKeyword) }
        }
        
        return .init(totalPetCount: petList.count, startIndex: request.startIndex, petList: Array(petList))
    }
    
    func registerPet(request: RegisterPetRequestDTO) throws -> PetObject {
        let pet = PetObject(name: request.name, gender: request.gender, petClass: request.petClass, petSpecies: request.petSpecies, detailSpecies: request.detailSpecies, morph: request.morph, adoptionDate: request.adoptionDate, weights: request.weight, birthDate: request.birthDate, imagePathList: [])
        let imagePathList = request.imagePathList.map { "\(pet._id.stringValue)/\($0)" }
        pet.imagePathList.append(objectsIn: imagePathList)
        try realm.write {
            realm.add(pet)
        }
        return pet
    }
    
    func fetchPet(id: String) -> PetObject? {
        guard let objectId = try? ObjectId(string: id) else { return .init() }
        let pet = realm.object(ofType: PetObject.self, forPrimaryKey: objectId)
        return pet
    }
    
}
