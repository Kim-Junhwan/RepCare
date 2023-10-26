//
//  PetStorage.swift
//  RepCare
//
//  Created by JunHwan Kim on 2023/10/12.
//

import Foundation

protocol PetStorage {
    func registerPet(request: RegisterPetRequestDTO) throws -> PetObject
    func fetchPetList(request: FetchPetListRequestDTO) -> FetchPetListResponseDTO
    func fetchPet(id: String) -> PetObject?
    func deletePet(id: String) throws
    func updatePet(id: String ,editPet: UpdatePetDTO) throws
}
