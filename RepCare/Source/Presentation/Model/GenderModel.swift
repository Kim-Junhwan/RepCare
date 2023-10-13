//
//  GenderModel.swift
//  RepCare
//
//  Created by JunHwan Kim on 2023/10/09.
//

import Foundation

enum GenderModel: Int {
    case female = 0
    case male = 1
    case dontKnow = 2
    
    init(gender: Gender) {
        switch gender {
        case .female:
            self = .female
        case .male:
            self = .male
        case .dontKnow:
            self = .dontKnow
        }
    }
    
    func toDomain() -> Gender {
        switch self {
        case .female:
            return .female
        case .male:
            return .male
        case .dontKnow:
            return .dontKnow
        }
    }
}
