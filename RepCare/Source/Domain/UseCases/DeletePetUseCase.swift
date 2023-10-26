//
//  DeletePetUseCase.swift
//  RepCare
//
//  Created by JunHwan Kim on 2023/10/26.
//

import Foundation

protocol DeletePetUseCase {
    func deletePet(petId: String) throws
}

final class DefaultDeletePetUseCase: DeletePetUseCase {
    
    let petImageRepository: PetImageRepository
    let petRepository: PetRepository
    
    init(petImageRepository: PetImageRepository, petRepository: PetRepository) {
        self.petImageRepository = petImageRepository
        self.petRepository = petRepository
    }
    
    func deletePet(petId: String) throws {
        try petImageRepository.deletePetImage(petId: petId)
        try petRepository.deletePet(petId: petId)
    }
    
}
