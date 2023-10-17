//
//  TaskObject.swift
//  RepCare
//
//  Created by JunHwan Kim on 2023/10/17.
//

import RealmSwift

enum TaskType: String, PersistableEnum {
    case feed
    case clean
    case molt
    case spawn
    case memo
}


