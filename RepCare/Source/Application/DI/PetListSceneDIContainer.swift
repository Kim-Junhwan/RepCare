//
//  PetListSceneDIContainer.swift
//  RepCare
//
//  Created by JunHwan Kim on 2023/10/26.
//

import Foundation

final class PetListSceneDIContainer {
    private let appDIContainer: AppDIContainer
    
    init(appDIContainer: AppDIContainer) {
        self.appDIContainer = appDIContainer
    }
    
    func makeFetchPetListUseCase() -> FetchPetListUseCase {
        let useCase = DefaultFetchPetListUseCase(petRepository: appDIContainer.getPetRepository())
        return useCase
    }
    
    func makeRegisterUseCase () -> DefaultRegisterPetUseCase {
        let useCase = DefaultRegisterPetUseCase(petRepository: appDIContainer.getPetRepository(), petImageRepository: appDIContainer.getPetImageRepository())
        return useCase
    }
    
    private func makeSpeciesViewModel() -> ClassSpeciesMorphViewModel {
        let viewModel = ClassSpeciesMorphViewModel(repository: appDIContainer.getSpeciesRepository())
        return viewModel
    }
    
    private func makeRegisterViewModel() -> RegisterPetViewModel {
        let viewModel = RegisterPetViewModel(diContainer: self)
        return viewModel
    }
    
    func makeRegisterViewController() -> RegisterNewPetViewController {
        let vc = RegisterNewPetViewController(viewModel: makeRegisterViewModel())
        return vc
    }
    
    func makeSpeciesViewController() -> ClassSpeciesMorphViewController {
        let vc = ClassSpeciesMorphViewController(viewModel: makeSpeciesViewModel())
        return vc
    }
    
    private func makeDetailPetViewModel(pet: PetModel) -> DetailPetViewModel {
        let viewModel = DetailPetViewModel(pet: pet)
        return viewModel
    }
    
    private func makePetCalendatViewController(pet: PetModel) -> PetCalendarViewController {
        let vc = PetCalendarViewController(taskRepository: appDIContainer.getTaskRepository(), pet: pet)
        return vc
    }
    
    private func makeWeightViewController(pet: PetModel) -> PetWeightViewController {
        let vc = PetWeightViewController(weightRepository: appDIContainer.getWeightRepository(), pet: pet)
        return vc
    }
    
    func makeDetailPetViewController(pet: PetModel) -> DetailPetViewController {
        let viewModel = makeDetailPetViewModel(pet: pet)
        let vc = DetailPetViewController(headerViewController: makeDetailPetHeaderViewController(pet: pet), petCalenderViewController: makePetCalendatViewController(pet: pet), petWeightViewController: makeWeightViewController(pet: pet), viewModel: viewModel)
        return vc
    }
    
    private func makeDetailPetHeaderViewController(pet: PetModel) -> DetailPetHeaderViewController {
        let vc = DetailPetHeaderViewController(pet: pet)
        return vc
    }
}
