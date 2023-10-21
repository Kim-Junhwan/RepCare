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
}

final class ClassSpeciesMorphViewModel {
    
    private let repository: SpeciesRepository
    
    let selectPetClass: BehaviorRelay<PetClassModel?> = .init(value: nil)
    let selectSpecies: BehaviorRelay<PetSpeciesModel?> = .init(value: nil)
    let selectDetailSpecies: BehaviorRelay<DetailPetSpeciesModel?> = .init(value: nil)
    let selectMorph: BehaviorRelay<MorphModel?> = .init(value: nil)
    
    var fetchPetClassList: [PetClassModel] = []
    var fetchSpeciesList: [PetSpeciesModel] = []
    var fetchDetailSpeciesList: [DetailPetSpeciesModel] = []
    var fetchMorphList: [MorphModel] = []
    
    let speciesList: BehaviorRelay<[Section: [Item]]> = .init(value: [.detailSpecies:[],.morph:[],.petClass:[],.species:[]])
    lazy var canRegister = BehaviorRelay<Bool>.combineLatest(selectPetClass, selectSpecies, selectDetailSpecies, selectMorph) { petClass, species, detailSpecies, morph in
        return (petClass != nil) && (species != nil)
    }
    var tapRegisterClosure: ((PetOverSpeciesModel) -> Void)?
    let disposeBag = DisposeBag()
    
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
    
    func registerNewSpecies(section: Section, title: String) throws {
        switch section {
        case .species:
            guard let selectClass = selectPetClass.value else { return }
            try repository.registerNewSpecies(petSpecies: title, parentClass: selectClass.toDomain())
            fetchPetSpecies(petClass: selectClass)
        case .detailSpecies:
            guard let selectSpecies = selectSpecies.value?.toDomain() else { return }
            try repository.registerNewDetailSpecies(detailSpecies: title, parentSpecies: selectSpecies)
            self.selectSpecies.accept(self.selectSpecies.value)
        case .morph:
            guard let selectDetailSpecies = selectDetailSpecies.value?.toDomain() else { return }
            try repository.registerNewMorph(petMorph: title, parentDetailSpecies: selectDetailSpecies)
            self.selectDetailSpecies.accept(self.selectDetailSpecies.value)
        default:
            fatalError("unknown Section")
        }
    }
    
    private func fetchPetClass() {
        let fetchPetClass = repository.fetchPetClass().map { PetClassModel(petClass: $0) }
        self.fetchPetClassList = fetchPetClass
        updateList(section: .petClass, data: fetchPetClass.map { Item(title: $0.title, id: UUID().uuidString, isRegisterCell: false) })
    }
    
    private func appendRegisterItem(data: [Item]) -> [Item] {
        let registerItem = Item(title: "", id: UUID().uuidString, isRegisterCell: true)
        
        return data+[registerItem]
    }
    
    private func updateList(section: Section, data: [Item]) {
        var origin = speciesList.value
        origin[section] = data
        for sectionValue in (section.rawValue+1)..<Section.allCases.count {
            guard let removeSection = Section(rawValue: sectionValue) else { return }
            
            origin[removeSection] = []
        }
        speciesList.accept(origin)
    }
    
    private func updateFetchSpeciesList(section: Section, data: [Item]) {
        updateList(section: section, data: appendRegisterItem(data: data))
    }
    
    private func fetchPetSpecies(petClass: PetClassModel) {
        let fetchSpecies = self.repository.fetchSpecies(petClass: petClass.toDomain())
        self.fetchSpeciesList = fetchSpecies.map{ .init(petSpecies: $0) }
        self.updateFetchSpeciesList(section: .species, data: fetchSpecies.map { Item(title: $0.species, id: $0.id, isRegisterCell: false) })
    }
    
    private func bind() {
        selectPetClass.compactMap({ return $0 }).subscribe(with: self) { owner, item in
            owner.fetchPetSpecies(petClass: item)
            owner.selectSpecies.accept(nil)
            owner.selectDetailSpecies.accept(nil)
            owner.selectMorph.accept(nil)
        }.disposed(by: disposeBag)
        
        selectSpecies.compactMap({ return $0 }).subscribe { [weak self] item in
            guard let self else { return }
            guard let petSpecies = item.element?.toDomain() else { return }
            let fetchDetailSpecies = self.repository.fetchDetailSpecies(species: petSpecies)
            self.fetchDetailSpeciesList = fetchDetailSpecies.map { .init(detailSpecies: $0) }
            self.updateFetchSpeciesList(section: .detailSpecies, data: fetchDetailSpecies.map { Item(title: $0.detailSpecies, id: $0.id, isRegisterCell: false) })
            self.selectDetailSpecies.accept(nil)
            self.selectMorph.accept(nil)
        }.disposed(by: disposeBag)
        
        selectDetailSpecies.compactMap({ return $0 }).subscribe { [weak self] item in
            guard let self else { return }
            guard let detailSpecies = item.element?.toDomain() else { return }
            let fetchMorph = self.repository.fetchMorph(detailSpecies: detailSpecies)
            self.fetchMorphList = fetchMorph.map { .init(morph: $0) }
            self.updateFetchSpeciesList(section: .morph, data: fetchMorph.map { Item(title: $0.morphName, id: $0.id, isRegisterCell: false) })
            self.selectMorph.accept(nil)
        }.disposed(by: disposeBag)
    }
    
    func registerSpecies() {
        guard let petClass = selectPetClass.value else { return }
        guard let petSpecies = selectSpecies.value else { return }
        tapRegisterClosure?(.init(petClass: petClass, petSpecies: petSpecies, detailSpecies: selectDetailSpecies.value, morph: selectMorph.value))
    }
}
