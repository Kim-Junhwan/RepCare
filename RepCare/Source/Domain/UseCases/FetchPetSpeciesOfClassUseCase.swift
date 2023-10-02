//
//  FetchPetSpeciesOfClassUseCase.swift
//  RepCare
//
//  Created by JunHwan Kim on 2023/10/01.
//

import Foundation
import RxSwift

protocol FetchPetSpeciesOfClassUseCase {
    func fetchPetList(request: FetchPetListRequest) -> PetPage
}

struct FetchPetListRequest {
    var page: Int
    var petSpecies: PetSpecies
    var petClass: PetClass
    var searchKeyword: String?
}

final class DefaultFetchPetSpeciesOfClassUseCase {
    let petRepository: PetRepository
    
    init(petRepository: PetRepository) {
        self.petRepository = petRepository
    }
}

extension DefaultFetchPetSpeciesOfClassUseCase: FetchPetSpeciesOfClassUseCase {
    func fetchPetList(request: FetchPetListRequest) -> PetPage {
        let fetchIndex = request.page * Rule.fetchPetCount
        let query = PetQuery(petClass: request.petClass, species: request.petSpecies, searchKeyword: request.searchKeyword)
        let response = petRepository.fetchPetList(query: query, start: fetchIndex)
        
        let currentPage = (response.start/Rule.fetchPetCount)+1
        let totalPage = response.totalPetCount % Rule.fetchPetCount == 0 ? response.totalPetCount/Rule.fetchPetCount : (response.totalPetCount/Rule.fetchPetCount)+1
        return PetPage(currentPage: currentPage, totalPage: totalPage, petList: response.petList)
    }
}
