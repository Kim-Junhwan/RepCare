//
//  PetObject.swift
//  RepCare
//
//  Created by JunHwan Kim on 2023/10/01.
//

import RealmSwift
import Foundation

class PetObject: Object {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var name: String
    @Persisted var gender: Gender
    @Persisted var species: PetSpeciesObject?
    @Persisted var adoptionDate: Date
    @Persisted var birthDate: Date
    @Persisted var weights: List<WeightObject>
    
    convenience init(name: String, gender: Gender, species: PetSpeciesObject, birthDate: Date, adoptionDate: Date) {
        self.init()
        self.name = name
        self.gender = gender
        self.species = species
        self.adoptionDate = adoptionDate
        self.birthDate = birthDate
    }
}

enum Gender: String, PersistableEnum {
    case female
    case male
    case miss
}
