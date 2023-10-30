//
//  PetOverSpecies.swift
//  RepCare
//
//  Created by JunHwan Kim on 2023/10/10.
//

import Foundation

struct PetOverSpeciesModel {
    let petClass: PetClassModel?
    let petSpecies: PetSpeciesModel?
    let detailSpecies: DetailPetSpeciesModel?
    let morph: MorphModel?
    
    init(petClass: PetClassModel, petSpecies: PetSpeciesModel, detailSpecies: DetailPetSpeciesModel?, morph: MorphModel?) {
        self.petClass = petClass
        self.petSpecies = petSpecies
        self.detailSpecies = detailSpecies
        self.morph = morph
    }
    
    init(petClass: PetClassModel?, petSpecies: PetSpeciesModel?, detailSpecies: DetailPetSpeciesModel?, morph: MorphModel?) {
        self.petClass = petClass
        self.petSpecies = petSpecies
        self.detailSpecies = detailSpecies
        self.morph = morph
    }
    
    init(petClass: PetClass, species: Species, detailSpecies: DetailSpecies?, morph: Morph?) {
        self.petClass = PetClassModel(petClass: petClass)
        self.petSpecies = PetSpeciesModel(petSpecies: species)
        if let detailSpecies {
            self.detailSpecies = .init(detailSpecies: detailSpecies)
        } else {
            self.detailSpecies = nil
        }
        
        if let morph {
            self.morph = .init(morph: morph)
        } else {
            self.morph = nil
        }
    }
}
