//
//  MorphObject.swift
//  RepCare
//
//  Created by JunHwan Kim on 2023/10/06.
//

import RealmSwift

class MorphObject: Object {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted(originProperty: "morph") var petClass: LinkingObjects<DetailSpeciesObject>
    @Persisted var title: String
    
    convenience init(morph: String) {
        self.init()
        self.title = morph
    }
    
    func toDomain() -> Morph {
        return .init(id: _id.stringValue, morphName: title)
    }
}
