//
//  FetchPetListDTO.swift
//  RepCare
//
//  Created by JunHwan Kim on 2023/10/13.
//

import Foundation

struct FetchPetListRequestDTO {
    let startIndex: Int
    let petClass: PetClassObject?
    let petSpecies: PetSpeciesObject?
    let detailSpecies: DetailSpeciesObject?
    let morph: MorphObject?
    let gender: GenderType?
    let searchKeyword: String?
    
}

struct FetchPetListResponseDTO {
    let totalPetCount: Int
    let startIndex: Int
    let petList: [PetObject]
}
