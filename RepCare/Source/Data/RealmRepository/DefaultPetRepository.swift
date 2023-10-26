//
//  DefaultPetRepository.swift
//  RepCare
//
//  Created by JunHwan Kim on 2023/10/12.
//

import Foundation

final class DefaultPetRepository: PetRepository {
    
    let petStorage: PetStorage
    let speciesStorage: SpeciesStorage
    let weightStorage: WeightStorage
    
    init(petStorage: PetStorage, speciesStorage: SpeciesStorage, weightStorage: WeightStorage) {
        self.petStorage = petStorage
        self.speciesStorage = speciesStorage
        self.weightStorage = weightStorage
    }
    
    func registerPet(pet: RegisterPetQuery) throws -> petId {
        let petClass = speciesStorage.getPetClass(type: .init(petClass: pet.petClass))
        guard let species = speciesStorage.getSpecies(id: pet.petSpecies.id) else { fatalError("cant species") }
        let detailSpecies = pet.detailSpecies.flatMap { speciesStorage.getDetailSpecies(id:$0.id) }
        let morph = pet.morph.flatMap { speciesStorage.getMorph(id:$0.id) }
        let reqeustDTO = RegisterPetRequestDTO(pet: pet, petClass: petClass, petSpecies: species, detailSpecies: detailSpecies, morph: morph)
        let registerPet = try petStorage.registerPet(request: reqeustDTO)
        return registerPet._id.stringValue
    }
    
    func deletePet(petId: String) throws {
        try petStorage.deletePet(id: petId)
    }
    
    func updatePet(editPet: Pet) throws {
        let petClass = speciesStorage.getPetClass(type: .init(petClass: editPet.petClass))
        guard let species = speciesStorage.getSpecies(id: editPet.petSpecies.id) else { fatalError("cant species") }
        let detailSpecies = editPet.detailSpecies.flatMap { speciesStorage.getDetailSpecies(id:$0.id) }
        let morph = editPet.morph.flatMap { speciesStorage.getMorph(id:$0.id) }
        let reqeustDTO = UpdatePetDTO(pet: editPet, petClass: petClass, petSpecies: species, detailSpecies: detailSpecies, morph: morph)
        guard let pet = petStorage.fetchPet(id: editPet.id) else { throw RepositoryError.unknownPet }
        try petStorage.updatePet(id: editPet.id, editPet: reqeustDTO)
        
        guard let editAdoptionWeight = editPet.currentWeight else { return }
        if weightStorage.checkPetHasDataAtDate(pet: pet, date: editPet.adoptionDate) {
            try weightStorage.updateStroage(weightDTO: .init(pet: pet, weight: editAdoptionWeight, date: editPet.adoptionDate))
        } else {
            try weightStorage.registerWeight(weight: .init(pet: pet, weight: editAdoptionWeight, date: editPet.adoptionDate))
        }
    }
    
    func fetchPetList(query: FetchPetListQuery, start: Int) -> PetRepositoryResponse {
        let petClass = query.petClass == .all ? nil : speciesStorage.getPetClass(type: .init(petClass: query.petClass))
        let petSpecies = query.species.flatMap { speciesStorage.getSpecies(id:$0.id) }
        let detailSpecies = query.detailSpecies.flatMap { speciesStorage.getDetailSpecies(id:$0.id) }
        let morph = query.morph.flatMap { speciesStorage.getMorph(id:$0.id) }
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
    
    func fetchPet(petId: String) throws -> Pet {
        guard let petObj = petStorage.fetchPet(id: petId) else { throw RepositoryError.unknownPet }
        return petObj.toDomain()
    }
}
