//
//  PetListRepository.swift
//  RepCare
//
//  Created by JunHwan Kim on 2023/10/01.
//

import Foundation
import RxSwift

protocol PetListRepository {
    func fetchPetList(query: PetQuery, page: Int) -> Single<Pet>
}
