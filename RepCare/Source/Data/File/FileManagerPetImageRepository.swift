//
//  PetImageRepository.swift
//  RepCare
//
//  Created by JunHwan Kim on 2023/10/12.
//

import Foundation

final class FileManaerPetImageRepository: PetImageRepository {
    
    func savePetImage(petId: String, petImageList: [Data]) throws {
        guard let defaultDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        let petImageDirectoryURL = defaultDirectory.appendingPathComponent(petId, conformingTo: .directory)
        
        try FileManager.default.createDirectory(at: petImageDirectoryURL, withIntermediateDirectories: true)
        for images in 0..<petImageList.count {
            let imagePath = petImageDirectoryURL.appendingPathComponent("\(images)", conformingTo: .png)
            try petImageList[images].write(to: imagePath)
        }
    }
}
