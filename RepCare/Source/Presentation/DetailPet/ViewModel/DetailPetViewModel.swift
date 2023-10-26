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
    let diContainer: PetListSceneDIContainer
    var images: [PetImageModel] {
        return pet.imagePath
    }
    
    init(pet: PetModel, deleteUseCase: DeletePetUseCase, diContainer: PetListSceneDIContainer) {
        self.pet = pet
        self.deleteUseCase = deleteUseCase
        self.diContainer = diContainer
    }
    
    func deletePet() throws {
        try deleteUseCase.deletePet(petId: pet.id)
    }
}
