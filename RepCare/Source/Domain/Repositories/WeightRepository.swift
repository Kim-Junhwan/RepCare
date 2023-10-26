//
//  WeightRepository.swift
//  RepCare
//
//  Created by JunHwan Kim on 2023/10/22.
//

import Foundation

protocol WeightRepository {
    typealias hasData = Bool
    func registerWeight(petId: String, date: Date, weight: Double) throws
    func fetchAllWeight(petId: String) -> [Weight]
    func updateWeightAtDate(petId: String, date: Date, weight: Double) throws
    func checkRegisterWeightInDay(petId: String, date: Date) -> hasData
    func deleteWeight(weightId: String) throws
}
