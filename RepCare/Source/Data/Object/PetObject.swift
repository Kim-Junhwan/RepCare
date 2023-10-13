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
    
    @Persisted var imagePathList: List<String>
    @Persisted var adoptionDate: Date
    @Persisted var weights: List<WeightObject>
    @Persisted var birthDate: Date?
    
    convenience init(name:String, gender: GenderType, petClass: PetClassObject, petSpecies: PetSpeciesObject, detailSpecies: DetailSpeciesObject?, morph: MorphObject?, adoptionDate: Date, weights: WeightObject?, birthDate: Date?, imagePathList: [String]) {
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
        self.imagePathList.append(objectsIn: imagePathList)
    }
    
    func toDomain() -> Pet {
        guard let petClass = petClass?.toDomain() else { fatalError("Unknown PetClass") }
        guard let petSpecies = petSpecies?.toDomain() else { fatalError("") }
        return .init(id: _id.stringValue, name: name, imageList: imagePathList.map{.init(imagePath: $0)}, petClass: petClass, petSpecies: petSpecies, detailSpecies: detailSpecies?.toDomain(), morph: morph?.toDomain(), adoptionDate: adoptionDate, birthDate: birthDate , gender: gender.toDomain())
    }
}

enum GenderType: String, PersistableEnum {
    case female
    case male
    case miss
    
    func toDomain() -> Gender {
        switch self {
        case .female:
            return .female
        case .male:
            return .male
        case .miss:
            return .dontKnow
        }
    }
}
