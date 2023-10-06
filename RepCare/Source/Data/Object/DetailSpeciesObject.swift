//
//  DetailSpeciesObject.swift
//  RepCare
//
//  Created by JunHwan Kim on 2023/10/05.
//

import RealmSwift

class DetailSpeciesObject: Object {
    @Persisted(originProperty: "detailSpecies") var petClass: LinkingObjects<PetSpeciesObject>
    @Persisted var title: String
    @Persisted var morph: List<MorphObject>
    
    convenience init(detailSpecies: String) {
        self.init()
        self.title = detailSpecies
    }
}
