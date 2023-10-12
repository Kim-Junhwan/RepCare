//
//  MorphModel.swift
//  RepCare
//
//  Created by JunHwan Kim on 2023/10/09.
//

import Foundation

struct MorphModel {
    let id: String
    let title: String
    
    init(morph: Morph) {
        self.id = morph.id
        self.title = morph.morphName
    }
    
    func toDomain() -> Morph {
        return .init(id: id, morphName: title)
    }
}
