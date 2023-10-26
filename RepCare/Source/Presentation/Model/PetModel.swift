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
    let hatchDate: Date?
    let currentWeight: Double?
    
    init(id: String, imagePath: [PetImageModel], name: String, sex: GenderModel, overSpecies: PetOverSpeciesModel, adoptionDate: Date, hatchDate: Date?, currentWeight: Double?) {
        self.id = id
        self.imagePath = imagePath
        self.name = name
        self.sex = sex
        self.overSpecies = overSpecies
        self.adoptionDate = adoptionDate
        self.hatchDate = hatchDate
        self.currentWeight = currentWeight
    }
    
    init(pet: Pet) {
        self.id = pet.id
        self.adoptionDate = pet.adoptionDate
        self.imagePath = pet.imageList.map { .init(imagePath: $0.imagePath) }
        self.name = pet.name
        self.sex = .init(gender: pet.gender)
        self.overSpecies = .init(petClass: pet.petClass, species: pet.petSpecies, detailSpecies: pet.detailSpecies, morph: pet.morph)
        self.hatchDate = pet.birthDate
        self.currentWeight = pet.currentWeight
    }
}

struct PetImageModel {
    let imagePath: String
}
