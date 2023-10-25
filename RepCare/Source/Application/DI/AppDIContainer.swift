//
//  AppDIContainer.swift
//  RepCare
//
//  Created by JunHwan Kim on 2023/10/25.
//

import Foundation

final class AppDIContainer {
    
    let storageDIContainer: StorageDIContainer
    
    init(storageDIContainer: StorageDIContainer) {
        self.storageDIContainer = storageDIContainer
    }
    
    func getPetRepository() -> PetRepository {
        let petRepository = DefaultPetRepository(petStorage: storageDIContainer.petStorage, speciesStroage: storageDIContainer.speciesStorage)
        return petRepository
    }
    
    func getSpeciesRepository() -> SpeciesRepository {
        let speciesRepository = DefaultSpeciesRepository(speciesStroage: storageDIContainer.speciesStorage)
        return speciesRepository
    }
    
    func getTaskRepository() -> TaskRepository {
        let taskRepository = DefaultTaskRepository(petStorage: storageDIContainer.petStorage, taskStorage: storageDIContainer.taskStroage)
        return taskRepository
    }
    
    func getWeightRepository() -> WeightRepository {
        let weightRepository = DefaultWeightRepository(weightStroage: storageDIContainer.weightStorage, petStorage: storageDIContainer.petStorage)
        return weightRepository
    }
    
    func getPetImageRepository() -> PetImageRepository {
        let imageRepository = FileManaerPetImageRepository()
        return imageRepository
    }
}
