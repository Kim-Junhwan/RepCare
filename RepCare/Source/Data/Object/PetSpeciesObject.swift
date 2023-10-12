//
//  PetSpecies.swift
//  RepCare
//
//  Created by JunHwan Kim on 2023/10/01.
//

import RealmSwift

class PetSpeciesObject: Object {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted(originProperty: "species") var petClass: LinkingObjects<PetClassObject>
    @Persisted var title: String
    @Persisted var detailSpecies: List<DetailSpeciesObject>
    
    convenience init(species: String) {
        self.init()
        self.title = species
    }
    
    func toDomain() -> Species {
        return Species(id: _id.stringValue, species: title)
    }
}
