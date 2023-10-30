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
    
    private func makeRegisterViewModel() -> RegisterPetViewModel {
        let viewModel = RegisterPetViewModel(diContainer: self)
        return viewModel
    }
    
    func makeRegisterViewController() -> RegisterNewPetViewController {
        let vc = RegisterNewPetViewController(viewModel: makeRegisterViewModel())
        return vc
    }
    
    private func makeUpdateUseCase() -> UpdatePetUseCase {
        let useCase = DefaultUpdatePetUseCase(petRepository: appDIContainer.getPetRepository(), imageRepository: appDIContainer.getPetImageRepository())
        return useCase
    }
    
    private func makeUpdateViewModel(pet: PetModel) -> UpdatePetViewModel {
        let viewModel = UpdatePetViewModel(updatePetUseCase: makeUpdateUseCase() , pet: pet, diContainer: self)
        return viewModel
    }
    
    func makeUpdateViewController(pet: PetModel) -> RegisterNewPetViewController {
        let vc = RegisterNewPetViewController(viewModel: makeUpdateViewModel(pet: pet))
        return vc
    }
    
    private func makeSpeciesViewModel(petSpeciesModel: PetOverSpeciesModel? = nil) -> ClassSpeciesMorphViewModel {
        let viewModel = ClassSpeciesMorphViewModel(petSpeceis: petSpeciesModel, repository: appDIContainer.getSpeciesRepository())
        return viewModel
    }
    
    func makeFilterSpeciesViewController(petClass: PetClassModel?, species: PetSpeciesModel?, detailSpecies: DetailPetSpeciesModel?, morph: MorphModel?) -> ClassSpeciesMorphViewController {
        let vc = ClassSpeciesMorphViewController(viewModel: FilterClassSpeciesViewModel(petClass: petClass, species: species, detailSpecies: detailSpecies, morph: morph, repository: appDIContainer.getSpeciesRepository()))
        return vc
    }
    
    func makeSpeciesViewController(petSpeciesModel: PetOverSpeciesModel? = nil) -> ClassSpeciesMorphViewController {
        let vc = ClassSpeciesMorphViewController(viewModel: makeSpeciesViewModel(petSpeciesModel: petSpeciesModel))
        return vc
    }
    
    private func makeDetailPetViewModel(pet: PetModel) -> DetailPetViewModel {
        let viewModel = DetailPetViewModel(pet: pet, deleteUseCase: makeDeleteUseCase(), diContainer: self, petRepository: appDIContainer.getPetRepository())
        return viewModel
    }
    
    private func makeDeleteUseCase() -> DeletePetUseCase {
        let usecase = DefaultDeletePetUseCase(petImageRepository: appDIContainer.getPetImageRepository(), petRepository: appDIContainer.getPetRepository())
        return usecase
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
