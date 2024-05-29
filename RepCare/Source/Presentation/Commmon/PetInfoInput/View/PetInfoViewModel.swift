//
//  PetInfoViewModel.swift
//  RepCare
//
//  Created by JunHwan Kim on 2024/05/29.
//

import Foundation
import RxSwift
import RxCocoa

class PetInfoViewModel {
    let petImageList: BehaviorRelay<[PetImageItem]> = .init(value: [])
    let petName: BehaviorRelay<String> = .init(value: "")
    let overPetSpecies: BehaviorRelay<PetOverSpeciesModel?> = .init(value: nil)
    let gender: BehaviorRelay<GenderModel?> = .init(value: nil)
    let adoptionDate: BehaviorRelay<Date?> = .init(value: nil)
    var hatchDate: BehaviorRelay<Date?> = .init(value: nil)
    var currentWeight: BehaviorRelay<Double?> = .init(value: nil)
}
