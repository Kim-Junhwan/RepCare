//
//  ClassSpeciesMorphViewModel.swift
//  RepCare
//
//  Created by JunHwan Kim on 2023/10/05.
//

import Foundation
import RxSwift
import RxRelay
import RxCocoa

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
    let id: String
    let title: String
    let isRegisterCell: Bool
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Item, rhs: Item) -> Bool {
        return lhs.id == rhs.id
    }
}

class ClassSpeciesMorphViewModel {
    
    private let repository: SpeciesRepository
    
    let selectPetClass: BehaviorRelay<PetClassModel?> = .init(value: nil)
    let selectSpecies: BehaviorRelay<PetSpeciesModel?> = .init(value: nil)
    let selectDetailSpecies: BehaviorRelay<DetailPetSpeciesModel?> = .init(value: nil)
    let selectMorph: BehaviorRelay<MorphModel?> = .init(value: nil)
    
    var fetchPetClassList: [PetClassModel] = []
    var fetchSpeciesList: [PetSpeciesModel] = []
    var fetchDetailSpeciesList: [DetailPetSpeciesModel] = []
    var fetchMorphList: [MorphModel] = []
    
    var temporaryPetSpeceis: PetOverSpeciesModel?
    
    let speciesList: BehaviorRelay<[Section: [Item]]> = .init(value: [.detailSpecies:[],.morph:[],.petClass:[],.species:[]])
    lazy var canRegisterRelay = Observable<Bool>.combineLatest(selectPetClass, selectSpecies, selectDetailSpecies, selectMorph) { petClass, species, detailSpecies, morph in
        return (petClass != nil) && (species != nil)
    }
    var canRegister: Driver<Bool> {
        return canRegisterRelay.asDriver(onErrorJustReturn: false)
    }
    var tapRegisterClosure: ((PetOverSpeciesModel) -> Void)?
    
    var title: String {
        return "종 선택"
    }
    
    var registerButtonTitle: String {
        return "적용"
    }
    
    let disposeBag = DisposeBag()
    
    init(repository: SpeciesRepository) {
        self.repository = repository
    }
    
    convenience init(petSpeceis: PetOverSpeciesModel? = nil, repository: SpeciesRepository) {
        self.init(repository: repository)
        guard let overPetSpecies = petSpeceis else { return }
        temporaryPetSpeceis = petSpeceis
        self.selectPetClass.accept(overPetSpecies.petClass)
        self.selectSpecies.accept(overPetSpecies.petSpecies)
        self.selectDetailSpecies.accept(overPetSpecies.detailSpecies)
        self.selectMorph.accept(overPetSpecies.morph)
    }
    
    
    
    func viewDidLoad() {
        fetchPetClass()
        bind()
    }
    
    func selectPetClass(petClass: PetClassModel?) {
        removeUnderSection(section: .species)
        selectPetClass.accept(petClass)
        selectSpecies.accept(nil)
        selectDetailSpecies.accept(nil)
        selectMorph.accept(nil)
    }
    
    func selectPetSpecies(species: PetSpeciesModel?) {
        removeUnderSection(section: .species)
        selectSpecies.accept(species)
        selectDetailSpecies.accept(nil)
        selectMorph.accept(nil)
    }
    
    func selectDetailSpecies(detailSpecies: DetailPetSpeciesModel?) {
        removeUnderSection(section: .detailSpecies)
        selectDetailSpecies.accept(detailSpecies)
        selectMorph.accept(nil)
    }
    
    func selectMorph(morph: MorphModel?) {
        removeUnderSection(section: .morph)
        selectMorph.accept(morph)
    }
    
    func removeSection(sectionIndex: Int) {
        guard let section = Section(rawValue: sectionIndex+1) else { return }
        updateList(section: section, data: [])
    }
    
    func checkCanRegisterNewSpecies(section: Section, title: String) -> Bool {
        let trimmingTitle = title.trimmingCharacters(in: .whitespaces)
        switch section {
        case .species:
            guard let selectClass = selectPetClass.value else { return false }
            return repository.checkSpeciesContains(parentSpecies: .petClass, parentId: "\(selectClass.toDomain())", title: trimmingTitle)
        case .detailSpecies:
            guard let selectSpecies = selectSpecies.value?.toDomain() else { return false }
            return repository.checkSpeciesContains(parentSpecies: .species, parentId: selectSpecies.id, title: trimmingTitle)
        case .morph:
            guard let selectDetailSpecies = selectDetailSpecies.value?.toDomain() else { return false }
            return repository.checkSpeciesContains(parentSpecies: .detailSpecies, parentId: selectDetailSpecies.id, title: trimmingTitle)
        default:
            fatalError("unknown Section")
        }
    }
    
    func registerNewSpecies(section: Section, title: String) throws {
        let trimmingTitle = title.trimmingCharacters(in: .whitespaces)
        switch section {
        case .species:
            guard let selectClass = selectPetClass.value else { return }
            try repository.registerNewSpecies(petSpecies: trimmingTitle, parentClass: selectClass.toDomain())
            fetchPetSpecies(petClass: selectClass)
        case .detailSpecies:
            guard let selectSpecies = selectSpecies.value?.toDomain() else { return }
            try repository.registerNewDetailSpecies(detailSpecies: trimmingTitle, parentSpecies: selectSpecies)
            self.selectSpecies.accept(self.selectSpecies.value)
        case .morph:
            guard let selectDetailSpecies = selectDetailSpecies.value?.toDomain() else { return }
            try repository.registerNewMorph(petMorph: trimmingTitle, parentDetailSpecies: selectDetailSpecies)
            self.selectDetailSpecies.accept(self.selectDetailSpecies.value)
        default:
            fatalError("unknown Section")
        }
    }
    
