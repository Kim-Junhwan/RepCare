//
//  PetListSceneDIContainer.swift
//  RepCare
//
//  Created by JunHwan Kim on 2023/10/26.
//

import Foundation

final class PetListSceneDIContainer {
    private let domainContainer: DomainDIContainer
    
    init(domainContainer: DomainDIContainer) {
        self.domainContainer = domainContainer
    }
    
    private func makeRegisterViewModel() -> RegisterPetViewModel {
        let viewModel = RegisterPetViewModel(diContainer: self)
        return viewModel
    }
    
    func makeRegisterViewController() -> RegisterNewPetViewController {
        let vc = RegisterNewPetViewController(viewModel: makeRegisterViewModel())
        return vc
    }
    
    private func makeUpdateViewModel(pet: PetModel) -> UpdatePetViewModel {
        let viewModel = UpdatePetViewModel(updatePetUseCase: domainContainer.makeUpdateUseCase(), pet: pet, diContainer: self)
        return viewModel
    }
    
    func makeUpdateViewController(pet: PetModel) -> RegisterNewPetViewController {
        let vc = RegisterNewPetViewController(viewModel: makeUpdateViewModel(pet: pet))
        return vc
    }
    
    private func makeSpeciesViewModel(petSpeciesModel: PetOverSpeciesModel? = nil) -> ClassSpeciesMorphViewModel {
        let viewModel = ClassSpeciesMorphViewModel(petSpeceis: petSpeciesModel, repository: domainContainer.dataContainer.speciesRepository)
        return viewModel
    }
    
    func makeFilterSpeciesViewController(petClass: PetClassModel?, species: PetSpeciesModel?, detailSpecies: DetailPetSpeciesModel?, morph: MorphModel?) -> ClassSpeciesMorphViewController {
        let vc = ClassSpeciesMorphViewController(viewModel: FilterClassSpeciesViewModel(petClass: petClass, species: species, detailSpecies: detailSpecies, morph: morph, repository: domainContainer.dataContainer.speciesRepository))
        return vc
    }
    
    func makeSpeciesViewController(petSpeciesModel: PetOverSpeciesModel? = nil) -> ClassSpeciesMorphViewController {
        let vc = ClassSpeciesMorphViewController(viewModel: makeSpeciesViewModel(petSpeciesModel: petSpeciesModel))
        return vc
    }
    
    private func makeDetailPetViewModel(pet: PetModel) -> DetailPetViewModel {
        let viewModel = DetailPetViewModel(pet: pet, deleteUseCase: domainContainer.makeDeleteUseCase(), diContainer: self, petRepository: domainContainer.dataContainer.petRepository)
        return viewModel
    }
    
    private func makePetCalendatViewController(pet: PetModel) -> PetCalendarViewController {
        let vc = PetCalendarViewController(taskRepository: domainContainer.dataContainer.taskRepository, pet: pet)
        return vc
    }
    
    private func makeWeightViewController(pet: PetModel) -> PetWeightViewController {
        let vc = PetWeightViewController(weightRepository: domainContainer.dataContainer.weightRepository, pet: pet)
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
    
    func makePetListController() ->  PetListViewController {
        let vm = PetListViewModel(fetchPetListUseCase: domainContainer.makeFetchPetListUseCase())
        let vc = PetListViewController(viewModel: vm, petListSceneDIContainer: self)
        return vc
    }
}
