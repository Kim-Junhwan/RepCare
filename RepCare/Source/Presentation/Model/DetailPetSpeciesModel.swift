//
//  DetailPetSpeciesModel.swift
//  RepCare
//
//  Created by JunHwan Kim on 2023/10/09.
//

import Foundation

struct DetailPetSpeciesModel {
    let id: String
    let title: String
    
    init(id: String, title: String) {
        self.id = id
        self.title = title
    }
    
    init(detailSpecies: DetailSpecies) {
        self.id = detailSpecies.id
        self.title = detailSpecies.detailSpecies
    }
    
    func toDomain() -> DetailSpecies {
        return .init(id: id, detailSpecies: title)
    }
}
