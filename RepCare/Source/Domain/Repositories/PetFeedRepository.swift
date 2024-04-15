//
//  PetFeedRepository.swift
//  RepCare
//
//  Created by JunHwan Kim on 2024/04/15.
//

import Foundation

protocol PetFeedRepository {
    func fetchPetFeedList() -> [PetFeed]
}
