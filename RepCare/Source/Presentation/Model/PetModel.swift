//
//  PetModel.swift
//  RepCare
//
//  Created by JunHwan Kim on 2023/10/09.
//

import Foundation

struct PetModel {
    let imagPath: [PetImageModel]
    let name: String
    let sex: Gender
    let species: String
    let morph: String?
}

struct PetImageModel {
    let imagePath: String
}