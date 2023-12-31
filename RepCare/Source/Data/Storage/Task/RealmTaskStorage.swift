//
//  RealmTaskStorage.swift
//  RepCare
//
//  Created by JunHwan Kim on 2023/10/17.
//

import Foundation
import RealmSwift

final class RealmTaskStorage: TaskStorage {
    
    private let realm: Realm
    
    init(realm: Realm) {
        self.realm = realm
    }
    
    func registerTask(request: RegisterTaskRequestDTO) throws {
        let pet = request.pet
        try realm.write {
            pet.tasks.append(.init(registerDate: request.registerDate, memo: request.memo, taskType: request.taskType))
        }
    }
    
    func fetchTaskListInMonth(request: FetchTaskListDTO) -> [DetailTaskObject] {
        guard let firstDate = makeDate(year: request.year, month: request.month, day: request.day ?? 1, hour: 0, minute: 0, second: 0) else { return [] }
        let lastDate: Date
        if request.day == nil {
            lastDate = makeDate(year: request.year, month: request.month+1, day: 0, hour: 23, minute: 59, second: 59) ?? Date()
        } else {
            lastDate = makeDate(year: request.year, month: request.month, day: request.day ?? 1, hour: 23, minute: 59, second: 59) ?? Date()
        }
        let predicate = NSPredicate(format: "registerDate BETWEEN { %@, %@ }", argumentArray: [firstDate as NSDate, lastDate as NSDate])
        return Array(request.pet.tasks.filter(predicate)).reversed()
    }
    
    private func makeDate(year: Int, month: Int, day: Int, hour: Int, minute: Int, second: Int) -> Date? {
        var components = DateComponents()
        components.year = year
        components.month = month
        components.day = day
        components.hour = hour
        components.minute = minute
        components.second = second
        return Calendar.current.date(from: components)
    }
    
    func deleteTask(pet: PetObject, taskId: String) throws {
        let deleteTask = pet.tasks.filter { $0._id.stringValue == taskId }
        try realm.write {
            realm.delete(deleteTask)
        }
    }
}
