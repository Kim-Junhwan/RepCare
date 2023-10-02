//
//  PetListRepository.swift
//  RepCare
//
//  Created by JunHwan Kim on 2023/10/01.
//

import Foundation
import RxSwift

struct PetRepositoryResponse {
    let totalPetCount: Int
    let start: Int
    let petList: [Pet]
}

struct PetQuery {
    let petClass: PetClass
    let species: PetSpecies?
    let searchKeyword: String?
}

protocol PetRepository {
    func fetchPetList(query: PetQuery, start: Int) -> PetRepositoryResponse
}
