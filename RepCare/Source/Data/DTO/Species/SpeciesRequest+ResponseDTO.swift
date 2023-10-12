//
//  SpeciesRequestDTO.swift
//  RepCare
//
//  Created by JunHwan Kim on 2023/10/07.
//

import Foundation

struct SpeciesRequestDTO {
    let petClassType: PetClassType
    
    init(petClass: PetClass) {
        switch petClass {
        case .reptile:
            petClassType = .reptile
        case .arthropod:
            petClassType = .arthropod
        case .amphibia:
            petClassType = .amphibia
        case .mammalia:
            petClassType = .mammalia
        case .etc:
            petClassType = .etc
        default:
            fatalError("Unknown PetClass")
        }
    }
    
}

struct SpeciesResponseDTO {
    let petSpecies: [PetSpeciesObject]
}
