//
//  PetClassItemViewModel.swift
//  RepCare
//
//  Created by JunHwan Kim on 2023/10/04.
//

import Foundation
import UIKit

enum PetClassItemViewModel: Int, CaseIterable {
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
}
