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
    var id: String
    var name: String
    let imageList: [PetImage]
    var petClass: PetClass
    var petSpecies: Species
    var detailSpecies: DetailSpecies?
    var morph: Morph?
    var adoptionDate: Date
    var birthDate: Date?
    var gender: Gender
    let currentWeight: Double?
}

struct PetImage {
    let imagePath: String
}
