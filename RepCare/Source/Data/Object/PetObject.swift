//
//  PetObject.swift
//  RepCare
//
//  Created by JunHwan Kim on 2023/10/01.
//

import RealmSwift
import Foundation

class PetObject: Object {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var name: String
    @Persisted var gender: GenderType
    @Persisted var petClass: PetClassObject?
    @Persisted var petSpecies: PetSpeciesObject?
    @Persisted var detailSpecies: DetailSpeciesObject?
    @Persisted var morph: MorphObject?
    
    @Persisted var adoptionDate: Date
    @Persisted var weights: List<WeightObject>
    @Persisted var birthDate: Date?
    
    convenience init(name:String, gender: GenderType, petClass: PetClassObject, petSpecies: PetSpeciesObject, detailSpecies: DetailSpeciesObject?, morph: MorphObject?, adoptionDate: Date, weights: WeightObject?, birthDate: Date?) {
        self.init()
        self.name = name
        self.gender = gender
        self.petClass = petClass
        self.petSpecies = petSpecies
        self.detailSpecies = detailSpecies
        self.morph = morph
        self.adoptionDate = adoptionDate
        if let weights = weights {
            self.weights.append(weights)
        }
        self.birthDate = birthDate
    }
}

enum GenderType: String, PersistableEnum {
    case female
    case male
    case miss
}
