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

struct RegisterPetQuery {
    let name: String
    let imagePath: [PetImage]
    let petClass: PetClass
    let petSpecies: Species
    let detailSpecies: DetailSpecies?
    let morph: Morph?
    let adoptionDate: Date
    let birthDate: Date?
    let gender: Gender
    let weight: Weight?
}

protocol PetRepository {
    typealias petId = String
    
    func registerPet(pet: RegisterPetQuery) throws -> petId
    func deletePet(pet: Pet)
    func fetchPetList(query: PetQuery, start: Int) -> PetRepositoryResponse
}
