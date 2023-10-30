//
//  Task.swift
//  RepCare
//
//  Created by JunHwan Kim on 2023/10/17.
//

import Foundation

enum Task {
    case feed
    case clean
    case mating
    case molt
    case spawn
    case memo
}

struct DetailTask {
    let taskType: Task
    let id: String
    let description: String?
    let registerDate: Date
}
