//
//  MorphReqeust+ResponseDTO.swift
//  RepCare
//
//  Created by JunHwan Kim on 2023/10/08.
//

import Foundation

struct MorphRequestDTO {
    let detailSpeciesId: String
}

struct MorphResponseDTO {
    let morphList: [MorphObject]
}

