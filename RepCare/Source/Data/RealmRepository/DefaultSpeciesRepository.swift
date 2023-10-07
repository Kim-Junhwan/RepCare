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
    
    func registerNewSpecies(petSpecies: Species) throws {
        
    }
    
    func registerNewMorph(petMorph: Morph) throws {
        
    }
}
