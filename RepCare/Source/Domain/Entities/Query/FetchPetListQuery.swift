//
//  FetchPetListQuery.swift
//  RepCare
//
//  Created by JunHwan Kim on 2023/10/13.
//

import Foundation

struct FetchPetListQuery {
    let petClass: PetClass
    let species: Species?
    let detailSpecies: DetailSpecies?
    let morph: Morph?
    let searchKeyword: String?
    let gender: Gender?
}
