//
//  RealmSpeciesRepository.swift
//  RepCare
//
//  Created by JunHwan Kim on 2023/10/07.
//

import Foundation

final class DefaultSpeciesRepository: SpeciesRepository {
    
    let speciesStroage: SpeciesStorage
    
    init(speciesStroage: SpeciesStorage) {
        self.speciesStroage = speciesStroage
    }
    
    func fetchPetClass() -> [PetClass] {
        let fetchClass = speciesStroage.fetchPetClass()
        return fetchClass.petClass
    }
    
    func fetchSpecies(petClass: PetClass) -> [Species] {
        let requestDTO = SpeciesRequestDTO(petClass: petClass)
        let fetchSpecies = speciesStroage.fetchPetSpecies(request: requestDTO)
        return fetchSpecies.petSpecies.map { $0.toDomain() }
    }
    
    func fetchDetailSpecies(species: Species) -> [DetailSpecies] {
        let requestDTO = DetailSpeciesRequestDTO(speciesId: species.id)
        let fetchDetailSpecies = speciesStroage.fetchDetailSpecies(request: requestDTO)
        
        return fetchDetailSpecies.detailSpeciesList.map { .init(id: $0._id.stringValue, detailSpecies: $0.title) }
    }
    
    func fetchMorph(detailSpecies: DetailSpecies) -> [Morph] {
        let requestDTO = MorphRequestDTO(detailSpeciesId: detailSpecies.id)
        let fetchMorph = speciesStroage.fetchSpeciesMorph(request: requestDTO)
        return fetchMorph.morphList.map { .init(id: $0._id.stringValue, morphName: $0.title) }
    }
    
    
    func registerNewSpecies(petSpecies: String, parentClass: PetClass) throws {
        let requestDTO = SpeciesRequestDTO(petClass: parentClass)
        try speciesStroage.registerNewSpecies(title: petSpecies, request: requestDTO)
    }
    
    func registerNewDetailSpecies(detailSpecies: String, parentSpecies: Species) throws {
        let requestDTO = DetailSpeciesRequestDTO(speciesId: parentSpecies.id)
        try speciesStroage.registerNewDetailSpecies(title: detailSpecies, request: requestDTO)
    }
    
    func registerNewMorph(petMorph: String, parentDetailSpecies: DetailSpecies) throws {
        let requestDTO = MorphRequestDTO(detailSpeciesId: parentDetailSpecies.id)
        try speciesStroage.registerNewMorph(title: petMorph, request: requestDTO)
    }
    
    func updateSpecies(species: PetOverSpecies, id: String, editTitle: String) throws {
        try speciesStroage.updateSpecies(species: species, id: id, title: editTitle)
    }
    
    func deleteSpecies(species: PetOverSpecies, id: String) throws {
        try speciesStroage.deleteSpecies(species: species, id: id)
    }
    
    func checkSpeciesContains(parentSpecies species: PetOverSpecies, parentId: String, title: String) -> Bool {
        return speciesStroage.checkSpeciesAlreadyExist(parentSpecies: species, parentId: parentId, title: title)
    }
}
