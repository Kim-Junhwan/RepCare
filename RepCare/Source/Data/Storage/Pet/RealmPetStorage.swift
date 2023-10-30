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
        if let petSpecies = request.petSpecies {
            petList = petList.where { $0.petSpecies == petSpecies }
        }
        if let detailSpecies = request.detailSpecies {
            petList = petList.where { $0.detailSpecies == detailSpecies }
        }
        if let morph = request.morph {
            petList = petList.where { $0.morph == morph }
        }
        if let searchKeyword = request.searchKeyword, !searchKeyword.isEmpty {
            petList = petList.where { $0.petSpecies.title.contains(searchKeyword) || $0.name.contains(searchKeyword) || $0.detailSpecies.title.contains(searchKeyword) || $0.morph.title.contains(searchKeyword) }
        }
        
        let endIndex = min(request.startIndex+Rule.fetchPetCount, petList.count)
        return .init(totalPetCount: petList.count, startIndex: request.startIndex, petList: Array(petList[request.startIndex..<endIndex]))
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
    
    func updatePet(id: String, editPet: UpdatePetDTO) throws {
        guard let petId = try? ObjectId(string: id) else { return }
        guard let pet = realm.object(ofType: PetObject.self, forPrimaryKey: petId) else { throw RepositoryError.unknownPet }
        let imagePathList = editPet.imagePathList.map { "\(pet._id.stringValue)/\($0)" }
        try realm.write {
            pet.name = editPet.name
            pet.petClass = editPet.petClass
            pet.petSpecies = editPet.petSpecies
            pet.detailSpecies = editPet.detailSpecies
            pet.morph = editPet.morph
            pet.gender = editPet.gender
            pet.adoptionDate = editPet.adoptionDate
            pet.birthDate = editPet.birthDate
            pet.imagePathList.removeAll()
            pet.imagePathList.append(objectsIn: imagePathList)
        }
    }
    
    func deletePet(id: String) throws {
        guard let petId = try? ObjectId(string: id) else { return }
        guard let pet = realm.object(ofType: PetObject.self, forPrimaryKey: petId) else { throw RepositoryError.unknownPet }
        try realm.write {
            realm.delete(pet.weights)
            realm.delete(pet.tasks)
            realm.delete(pet)
        }
    }
    
}
