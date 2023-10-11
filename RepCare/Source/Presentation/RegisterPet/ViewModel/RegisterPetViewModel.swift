//
//  RegisterPetViewModel.swift
//  RepCare
//
//  Created by JunHwan Kim on 2023/10/05.
//

import Foundation
import RxRelay
import RxSwift

final class RegisterPetViewModel {
    
    let petImageList: BehaviorRelay<[PetImageItem]> = .init(value: [])
    let petName: BehaviorRelay<String> = .init(value: "")
    let overPetSpecies: PublishRelay<PetOverSpeciesModel> = .init()
    let gender: PublishRelay<GenderModel> = .init()
    let adoptionDate: PublishRelay<Date> = .init()
    var hatchDate: PublishRelay<Date?> = .init()
    var currentWeight: PublishRelay<Double?> = .init()
    
    lazy var canRegister = BehaviorRelay.combineLatest(petName, overPetSpecies, adoptionDate, gender) { name, _, _, _ in
        return !name.isEmpty
    }
}
