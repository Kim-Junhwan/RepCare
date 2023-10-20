//
//  DefaultTaskRepository.swift
//  RepCare
//
//  Created by JunHwan Kim on 2023/10/17.
//

import Foundation

enum TaskRepositoryError: Error {
    case unknownPet
}

final class DefaultTaskRepository: TaskRepository {
    
    let petStorage: PetStorage
    let taskStorage: TaskStorage
    
    init(petStorage: PetStorage, taskStorage: TaskStorage) {
        self.petStorage = petStorage
        self.taskStorage = taskStorage
    }
    
    func registerTask(query: RegisterTaskQuery) throws {
        if let pet = petStorage.fetchPet(id: query.petId) {
            let task: TaskType
            switch query.taskType {
            case .feed:
                task = .feed
            case .clean:
                task = .clean
            case .molt:
                task = .molt
            case .spawn:
                task = .spawn
            case .memo:
                task = .memo
            }
            try taskStorage.registerTask(request: .init(pet: pet, registerDate: query.registerDate, taskType: task, memo: query.memo))
        } else {
            throw TaskRepositoryError.unknownPet
        }
    }
    
    func fetchTaskListInDate(petId: String, date: Date) -> [DetailTask] {
        guard let petObj = petStorage.fetchPet(id: petId) else { return [] }
        let current = Calendar.current.dateComponents([.year,.month,.day], from: date)
        if let year = current.year, let month = current.month, let day = current.day {
            return taskStorage.fetchTaskListInMonth(request: .init(pet: petObj, month: month, year: year, day: day)).map { $0.toDomain() }
        }
        return []
    }
    
    func fetchTaskListInMonth(petId: String, month: Int, year: Int) -> Dictionary<Int, [DetailTask]> {
        guard let petObj = petStorage.fetchPet(id: petId) else { return [:] }
        let fetchTask = taskStorage.fetchTaskListInMonth(request: .init(pet: petObj, month: month, year: year, day: nil))
        var dict: [Int:[DetailTask]] = [:]
        fetchTask.forEach { task in
            let entityTask = task.toDomain()
            let date = Calendar.current.component(.day, from: entityTask.registerDate)
            if let _ = dict[date] {
                dict[date]?.append(entityTask)
            } else {
                dict[date] = [entityTask]
            }
        }
        return dict
    }
    
}
