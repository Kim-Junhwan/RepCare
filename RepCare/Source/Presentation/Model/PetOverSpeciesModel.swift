//
//  PetOverSpecies.swift
//  RepCare
//
//  Created by JunHwan Kim on 2023/10/10.
//

import Foundation

struct PetOverSpeciesModel {
    let petClass: PetClassModel
    let petSpecies: PetSpeciesModel
    let detailSpecies: DetailPetSpeciesModel?
    let morph: MorphModel?
}
