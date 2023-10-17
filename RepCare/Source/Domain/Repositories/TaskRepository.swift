//
//  TaskRepository.swift
//  RepCare
//
//  Created by JunHwan Kim on 2023/10/17.
//

import Foundation

protocol TaskRepository {
    func registerTask(query: RegisterPetQuery)
}
