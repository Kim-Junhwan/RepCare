//
//  DefaultPetRepository.swift
//  RepCare
//
//  Created by JunHwan Kim on 2023/10/12.
//

import Foundation

final class DefaultPetRepository: PetRepository {
    
    let petStorage: PetStorage
    let speciesStroage: SpeciesStorage
    
    init(petStorage: PetStorage, speciesStroage: SpeciesStorage) {
        self.petStorage = petStorage
        self.speciesStroage = speciesStroage
    }
    
    func registerPet(pet: RegisterPetQuery) throws -> petId {
        let petClass = speciesStroage.getPetClass(type: .init(petClass: pet.petClass))
        guard let species = speciesStroage.getSpecies(id: pet.petSpecies.id) else { fatalError("cant species") }
        let detailSpecies = pet.detailSpecies == nil ? nil : speciesStroage.getDetailSpecies(id: pet.detailSpecies?.id ?? "")
        let morph = pet.morph == nil ? nil : speciesStroage.getMorph(id: pet.morph?.id ?? "")
        let reqeustDTO = RegisterPetRequestDTO(pet: pet, petClass: petClass, petSpecies: species, detailSpecies: detailSpecies, morph: morph)
        let registerPet = try petStorage.registerPet(request: reqeustDTO)
        return registerPet._id.stringValue
    }
    
    func deletePet(pet: Pet) {
        
    }
    
    func fetchPetList(query: PetQuery, start: Int) -> PetRepositoryResponse {
        return .init(totalPetCount: 0, start: 0, petList: [])
    }
    
    
}