    func deleteSpecies(section: Section, row: Int) throws {
        guard let deleteSpecies = speciesList.value[section]?[row] else { return }
        let domainSection: PetOverSpecies
        switch section {
        case .species:
            domainSection = .species
            try repository.deleteSpecies(species: domainSection, id: deleteSpecies.id)
            self.selectPetClass.accept(self.selectPetClass.value)
            if selectSpecies.value?.id == deleteSpecies.id {
                selectPetSpecies(species: nil)
            }
        case .detailSpecies:
            domainSection = .detailSpecies
            try repository.deleteSpecies(species: domainSection, id: deleteSpecies.id)
            self.selectSpecies.accept(self.selectSpecies.value)
            if selectDetailSpecies.value?.id == deleteSpecies.id {
                selectDetailSpecies(detailSpecies: nil)
            }
        case .morph:
            domainSection = .morph
            try repository.deleteSpecies(species: domainSection, id: deleteSpecies.id)
            self.selectDetailSpecies.accept(self.selectDetailSpecies.value)
            if selectMorph.value?.id == deleteSpecies.id {
                selectMorph(morph: nil)
            }
        default:
            fatalError()
        }
    }
    
    func updateSpecies(section: Section, row: Int, editTitle: String) throws {
        guard let editSpecies = speciesList.value[section]?[row] else { return }
        let domainSection: PetOverSpecies
        switch section {
        case .species:
            domainSection = .species
            try repository.updateSpecies(species: domainSection, id: editSpecies.id, editTitle: editTitle)
            if selectSpecies.value?.id == editSpecies.id {
                selectSpecies.accept(.init(id: editSpecies.id, title: editTitle))
            }
            self.selectPetClass.accept(self.selectPetClass.value)
        case .detailSpecies:
            domainSection = .detailSpecies
            try repository.updateSpecies(species: domainSection, id: editSpecies.id, editTitle: editTitle)
            self.selectSpecies.accept(self.selectSpecies.value)
            if selectDetailSpecies.value?.id == editSpecies.id {
                selectDetailSpecies.accept(.init(id: editSpecies.id, title: editTitle))
            }
        case .morph:
            domainSection = .morph
            try repository.updateSpecies(species: domainSection, id: editSpecies.id, editTitle: editTitle)
            self.selectDetailSpecies.accept(self.selectDetailSpecies.value)
            if selectMorph.value?.id == editSpecies.id {
                selectMorph.accept(.init(id: editSpecies.id, title: editTitle))
            }
        default:
            fatalError()
        }
        
        
    }
    
    private func fetchPetClass() {
        let fetchPetClass = repository.fetchPetClass().map { PetClassModel(petClass: $0) }
        self.fetchPetClassList = fetchPetClass
        updateList(section: .petClass, data: fetchPetClass.map { Item(id: UUID().uuidString, title: $0.title, isRegisterCell: false) })
    }
    
    private func appendRegisterItem(data: [Item]) -> [Item] {
        let registerItem = Item(id: UUID().uuidString, title: "", isRegisterCell: true)
        
        return data+[registerItem]
    }
    
    private func updateList(section: Section, data: [Item]) {
        var origin = speciesList.value
        origin[section] = data
        speciesList.accept(origin)
    }
    
    private func removeUnderSection(section: Section) {
        var origin = speciesList.value
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
        self.updateFetchSpeciesList(section: .species, data: fetchSpecies.map { Item(id: $0.id, title: $0.species, isRegisterCell: false) })
    }
    
    private func bind() {
        selectPetClass.compactMap({ return $0 }).subscribe(with: self) { owner, item in
            owner.fetchPetSpecies(petClass: item)
        }.disposed(by: disposeBag)
        
        selectSpecies.compactMap({ return $0 }).subscribe { [weak self] item in
            guard let self else { return }
            guard let petSpecies = item.element?.toDomain() else { return }
            let fetchDetailSpecies = self.repository.fetchDetailSpecies(species: petSpecies)
            self.fetchDetailSpeciesList = fetchDetailSpecies.map { .init(detailSpecies: $0) }
            self.updateFetchSpeciesList(section: .detailSpecies, data: fetchDetailSpecies.map { Item(id: $0.id, title: $0.detailSpecies, isRegisterCell: false) })
        }.disposed(by: disposeBag)
        
        selectDetailSpecies.compactMap({ return $0 }).subscribe { [weak self] item in
            guard let self else { return }
            guard let detailSpecies = item.element?.toDomain() else { return }
            let fetchMorph = self.repository.fetchMorph(detailSpecies: detailSpecies)
            self.fetchMorphList = fetchMorph.map { .init(morph: $0) }
            self.updateFetchSpeciesList(section: .morph, data: fetchMorph.map { Item(id: $0.id, title: $0.morphName, isRegisterCell: false) })
        }.disposed(by: disposeBag)
    }
    
    func registerSpecies() {
        guard let petClass = selectPetClass.value else { return }
        guard let petSpecies = selectSpecies.value else { return }
        tapRegisterClosure?(.init(petClass: petClass, petSpecies: petSpecies, detailSpecies: selectDetailSpecies.value, morph: selectMorph.value))
    }
    
    deinit {
        print("deinit ClassSpeciesMorphViewModel")
    }
}
