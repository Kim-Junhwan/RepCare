//
//  RealmSpeciesStorage.swift
//  RepCare
//
//  Created by JunHwan Kim on 2023/10/08.
//

import Foundation
import RealmSwift

enum SpeciesStorageError: Error {
    case unknownSpecies
}

final class RealmSpeciesStorage {
    private let realm: Realm
    
    init(realm: Realm) {
        self.realm = realm
    }
}

extension RealmSpeciesStorage: SpeciesStorage {
    
    func fetchPetClass() -> PetClassResponseDTO {
        let fetchClasses = Array(realm.objects(PetClassObject.self)).map{$0.toDomain()}
        return PetClassResponseDTO(petClass: fetchClasses)
    }
    
    func fetchPetSpecies(request: SpeciesRequestDTO) -> SpeciesResponseDTO {
        guard let fetchSpecies = realm.objects(PetClassObject.self).where({ $0.title == request.petClassType }).first?.species.sorted(by: \.title) else { return .init(petSpecies: []) }
        return .init(petSpecies: Array(fetchSpecies))
    }
    
    func fetchDetailSpecies(request: DetailSpeciesRequestDTO) -> DetailSpeciesResponseDTO {
        guard let objectId = try? ObjectId(string: request.speciesId) else { return .init(detailSpeciesList: []) }
        guard let detailSpecies = realm.object(ofType: PetSpeciesObject.self, forPrimaryKey: objectId)?.detailSpecies.sorted(by: \.title) else { return .init(detailSpeciesList: []) }
        return .init(detailSpeciesList: Array(detailSpecies))
    }
    
    func fetchSpeciesMorph(request: MorphRequestDTO) -> MorphResponseDTO {
        guard let objectId = try? ObjectId(string: request.detailSpeciesId) else { return .init(morphList: []) }
        guard let morph = realm.object(ofType: DetailSpeciesObject.self, forPrimaryKey: objectId)?.morph.sorted(by: \.title) else { return .init(morphList: []) }
        return .init(morphList: Array(morph))
    }
    
    func registerNewSpecies(title: String, request: SpeciesRequestDTO) throws {
        guard let parentClass = realm.objects(PetClassObject.self).where({ $0.title == request.petClassType }).first else { return }
        try realm.write {
            parentClass.species.append(.init(species: title))
        }
    }
    
    func registerNewDetailSpecies(title: String, request: DetailSpeciesRequestDTO) throws {
        guard let objectId = try? ObjectId(string: request.speciesId) else { return }
        guard let parentSpecies = realm.object(ofType: PetSpeciesObject.self, forPrimaryKey: objectId) else { return }
        try realm.write {
            parentSpecies.detailSpecies.append(.init(detailSpecies: title))
        }
    }
    
    func registerNewMorph(title: String, request: MorphRequestDTO) throws {
        guard let objectId = try? ObjectId(string: request.detailSpeciesId) else { return }
        guard let parentDetailSpecies = realm.object(ofType: DetailSpeciesObject.self, forPrimaryKey: objectId) else { return }
        try realm.write {
            parentDetailSpecies.morph.append(.init(morph: title))
        }
    }
    
    private func makeObjectId(id: String) -> ObjectId {
        guard let id = try? ObjectId(string: id) else { return .init() }
        return id
    }
    
    func getPetClass(type: SpeciesRequestDTO) -> PetClassObject {
        guard let classObject = realm.objects(PetClassObject.self).where({ $0.title == type.petClassType }).first else { fatalError("Unknown Pet Class") }
        return classObject
    }
    
    func getSpecies(id: String) -> PetSpeciesObject? {
        return realm.object(ofType: PetSpeciesObject.self, forPrimaryKey: makeObjectId(id: id))
    }
    
    func getDetailSpecies(id: String) -> DetailSpeciesObject? {
        return realm.object(ofType: DetailSpeciesObject.self, forPrimaryKey: makeObjectId(id: id))
    }
    
    func getMorph(id: String) -> MorphObject? {
        return realm.object(ofType: MorphObject.self, forPrimaryKey: makeObjectId(id: id))
    }
    
    func updateSpecies(species: PetOverSpecies, id: String, title: String) throws {
        guard let id = try? ObjectId(string: id) else { return }
        switch species {
        case .species:
            guard let originSpecies = realm.object(ofType: PetSpeciesObject.self, forPrimaryKey: id) else { return }
            try realm.write { originSpecies.title = title }
        case .detailSpecies:
            guard let originDetailSpecies = realm.object(ofType: DetailSpeciesObject.self, forPrimaryKey: id) else { return }
            try realm.write { originDetailSpecies.title = title }
        case .morph:
            guard let originmorph = realm.object(ofType: MorphObject.self, forPrimaryKey: id) else { return }
            try realm.write { originmorph.title = title }
        default:
            throw SpeciesStorageError.unknownSpecies
        }
    }
    
    func deleteSpecies(species: PetOverSpecies, id: String) throws {
        guard let id = try? ObjectId(string: id) else { return }
        switch species {
        case .species:
            guard let originSpecies = realm.object(ofType: PetSpeciesObject.self, forPrimaryKey: id) else { return }
            try deleteSpecies(species: originSpecies)
        case .detailSpecies:
            guard let originDetailSpecies = realm.object(ofType: DetailSpeciesObject.self, forPrimaryKey: id) else { return }
            try deleteDetailSpecies(detailSpeceis: originDetailSpecies)
        case .morph:
            guard let originmorph = realm.object(ofType: MorphObject.self, forPrimaryKey: id) else { return }
            try deleteMorph(morph: originmorph)
        default:
            throw SpeciesStorageError.unknownSpecies
        }
    }
    
    private func deleteSpecies(species: PetSpeciesObject) throws {
       try species.detailSpecies.forEach { try deleteDetailSpecies(detailSpeceis: $0) }
        try realm.write {
            realm.delete(species)
        }
    }
    
    private func deleteDetailSpecies(detailSpeceis: DetailSpeciesObject) throws {
        try realm.write {
            realm.delete(detailSpeceis.morph)
            realm.delete(detailSpeceis)
        }
    }
    
    private func deleteMorph(morph: MorphObject) throws {
        try realm.write {
            realm.delete(morph)
        }
    }
    
    func checkSpeciesAlreadyExist(parentSpecies: PetOverSpecies, parentId: String , title: String) -> Bool {
        if parentSpecies == .petClass {
            let petClass: PetClass
            if parentId == "reptile" {
                petClass = .reptile
            } else if parentId == "arthropod" {
                petClass = .arthropod
            } else if parentId == "amphibia" {
                petClass = .amphibia
            }else if parentId == "mammalia" {
                petClass = .mammalia
            } else if parentId == "etc" {
                petClass = .etc
            } else {
                return false
            }
            let petClassObj = getPetClass(type: .init(petClass: petClass))
            return !petClassObj.species.contains(where: { $0.title == title })
        }
        guard let id = try? ObjectId(string: parentId) else { return false }
        switch parentSpecies {
        
        case .species:
            guard let speciesObj = realm.object(ofType: PetSpeciesObject.self, forPrimaryKey: id) else { return true }
            return !speciesObj.detailSpecies.contains { $0.title == title }
        case .detailSpecies:
            guard let detailSpeciesObj = realm.object(ofType: DetailSpeciesObject.self, forPrimaryKey: id) else { return true }
            return !detailSpeciesObj.morph.contains { $0.title == title }
        default:
            fatalError()
        }
    }
}
