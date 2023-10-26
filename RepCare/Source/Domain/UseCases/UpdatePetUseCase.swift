//
//  UpdatePetUseCase.swift
//  RepCare
//
//  Created by JunHwan Kim on 2023/10/26.
//

import Foundation

protocol UpdatePetUseCase {
    func updatePet(request: UpdatePetRequest) throws
}

struct UpdatePetRequest {
    let id: String
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

final class DefaultUpdatePetUseCase: UpdatePetUseCase {
    
    let petRepository: PetRepository
    let imageRepository: PetImageRepository
    
    init(petRepository: PetRepository, imageRepository: PetImageRepository) {
        self.petRepository = petRepository
        self.imageRepository = imageRepository
    }
    
    func updatePet(request: UpdatePetRequest) throws {
        
        let imageList: [PetImage] = request.imageDataList.enumerated().map { .init(imagePath: "\($0.offset)") }
        
        try imageRepository.deletePetImage(petId: request.id)
        try imageRepository.savePetImage(petId: request.id, petImageList: request.imageDataList)
        try petRepository.updatePet(editPet: .init(id: request.id, name: request.name, imageList: imageList, petClass: request.petClass, petSpecies: request.petSpecies, detailSpecies: request.detailSpecies, morph: request.morph, adoptionDate: request.adoptionDate, gender: request.gender, currentWeight: request.weight))
    }
    
}
