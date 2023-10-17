//
//  TaskObject.swift
//  RepCare
//
//  Created by JunHwan Kim on 2023/10/17.
//

import RealmSwift
import Foundation

enum TaskType: String, PersistableEnum {
    case feed
    case clean
    case molt
    case spawn
    case memo
}

class DetailTaskObject: Object {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var taskType: TaskType
    @Persisted var memo: String
    @Persisted var registerDate: Date
    @Persisted(originProperty: "tasks") var pet: LinkingObjects<PetObject>
}
