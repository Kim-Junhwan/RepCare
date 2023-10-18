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
    
    func toDomain() -> Task {
        switch self {
        case .feed:
            return .feed
        case .clean:
            return .clean
        case .molt:
            return .molt
        case .spawn:
            return .spawn
        case .memo:
            return .memo
        }
    }
}

class DetailTaskObject: Object {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var taskType: TaskType
    @Persisted var memo: String?
    @Persisted var registerDate: Date
    @Persisted(originProperty: "tasks") var pet: LinkingObjects<PetObject>
    
    convenience init(registerDate: Date, memo: String?, taskType: TaskType) {
        self.init()
        self.registerDate = registerDate
        self.memo = memo
        self.taskType = taskType
    }
    
    func toDomain() -> DetailTask {
        return .init(taskType: taskType.toDomain(), id: _id.stringValue, description: memo, registerDate: registerDate.convertDateToKoreaLocale())
    }
}
