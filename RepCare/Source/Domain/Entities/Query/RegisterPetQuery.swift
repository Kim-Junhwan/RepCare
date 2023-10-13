//
//  RegisterPetQuery.swift
//  RepCare
//
//  Created by JunHwan Kim on 2023/10/13.
//

import Foundation

struct RegisterPetQuery {
    let name: String
    let imagePath: [PetImage]
    let petClass: PetClass
    let petSpecies: Species
    let detailSpecies: DetailSpecies?
    let morph: Morph?
    let adoptionDate: Date
    let birthDate: Date?
    let gender: Gender
    let weight: Weight?
}
