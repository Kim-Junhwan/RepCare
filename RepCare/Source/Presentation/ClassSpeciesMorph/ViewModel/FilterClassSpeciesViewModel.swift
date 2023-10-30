//
//  FilterClassSpeciesViewModel.swift
//  RepCare
//
//  Created by JunHwan Kim on 2023/10/30.
//

import Foundation
import RxRelay
import RxCocoa

final class FilterClassSpeciesViewModel: ClassSpeciesMorphViewModel {
    override var title: String {
        return "필터링"
    }
    
    override var registerButtonTitle: String {
        return "적용"
    }
    
    init(petClass: PetClassModel?, species: PetSpeciesModel?, detailSpecies: DetailPetSpeciesModel?, morph: MorphModel? ,repository: SpeciesRepository) {
        super.init(repository: repository)
        temporaryPetSpeceis = .init(petClass: petClass, petSpecies: species, detailSpecies: detailSpecies, morph: morph)
        self.selectPetClass.accept(petClass)
        self.selectSpecies.accept(species)
        self.selectDetailSpecies.accept(detailSpecies)
        self.selectMorph.accept(morph)
    }
    
    lazy var canRegisterOrigin = BehaviorRelay<Bool>.combineLatest(selectPetClass, selectSpecies, selectDetailSpecies, selectMorph) { petClass, species, detailSpecies, morph in
        return (petClass != nil)
    }
    
    override var canRegister: Driver<Bool> {
        return canRegisterOrigin.asDriver(onErrorJustReturn: false)
    }
    
    override func registerSpecies() {
        guard let petClass = selectPetClass.value else { return }
        tapRegisterClosure?(.init(petClass: petClass, petSpecies: selectSpecies.value, detailSpecies: selectDetailSpecies.value, morph: selectMorph.value))
    }
}

