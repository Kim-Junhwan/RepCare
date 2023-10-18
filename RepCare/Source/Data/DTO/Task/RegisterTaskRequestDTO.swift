//
//  RegisterTaskRequestDTO.swift
//  RepCare
//
//  Created by JunHwan Kim on 2023/10/17.
//

import Foundation

struct RegisterTaskRequestDTO {
    let pet: PetObject
    let registerDate: Date
    let taskType: TaskType
    let memo: String?
}
