//
//  DomainDIContainer.swift
//  RepCare
//
//  Created by JunHwan Kim on 2024/05/26.
//

import Foundation

final class DomainDIContainer {
    
    let dataContainer: DataContainer

    init(dataContainer: DataContainer) {
        self.dataContainer = dataContainer
    }
    
    //MARK: - PET
    func makeUpdateUseCase() -> UpdatePetUseCase {
        let useCase = DefaultUpdatePetUseCase(petRepository: dataContainer.petRepository, imageRepository: dataContainer.petImageRepository)
        return useCase
    }
    
    func makeFetchPetListUseCase() -> FetchPetListUseCase {
        let useCase = DefaultFetchPetListUseCase(petRepository: dataContainer.petRepository)
        return useCase
    }
    
    func makeRegisterUseCase () -> DefaultRegisterPetUseCase {
        return DefaultRegisterPetUseCase(petRepository: dataContainer.petRepository, petImageRepository: dataContainer.petImageRepository)
    }
    
    func makeDeleteUseCase() -> DeletePetUseCase {
        let usecase = DefaultDeletePetUseCase(petImageRepository: dataContainer.petImageRepository, petRepository: dataContainer.petRepository)
        return usecase
    }
}
