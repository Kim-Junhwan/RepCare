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
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var title: PetClassType
    @Persisted var species: List<PetSpeciesObject>
    
    convenience init(petClass: PetClassType) {
        self.init()
        self.title = petClass
    }
    
    func toDomain() -> PetClass {
        switch title {
        case .reptile:
            return .reptile
        case .arthropod:
            return .arthropod
        case .amphibia:
            return .amphibia
        case .mammalia:
            return .mammalia
        case .etc:
            return .etc
        }
    }
}
