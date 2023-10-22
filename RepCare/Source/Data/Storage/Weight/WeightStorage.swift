//
//  WeightStorage.swift
//  RepCare
//
//  Created by JunHwan Kim on 2023/10/22.
//

import Foundation

protocol WeightStorage {
    func registerWeight(weight: WeightDTO) throws
    func fetchWeightList(pet: PetObject) -> [WeightObject]
}
