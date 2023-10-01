//
//  WeightObject.swift
//  RepCare
//
//  Created by JunHwan Kim on 2023/10/01.
//

import RealmSwift
import Foundation

class WeightObject: Object {
    @Persisted(originProperty: "weights") var pet: LinkingObjects<PetObject>
    @Persisted var date: Date
    @Persisted var weight: Double
    
    convenience init(date: Date, weight: Double) {
        self.init()
        self.date = date
        self.weight = weight
    }
}
