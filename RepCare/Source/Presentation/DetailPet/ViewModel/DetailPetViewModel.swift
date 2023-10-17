//
//  DetailPetViewModel.swift
//  RepCare
//
//  Created by JunHwan Kim on 2023/10/15.
//

import Foundation

final class DetailPetViewModel {
    
    let pet: PetModel
    var images: [PetImageModel] {
        return pet.imagePath
    }
    
    init(pet: PetModel) {
        self.pet = pet
    }
}
