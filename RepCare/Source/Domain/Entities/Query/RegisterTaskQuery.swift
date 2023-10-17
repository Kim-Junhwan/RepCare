//
//  RegisterTaskQuery.swift
//  RepCare
//
//  Created by JunHwan Kim on 2023/10/17.
//

import Foundation

struct RegisterTaskQuery {
    let petId: String
    let taskType: Task
    let registerDate: Date
    let memo: String?
}
