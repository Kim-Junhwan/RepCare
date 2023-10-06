//
//  Pet.swift
//  RepCare
//
//  Created by JunHwan Kim on 2023/10/01.
//

import Foundation

struct PetPage {
    var currentPage: Int
    var totalPage: Int
    var petList: [Pet]
}

struct Pet {
    var id: Int
    var name: String
    var petClass: PetClass
    var petSpecies: Species
    var morph: Morph
    var adoptionDate: Date
    var birthDate: Date
    var gender: Gender
}
