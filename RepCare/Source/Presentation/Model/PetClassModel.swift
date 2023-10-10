//
//  PetClassModel.swift
//  RepCare
//
//  Created by JunHwan Kim on 2023/10/09.
//

import UIKit

enum PetClassModel: Int, CaseIterable {
    case all
    case reptile
    case arthropod
    case amphibia
    case mammalia
    case etc
    
    var title: String {
        switch self {
        case .all:
            return "모든 개체"
        case .reptile:
            return "파충류"
        case .arthropod:
            return "절지류"
        case .amphibia:
            return "양서류"
        case .mammalia:
            return "포유류"
        case .etc:
            return "기타"
        }
    }
    
    // 추후 사용할 이미지가 구해지면 수정
    var image: UIImage? {
        return UIImage(systemName: "star")
    }
    
    init(petClass: PetClass) {
        switch petClass {
        case .all:
            self = .all
        case .reptile:
            self = .reptile
        case .arthropod:
            self = .arthropod
        case .amphibia:
            self = .amphibia
        case .mammalia:
            self = .mammalia
        case .etc:
            self = .etc
        }
    }
    
    func toDomain() -> PetClass {
        switch self {
        case .all:
            return .all
        case .reptile:
            return .reptile
        case .arthropod:
            return .arthropod
        case .amphibia:
            return .amphibia
        case .mammalia:
            return .mammalia
        case .etc:
            return .etc
        }
    }
}
