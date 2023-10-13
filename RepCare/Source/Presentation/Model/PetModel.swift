//
//  PetModel.swift
//  RepCare
//
//  Created by JunHwan Kim on 2023/10/09.
//

import Foundation

struct PetModel {
    let id: String
    let imagePath: [PetImageModel]
    let name: String
    let sex: GenderModel
    let overSpecies: PetOverSpeciesModel
    
    init(id: String, imagePath: [PetImageModel], name: String, sex: GenderModel, overSpecies: PetOverSpeciesModel) {
        self.id = id
        self.imagePath = imagePath
        self.name = name
        self.sex = sex
        self.overSpecies = overSpecies
    }
    
    init(pet: Pet) {
        self.id = pet.id
        self.imagePath = pet.imageList.map { .init(imagePath: $0.imagePath) }
        self.name = pet.name
        self.sex = .init(gender: pet.gender)
        self.overSpecies = .init(petClass: pet.petClass, species: pet.petSpecies, detailSpecies: pet.detailSpecies, morph: pet.morph)
    }
}

struct PetImageModel {
    let imagePath: String
}
