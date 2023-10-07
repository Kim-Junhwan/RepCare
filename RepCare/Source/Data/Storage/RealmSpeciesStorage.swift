//
//  RealmSpeciesStorage.swift
//  RepCare
//
//  Created by JunHwan Kim on 2023/10/08.
//

import Foundation
import RealmSwift

final class RealmSpeciesStorage {
    private let realm: Realm? = {
        guard let realmPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("repcare.realm", conformingTo: .data) else {fatalError()}
        let bundleRealm = try! Realm(fileURL: realmPath)
        return bundleRealm
    }()
}

extension RealmSpeciesStorage: SpeciesStorage {
    
    
    
    func fetchPetClass() -> PetClassResponseDTO {
        guard let realm else { return .init(petClass: []) }
        let fetchClasses = Array(realm.objects(PetClassObject.self)).map{$0.toDomain()}
        return PetClassResponseDTO(petClass: fetchClasses)
    }
    
    func fetchPetSpecies(request: SpeciesRequestDTO) -> SpeciesResponseDTO {
        guard let realm else { return .init(petSpecies: []) }
        guard let fetchSpecies = realm.objects(PetClassObject.self).where({ $0.title == request.petClassType }).first?.species else { return .init(petSpecies: []) }
        return .init(petSpecies: Array(fetchSpecies))
    }
    
    func fetchDetailSpecies(request: DetailSpeciesRequestDTO) -> DetailSpeciesResponseDTO {
        guard let realm, let objectId = try? ObjectId(string: request.speciesId) else { return .init(detailSpeciesList: []) }
        guard let detailSpecies = realm.object(ofType: PetSpeciesObject.self, forPrimaryKey: objectId)?.detailSpecies else { return .init(detailSpeciesList: []) }
        return .init(detailSpeciesList: Array(detailSpecies))
    }
    
    func fetchSpeciesMorph(request: MorphRequestDTO) -> MorphResponseDTO {
        guard let realm, let objectId = try? ObjectId(string: request.detailSpeciesId) else { return .init(morphList: []) }
        guard let morph = realm.object(ofType: DetailSpeciesObject.self, forPrimaryKey: objectId)?.morph else { return .init(morphList: []) }
        return .init(morphList: Array(morph))
    }
    
}
