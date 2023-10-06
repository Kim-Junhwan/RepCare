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
    let species: Species?
    let searchKeyword: String?
}

protocol PetRepository {
    func registerPet(pet: Pet) throws
    func deletePet(pet: Pet)
    func fetchPetList(query: PetQuery, start: Int) -> PetRepositoryResponse
}
