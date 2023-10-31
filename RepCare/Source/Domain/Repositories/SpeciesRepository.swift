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
    func fetchDetailSpecies(species: Species) -> [DetailSpecies]
    func fetchMorph(detailSpecies: DetailSpecies) -> [Morph]
    func registerNewSpecies(petSpecies: String, parentClass: PetClass) throws
    func registerNewDetailSpecies(detailSpecies: String, parentSpecies: Species) throws
    func registerNewMorph(petMorph: String, parentDetailSpecies: DetailSpecies) throws
    func updateSpecies(species: PetOverSpecies, id: String, editTitle: String) throws
    func deleteSpecies(species: PetOverSpecies, id: String) throws
    func checkSpeciesContains(parentSpecies: PetOverSpecies, parentId: String, title: String) -> Bool
}
