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

protocol PetRepository {
    typealias petId = String
    
    func registerPet(pet: RegisterPetQuery) throws -> petId
    func deletePet(pet: Pet)
    func fetchPetList(query: FetchPetListQuery, start: Int) -> PetRepositoryResponse
}
