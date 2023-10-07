//
//  ClassSpeciesMorphViewModel.swift
//  RepCare
//
//  Created by JunHwan Kim on 2023/10/05.
//

import Foundation
import RxSwift
import RxRelay

enum Section: Int, CaseIterable {
    case petClass
    case species
    case detailSpecies
    case morph
    
    var title: String {
        switch self {
        case .petClass:
            return "분류"
        case .species:
            return "종"
        case .detailSpecies:
            return "상세 종"
        case .morph:
            return "모프 / 로컬"
        }
    }
}

struct Item: Hashable {
    let title: String
    private let identifier = UUID()
}

final class ClassSpeciesMorphViewModel {
    
    private let repository: SpeciesRepository
    
    let selectPetClass: PublishRelay<Item> = .init()
    let fetchPetClassList: PublishSubject<[PetClassItemViewModel]> = .init()
    
    init(repository: SpeciesRepository) {
        self.repository = repository
    }
    
    func viewDidLoad() {
        fetchPetClass()
    }
    
    private func fetchPetClass() {
        let fetchList = repository.fetchPetClass().map {PetClassItemViewModel(petClass: $0)}
        fetchPetClassList.onNext(fetchList)
    }
}
