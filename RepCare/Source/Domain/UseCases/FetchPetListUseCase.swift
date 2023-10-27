//
//  FetchPetSpeciesOfClassUseCase.swift
//  RepCare
//
//  Created by JunHwan Kim on 2023/10/01.
//

import Foundation

protocol FetchPetListUseCase {
    func fetchPetList(request: FetchPetListRequest) -> PetPage
}

struct FetchPetListRequest {
    let query: FetchPetListQuery
    let start: Int
}

final class DefaultFetchPetListUseCase {
    let petRepository: PetRepository
    
    init(petRepository: PetRepository) {
        self.petRepository = petRepository
    }
}

extension DefaultFetchPetListUseCase: FetchPetListUseCase {
    func fetchPetList(request: FetchPetListRequest) -> PetPage {
        let startIndex = (request.start-1) * Rule.fetchPetCount
        let response = petRepository.fetchPetList(query: request.query, start: startIndex)
        let currentPage = (response.start/Rule.fetchPetCount)+1
        let totalPage = response.totalPetCount % Rule.fetchPetCount == 0 ? response.totalPetCount/Rule.fetchPetCount : (response.totalPetCount/Rule.fetchPetCount)+1
        return PetPage(currentPage: currentPage, totalPage: totalPage, petList: response.petList)
    }
}
