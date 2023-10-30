//
//  PetListViewModel.swift
//  RepCare
//
//  Created by JunHwan Kim on 2023/10/04.
//

import Foundation
import RxRelay
import RxSwift
import RxCocoa

final class PetListViewModel {
    
    private let fetchPetListUseCase: FetchPetListUseCase
    let queryRelay: BehaviorRelay<FetchPetListQuery> = .init(value: .init(petClass: .all, species: nil, detailSpecies: nil, morph: nil, searchKeyword: nil, gender: nil))
    var queryDriver: Driver<FetchPetListQuery> {
        return queryRelay.asDriver()
    }
    var isApplyFilter: Driver<Bool> {
        return queryRelay.map { query in
            return query.species != nil
        }.asDriver(onErrorJustReturn: false)
    }
    var currentQuery: FetchPetListQuery = .init(petClass: .all, species: nil, detailSpecies: nil, morph: nil, searchKeyword: nil, gender: nil)
    private var pages: [PetPage] = []
    
    let petList: BehaviorRelay<[PetModel]> = .init(value: [])
    let diContainer: PetListSceneDIContainer
    private let disposeBag = DisposeBag()
    
    var currentPage: Int = 0
    var totalPage: Int = 1
    var hasMorePage: Bool {
        get {
            currentPage < totalPage
        }
    }
    var nextPage: Int {
        get {
            hasMorePage ? currentPage + 1 : currentPage
        }
    }
    
    init(diContainer: PetListSceneDIContainer) {
        self.diContainer = diContainer
        self.fetchPetListUseCase = diContainer.makeFetchPetListUseCase()
    }
    
    private func resetPage() {
        currentPage = 0
        totalPage = 1
        pages.removeAll()
        petList.accept([])
    }
    
    private func load(query: FetchPetListQuery) {
        let request = FetchPetListRequest(query: query, start: nextPage)
        queryRelay.accept(query)
        currentQuery = query
        let fetchPage = fetchPetListUseCase.fetchPetList(request: request)
        appendPage(page: fetchPage)
    }
    
    private func appendPage(page: PetPage) {
        currentPage = page.currentPage
        totalPage = page.totalPage
        pages = pages.filter({ $0.currentPage != page.currentPage })+[page]
        let co = pages.reduce(into: []) { partialResult, page in
            partialResult.append(contentsOf: page.petList.map { PetModel(pet: $0) })
        }
        petList.accept(co)
    }
    
    // MARK: - OUTPUT
    func loadNextPage() {
        if hasMorePage {
            load(query: currentQuery)
        }
    }
    
    func reloadPetList() {
        resetPage()
        load(query: currentQuery)
    }
    
    func fetchFilterPetClassPetList(petClass: PetClassModel) {
        let query = FetchPetListQuery(petClass: petClass.toDomain(), species: nil, detailSpecies: nil, morph: nil, searchKeyword: currentQuery.searchKeyword, gender: currentQuery.gender)
        resetPage()
        load(query: query)
    }
    
    func fetchFilteringPetList(petClass: PetClassModel, species: PetSpeciesModel?, detailSpecies: DetailPetSpeciesModel?, morph: MorphModel?, gender: GenderType?) {
        let query = FetchPetListQuery(petClass: petClass.toDomain(), species: species?.toDomain(), detailSpecies: detailSpecies?.toDomain(), morph: morph?.toDomain(), searchKeyword: currentQuery.searchKeyword, gender: gender?.toDomain())
        resetPage()
        load(query: query)
    }
    
    func searchPet(keyword: String) {
        let searchQuery: FetchPetListQuery = .init(petClass: currentQuery.petClass, species: currentQuery.species, detailSpecies: currentQuery.detailSpecies, morph: currentQuery.morph, searchKeyword: keyword, gender: currentQuery.gender)
        resetPage()
        load(query: searchQuery)
    }
}
