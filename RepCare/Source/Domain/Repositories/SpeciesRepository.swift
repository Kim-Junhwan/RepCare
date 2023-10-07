//
//  SpeciesRepository.swift
//  RepCare
//
//  Created by JunHwan Kim on 2023/10/05.
//

import Foundation

protocol SpeciesRepository {
    func fetchPetClass() -> [PetClass]
    func fetchSpecies(petClass: PetClass) -> [Species]
    func fetchMorph(petSpecies: Species) -> [Morph]
    func registerNewSpecies(petSpecies: Species) throws
    func registerNewMorph(petMorph: Morph) throws
}
