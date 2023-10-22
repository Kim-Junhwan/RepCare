//
//  WeightRepository.swift
//  RepCare
//
//  Created by JunHwan Kim on 2023/10/22.
//

import Foundation

protocol WeightRepository {
    func registerWeight(petId: String, weight: Weight) throws
    func fetchAllWeight(petId: String) -> [Weight]
}
