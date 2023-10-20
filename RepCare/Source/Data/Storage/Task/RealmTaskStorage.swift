//
//  RealmTaskStorage.swift
//  RepCare
//
//  Created by JunHwan Kim on 2023/10/17.
//

import Foundation
import RealmSwift

final class RealmTaskStorage: TaskStorage {
    
    private let realm: Realm? = {
        guard let realmPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("repcare.realm", conformingTo: .data) else {fatalError()}
        let bundleRealm = try? Realm(fileURL: realmPath)
        return bundleRealm
    }()
    
    func registerTask(request: RegisterTaskRequestDTO) throws {
        guard let realm else { return }
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
    
    
}
