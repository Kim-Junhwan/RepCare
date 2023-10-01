//
//  PetSpecies.swift
//  RepCare
//
//  Created by JunHwan Kim on 2023/10/01.
//

import RealmSwift

class PetSpeciesObject: Object {
    @Persisted(originProperty: "species") var petClass: LinkingObjects<PetClassObject>
    @Persisted var species: String
    
    convenience init(species: String) {
        self.init()
        self.species = species
    }
}
