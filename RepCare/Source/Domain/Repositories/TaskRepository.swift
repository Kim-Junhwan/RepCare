//
//  TaskRepository.swift
//  RepCare
//
//  Created by JunHwan Kim on 2023/10/17.
//

import Foundation

protocol TaskRepository {
    func registerTask(query: RegisterTaskQuery) throws
    func fetchTaskListInDate(petId: String ,date: Date) -> [DetailTask]
    func fetchTaskListInMonth(petId: String, month: Int, year: Int) -> Dictionary<Int, [DetailTask]>
}
