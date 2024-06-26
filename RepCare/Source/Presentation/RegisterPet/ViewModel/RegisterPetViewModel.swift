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
    let hatchDate: BehaviorRelay<Date?> = .init(value: nil)
    let currentWeight: BehaviorRelay<Double?> = .init(value: nil)
    let isLoading: PublishRelay<Bool> = .init()
    let diContainer: PetListSceneDIContainer
    
    var title: String {
        return "개체 등록"
    }
    var registerButtonTitle: String {
        return "등록"
    }
    
    lazy var canRegister = BehaviorRelay.combineLatest(petName, overPetSpecies, adoptionDate, gender) { name, petSpecies, adopDate, gender in
        return !name.isEmpty && (gender != nil) && (petSpecies != nil) && (adopDate != nil)
    }
    
    private let registerUseCase: DefaultRegisterPetUseCase?
    
    init(diContainer: PetListSceneDIContainer) {
        self.diContainer = diContainer
        registerUseCase = diContainer.makeRegisterUseCase()
    }
    
    func register() throws {
        isLoading.accept(true)
        let imageListData = petImageList.value.map({ image in
            guard let imageData = image.image.jpegData(compressionQuality: 1.0) else { fatalError() }
            return imageData
        })
        guard let petClass = overPetSpecies.value?.petClass else { return }
        guard let species = overPetSpecies.value?.petSpecies else { return }
        guard let adoptionDate = adoptionDate.value else { return }
        guard let gender = gender.value else { return }
        try registerUseCase?.registerPet(request: .init(name: petName.value, imageDataList: imageListData, petClass: petClass.toDomain(), petSpecies: species.toDomain(), detailSpecies: overPetSpecies.value?.detailSpecies?.toDomain(), morph: overPetSpecies.value?.morph?.toDomain(), adoptionDate: adoptionDate, birthDate: hatchDate.value, gender: gender.toDomain(), weight: currentWeight.value))
        isLoading.accept(false)
    }
    
    deinit {
        print("deinit RegisterPetViewModel")
    }
}
