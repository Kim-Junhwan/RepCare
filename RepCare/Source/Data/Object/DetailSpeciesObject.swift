//
//  DetailSpeciesObject.swift
//  RepCare
//
//  Created by JunHwan Kim on 2023/10/05.
//

import RealmSwift

class DetailSpeciesObject: Object {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted(originProperty: "detailSpecies") var petClass: LinkingObjects<PetSpeciesObject>
    @Persisted var title: String
    @Persisted var morph: List<MorphObject>
    
    convenience init(detailSpecies: String) {
        self.init()
        self.title = detailSpecies
    }
    
    func toDomain() -> DetailSpecies {
        return .init(id: _id.stringValue, detailSpecies: title)
    }
}
