//
//  SpeciesStorage.swift
//  RepCare
//
//  Created by JunHwan Kim on 2023/10/08.
//

import Foundation

protocol SpeciesStorage {
    func fetchPetClass() -> PetClassResponseDTO
    func fetchPetSpecies(request: SpeciesRequestDTO) -> SpeciesResponseDTO
    func fetchDetailSpecies(request: DetailSpeciesRequestDTO) -> DetailSpeciesResponseDTO
    func fetchSpeciesMorph(request: MorphRequestDTO) -> MorphResponseDTO
    func getPetClass(type: SpeciesRequestDTO) -> PetClassObject
    func getSpecies(id: String) -> PetSpeciesObject?
    func getDetailSpecies(id: String) -> DetailSpeciesObject?
    func getMorph(id: String) -> MorphObject?
    func registerNewSpecies(title: String, request: SpeciesRequestDTO) throws
    func registerNewDetailSpecies(title: String, request: DetailSpeciesRequestDTO) throws
    func registerNewMorph(title: String, request: MorphRequestDTO) throws
    func updateSpecies(species: PetOverSpecies, id: String, title: String) throws
    func deleteSpecies(species: PetOverSpecies, id: String) throws
}
