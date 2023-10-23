//
//  RegisterPetUseCase.swift
//  RepCare
//
//  Created by JunHwan Kim on 2023/10/11.
//

import Foundation

protocol RegisterPetUseCase {
    func registerPet(request: RegisterPetRequest) throws
}

struct RegisterPetRequest {
    let name: String
    let imageDataList: [Data]
    let petClass: PetClass
    let petSpecies: Species
    let detailSpecies: DetailSpecies?
    let morph: Morph?
    let adoptionDate: Date
    let birthDate: Date?
    let gender: Gender
    let weight: Double?
}

final class DefaultRegisterPetUseCase {
    let petRepository: PetRepository
    let petImageRepository: PetImageRepository
    
    init(petRepository: PetRepository, petImageRepository: PetImageRepository) {
        self.petRepository = petRepository
        self.petImageRepository = petImageRepository
    }
}

extension DefaultRegisterPetUseCase: RegisterPetUseCase {
    func registerPet(request: RegisterPetRequest) throws {
        let registerPetId =
        try petRepository.registerPet(pet: .init(name: request.name,
                                                 imagePath: request.imageDataList.enumerated().map { .init(imagePath: "\($0.offset)") }
                                                 ,petClass: request.petClass,
                                                 petSpecies: request.petSpecies,
                                                 detailSpecies: request.detailSpecies,
                                                 morph: request.morph,
                                                 adoptionDate: request.adoptionDate,
                                                 birthDate: request.birthDate,
                                                 gender: request.gender,
                                                 weight: request.weight))
        try petImageRepository.savePetImage(petId: registerPetId, petImageList: request.imageDataList
        )
    }
}
