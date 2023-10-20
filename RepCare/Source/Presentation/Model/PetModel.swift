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
    let adoptionDate: Date
    
    init(id: String, imagePath: [PetImageModel], name: String, sex: GenderModel, overSpecies: PetOverSpeciesModel, adoptionDate: Date) {
        self.id = id
        self.imagePath = imagePath
        self.name = name
        self.sex = sex
        self.overSpecies = overSpecies
        self.adoptionDate = adoptionDate
    }
    
    init(pet: Pet) {
        self.id = pet.id
        self.adoptionDate = pet.adoptionDate
        self.imagePath = pet.imageList.map { .init(imagePath: $0.imagePath) }
        self.name = pet.name
        self.sex = .init(gender: pet.gender)
        self.overSpecies = .init(petClass: pet.petClass, species: pet.petSpecies, detailSpecies: pet.detailSpecies, morph: pet.morph)
    }
}

struct PetImageModel {
    let imagePath: String
}
