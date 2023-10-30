//
//  TaskStorage.swift
//  RepCare
//
//  Created by JunHwan Kim on 2023/10/17.
//

import Foundation

protocol TaskStorage {
    func registerTask(request: RegisterTaskRequestDTO) throws
    func fetchTaskListInMonth(request: FetchTaskListDTO) -> [DetailTaskObject]
    func deleteTask(pet: PetObject, taskId: String) throws
}
