//
//  UpdatePetDTO.swift
//  RepCare
//
//  Created by JunHwan Kim on 2023/10/26.
//

import Foundation

struct UpdatePetDTO {
    let name: String
    let imagePathList: [String]
    let gender: GenderType
    let petClass: PetClassObject
    let petSpecies: PetSpeciesObject
    let detailSpecies: DetailSpeciesObject?
    let morph: MorphObject?
    let adoptionDate: Date
    let birthDate: Date?
    let weight: WeightObject?
    
    init(pet: Pet, petClass: PetClassObject,petSpecies: PetSpeciesObject, detailSpecies: DetailSpeciesObject?, morph: MorphObject?) {
        self.name = pet.name
        self.imagePathList = pet.imageList.map { $0.imagePath }
        switch pet.gender {
        case .female:
            self.gender = GenderType.female
        case .male:
            self.gender = GenderType.male
        case .dontKnow:
            self.gender = GenderType.miss
        }
        self.petClass = petClass
        self.petSpecies = petSpecies
        self.detailSpecies = detailSpecies
        self.morph = morph
        self.adoptionDate = pet.adoptionDate
        self.birthDate = pet.birthDate
        self.weight = pet.currentWeight == nil ? nil : WeightObject(date: pet.adoptionDate, weight: pet.currentWeight ?? 0)
    }
}
