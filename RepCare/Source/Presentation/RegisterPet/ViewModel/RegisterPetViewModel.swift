//
//  RegisterPetViewModel.swift
//  RepCare
//
//  Created by JunHwan Kim on 2023/10/05.
//

import Foundation
import RxRelay
import RxSwift

class RegisterPetViewModel {
    
    let petImageList: BehaviorRelay<[PetImageItem]> = .init(value: [])
    let petName: BehaviorRelay<String> = .init(value: "")
    let overPetSpecies: BehaviorRelay<PetOverSpeciesModel?> = .init(value: nil)
    let gender: BehaviorRelay<GenderModel?> = .init(value: nil)
    let adoptionDate: BehaviorRelay<Date?> = .init(value: nil)
    var hatchDate: BehaviorRelay<Date?> = .init(value: nil)
    var currentWeight: BehaviorRelay<Double?> = .init(value: nil)
    let diContainer: PetListSceneDIContainer
    
    lazy var canRegister = BehaviorRelay.combineLatest(petName, overPetSpecies, adoptionDate, gender) { name, petSpecies, adopDate, gender in
        return !name.isEmpty && (gender != nil) && (petSpecies != nil) && (adopDate != nil)
    }
    
    private let registerUseCase: DefaultRegisterPetUseCase?
    
    init(diContainer: PetListSceneDIContainer) {
        self.diContainer = diContainer
        registerUseCase = diContainer.makeRegisterUseCase()
    }
    
    func register() throws {
        let imageListData = petImageList.value.map({ image in
            guard let imageData = image.image.pngData() else { fatalError() }
            return imageData
        })
        guard let petClass = overPetSpecies.value?.petClass else { return }
        guard let species = overPetSpecies.value?.petSpecies else { return }
        guard let adoptionDate = adoptionDate.value else { return }
        guard let gender = gender.value else { return }
        try registerUseCase?.registerPet(request: .init(name: petName.value, imageDataList: imageListData, petClass: petClass.toDomain(), petSpecies: species.toDomain(), detailSpecies: overPetSpecies.value?.detailSpecies?.toDomain(), morph: overPetSpecies.value?.morph?.toDomain(), adoptionDate: adoptionDate, birthDate: hatchDate.value, gender: gender.toDomain(), weight: currentWeight.value))
    }
    
    deinit {
        print("deinit RegisterPetViewModel")
    }
}
