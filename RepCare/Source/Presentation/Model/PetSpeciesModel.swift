//
//  PetSpeciesModel.swift
//  RepCare
//
//  Created by JunHwan Kim on 2023/10/09.
//

import Foundation

struct PetSpeciesModel {
    let id: String
    let title: String
    
    init(petSpecies: Species) {
        self.id = petSpecies.id
        self.title = petSpecies.species
    }
    
    func toDomain() -> Species {
        return .init(id: id, species: title)
    }
}
