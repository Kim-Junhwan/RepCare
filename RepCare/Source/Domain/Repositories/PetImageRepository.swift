//
//  PetImageRepository.swift
//  RepCare
//
//  Created by JunHwan Kim on 2023/10/11.
//

import Foundation

protocol PetImageRepository {
    func savePetImage(petId: String ,petImageList: [Data]) throws
}
