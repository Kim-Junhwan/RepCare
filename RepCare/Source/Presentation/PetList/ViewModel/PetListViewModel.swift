//
//  PetListViewModel.swift
//  RepCare
//
//  Created by JunHwan Kim on 2023/10/04.
//

import Foundation
import RxRelay
import RxSwift

final class PetListViewModel {
    
    let fetchPetListUseCase: FetchPetListUseCase
    let selectPetClass: BehaviorRelay<PetClassModel> = .init(value: .all)
    let requestPetListFilter: BehaviorRelay<FetchPetListRequest> = .init(value: .init(query: .init(petClass: .all, species: nil, detailSpecies: nil, morph: nil, searchKeyword: nil, gender: nil), start: 0))
    let petList: BehaviorRelay<[PetModel]> = .init(value: [])
    let disposeBag = DisposeBag()
    
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
    
    init(fetchPetListUseCase: FetchPetListUseCase) {
        self.fetchPetListUseCase = fetchPetListUseCase
    }
    
    func viewDidLooad() {
        bind()
    }
    
    private func bind() {
        requestPetListFilter.subscribe(with: self) { owner, request in
            owner.load(request: request)
        }.disposed(by: disposeBag)
    }
    
    private func load(request: FetchPetListRequest) {
        let fetchPage = fetchPetListUseCase.fetchPetList(request: request)
        currentPage = fetchPage.currentPage
        totalPage = fetchPage.totalPage
        petList.accept(fetchPage.petList.map { .init(pet: $0) })
    }
}
