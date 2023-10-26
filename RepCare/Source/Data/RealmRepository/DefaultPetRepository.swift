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
        let detailSpecies = pet.detailSpecies.flatMap { speciesStroage.getDetailSpecies(id:$0.id) }
        let morph = pet.morph.flatMap { speciesStroage.getMorph(id:$0.id) }
        let reqeustDTO = RegisterPetRequestDTO(pet: pet, petClass: petClass, petSpecies: species, detailSpecies: detailSpecies, morph: morph)
        let registerPet = try petStorage.registerPet(request: reqeustDTO)
        return registerPet._id.stringValue
    }
    
    func deletePet(petId: String) throws {
        try petStorage.deletePet(id: petId)
    }
    
    func fetchPetList(query: FetchPetListQuery, start: Int) -> PetRepositoryResponse {
        let petClass = query.petClass == .all ? nil : speciesStroage.getPetClass(type: .init(petClass: query.petClass))
        let petSpecies = query.species.flatMap { speciesStroage.getSpecies(id:$0.id) }
        let detailSpecies = query.detailSpecies.flatMap { speciesStroage.getDetailSpecies(id:$0.id) }
        let morph = query.morph.flatMap { speciesStroage.getMorph(id:$0.id) }
        let gender = query.gender.flatMap { gender in
            switch gender {
            case .female:
                return GenderType.female
            case .male:
                return GenderType.male
            case .dontKnow:
                return GenderType.miss
            }
        }
        let requestDTO = FetchPetListRequestDTO(startIndex: start, petClass: petClass, petSpecies: petSpecies, detailSpecies: detailSpecies, morph: morph, gender: gender, searchKeyword: query.searchKeyword)
        let fetchList = petStorage.fetchPetList(request: requestDTO)
        return .init(totalPetCount: fetchList.totalPetCount, start: fetchList.startIndex, petList: fetchList.petList.map { $0.toDomain() })
    }
}
