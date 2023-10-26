//
//  DetailPetViewModel.swift
//  RepCare
//
//  Created by JunHwan Kim on 2023/10/15.
//

import Foundation

final class DetailPetViewModel {
    
    let pet: PetModel
    private let deleteUseCase: DeletePetUseCase
    var images: [PetImageModel] {
        return pet.imagePath
    }
    
    init(pet: PetModel, deleteUseCase: DeletePetUseCase) {
        self.pet = pet
        self.deleteUseCase = deleteUseCase
    }
    
    func deletePet() throws {
        try deleteUseCase.deletePet(petId: pet.id)
    }
}
