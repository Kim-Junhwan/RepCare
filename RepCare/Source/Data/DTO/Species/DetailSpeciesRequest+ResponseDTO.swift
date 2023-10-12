//
//  DetailSpeciesRequestDTO.swift
//  RepCare
//
//  Created by JunHwan Kim on 2023/10/08.
//

import Foundation

struct DetailSpeciesRequestDTO {
    let speciesId: String
}

struct DetailSpeciesResponseDTO {
    let detailSpeciesList: [DetailSpeciesObject]
}
