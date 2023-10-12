//
//  PetStorage.swift
//  RepCare
//
//  Created by JunHwan Kim on 2023/10/12.
//

import Foundation

protocol PetStorage {
    func registerPet(request: RegisterPetRequestDTO) throws -> PetObject
}