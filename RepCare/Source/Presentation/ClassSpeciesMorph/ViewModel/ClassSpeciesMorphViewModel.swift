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
    let id: String
    let isRegisterCell: Bool
    private let identifier = UUID()
}

final class ClassSpeciesMorphViewModel {
    
    private let repository: SpeciesRepository
    
    let selectPetClass: PublishRelay<PetClassItemViewModel> = .init()
    let selectSpecies: PublishRelay<Int> = .init()
    let speciesList: BehaviorRelay<[Section: [Item]]> = .init(value: [.detailSpecies:[],.morph:[],.petClass:[],.species:[]])
    
    
    init(repository: SpeciesRepository) {
        self.repository = repository
    }
    
    func viewDidLoad() {
        fetchPetClass()
        bind()
    }
    
    func removeSection(sectionIndex: Int) {
        guard let section = Section(rawValue: sectionIndex+1) else { return }
        updateList(section: section, data: [])
    }
    
    private func fetchPetClass() {
        let fetchPetClass = repository.fetchPetClass().map { PetClassItemViewModel(petClass: $0) }
        var origin = speciesList.value
        origin[.petClass] = fetchPetClass.map { Item(title: $0.title, id: "", isRegisterCell: false) }
        speciesList.accept(origin)
    }
    
    private func appendRegisterItem(data: [Item]) -> [Item] {
        let registerItem = Item(title: "", id: "", isRegisterCell: true)
        
        return data+[registerItem]
    }
    
    private func updateList(section: Section, data: [Item]) {
        var origin = speciesList.value
        origin[section] = data
        for sectionValue in (section.rawValue+1)..<Section.allCases.count {
            origin[Section(rawValue: sectionValue)!] = []
        }
        speciesList.accept(origin)
    }
    
    private func updateFetchSpeciesList(section: Section, data: [Item]) {
        updateList(section: section, data: appendRegisterItem(data: data))
    }
    
    private func bind() {
        selectPetClass.subscribe { item in
            guard let petClass = item.element?.toDomain() else { return }
            let fetchSpecies = self.repository.fetchSpecies(petClass: petClass)
            self.updateFetchSpeciesList(section: .species, data: fetchSpecies.map { Item(title: $0.species, id: $0.id, isRegisterCell: false) })
            
        }
        
        selectSpecies.subscribe { item in
            guard let species = item.element else { return }
            guard let select = self.speciesList.value[.species]?[species] else { return }
            let fetchDetailSpecies = self.repository.fetchDetailSpecies(species: .init(id: select.id, species: select.title))
            self.updateFetchSpeciesList(section: .detailSpecies, data: fetchDetailSpecies.map { .init(title: $0.detailSpecies, id: $0.id, isRegisterCell: false) })
        }
    }
}
