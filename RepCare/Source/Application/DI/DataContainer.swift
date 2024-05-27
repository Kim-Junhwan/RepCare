//
//  DataContainer.swift
//  RepCare
//
//  Created by JunHwan Kim on 2024/05/19.
//

import Foundation

final class DataContainer {
    let storageContainer: StorageDIContainer
    
    init(storageContainer: StorageDIContainer) {
        self.storageContainer = storageContainer
    }
    
    lazy var petRepository: PetRepository = {
        let petRepository = DefaultPetRepository(petStorage: storageContainer.petStorage, speciesStorage: storageContainer.speciesStorage, weightStorage: storageContainer.weightStorage)
        return petRepository
    }()
    
    lazy var speciesRepository: SpeciesRepository = {
        let speciesRepository = DefaultSpeciesRepository(speciesStroage: storageContainer.speciesStorage)
        return speciesRepository
    }()
    
    lazy var taskRepository: TaskRepository = {
        let taskRepository = DefaultTaskRepository(petStorage: storageContainer.petStorage, taskStorage: storageContainer.taskStroage)
        return taskRepository
    }()
    
    lazy var weightRepository: WeightRepository = {
        let weightRepository = DefaultWeightRepository(weightStroage: storageContainer.weightStorage, petStorage: storageContainer.petStorage)
        return weightRepository
    }()
    
    lazy var petImageRepository: PetImageRepository = {
       let imageRepository = FileManaerPetImageRepository()
        return imageRepository
    }()
}
