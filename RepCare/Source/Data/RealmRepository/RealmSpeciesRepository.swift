//
//  RealmSpeciesRepository.swift
//  RepCare
//
//  Created by JunHwan Kim on 2023/10/07.
//

import Foundation
import RealmSwift

final class RealmSpeciesRepository: SpeciesRepository {
    
    private let realm: Realm? = {
        guard let realmPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("repcare.realm", conformingTo: .data) else {fatalError()}
        let bundleRealm = try! Realm(fileURL: realmPath)
        return bundleRealm
    }()
    
    func fetchPetClass() -> [PetClass] {
        guard let realm else { return [] }
        let fetchClasses = realm.objects(PetClassObject.self)
        return Array(fetchClasses).map{$0.toDomain()}
    }
    
    func fetchSpecies(petClass: PetClass) -> [Species] {
        return []
    }
    
    func fetchMorph(petSpecies: Species) -> [Morph] {
        return []
    }
    
    func registerNewSpecies(petSpecies: Species) throws {
        
    }
    
    func registerNewMorph(petMorph: Morph) throws {
        
    }
    
    
}
