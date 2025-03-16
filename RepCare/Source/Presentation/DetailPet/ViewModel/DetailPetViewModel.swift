//
//  DetailPetViewModel.swift
//  RepCare
//
//  Created by JunHwan Kim on 2023/10/15.
//

import Foundation
import RxCocoa

final class DetailPetViewModel {
    
    enum DetailPetTabBarType: CaseIterable {
        case calendar_timeLine
        case weight
        case petPhoto
        
        var title: String {
            switch self {
            case .calendar_timeLine:
                "캘린더 / 타임라인"
            case .weight:
                "무게"
            case .petPhoto:
                "개체 사진"
            }
        }
    }
    
    private let pet: BehaviorRelay<PetModel>
    var petDriver: Driver<PetModel> {
        return pet.asDriver()
    }
    var currentPet: PetModel {
        return pet.value
    }
    private let deleteUseCase: DeletePetUseCase
    let diContainer: PetListSceneDIContainer
    let petRepository: PetRepository
    var images: [PetImageModel] {
        return pet.value.imagePath
    }
    
    init(pet: PetModel, deleteUseCase: DeletePetUseCase, diContainer: PetListSceneDIContainer, petRepository: PetRepository) {
        self.pet = .init(value: pet)
        self.deleteUseCase = deleteUseCase
        self.diContainer = diContainer
        self.petRepository = petRepository
    }
    
    func fetchDetailPetInfo() throws {
        let fetchPetInfo = try petRepository.fetchPet(petId: pet.value.id)
        pet.accept(.init(pet: fetchPetInfo))
    }
    
    func deletePet() throws {
        try deleteUseCase.deletePet(petId: pet.value.id)
    }
}
