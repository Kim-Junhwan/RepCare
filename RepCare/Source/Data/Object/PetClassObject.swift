//
//  Pet.swift
//  RepCare
//
//  Created by JunHwan Kim on 2023/09/30.
//

import RealmSwift

enum PetClassType: String, PersistableEnum {
    case reptile
    case arthropod
    case amphibia
    case mammalia
    case etc
}

class PetClassObject: Object {
    @Persisted var title: PetClassType
    @Persisted var species: List<PetSpeciesObject>
    
    convenience init(petClass: PetClassType) {
        self.init()
        self.title = petClass
    }
}
