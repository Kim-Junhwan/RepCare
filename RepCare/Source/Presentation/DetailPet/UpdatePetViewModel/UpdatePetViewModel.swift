//
//  UpdatePetViewModel.swift
//  RepCare
//
//  Created by JunHwan Kim on 2023/10/26.
//

import Foundation
import UIKit

final class UpdatePetViewModel: RegisterPetViewModel {
    let updatePetUseCase: UpdatePetUseCase
    
    init(updatePetUseCase: UpdatePetUseCase, pet: PetModel, diContainer: PetListSceneDIContainer) {
        self.updatePetUseCase = updatePetUseCase
        super.init(diContainer: diContainer)
        self.adoptionDate.accept(pet.adoptionDate)
        self.hatchDate.accept(pet.hatchDate)
        self.currentWeight.accept(pet.currentWeight)
        self.overPetSpecies.accept(pet.overSpecies)
        self.petImageList.accept(pet.imagePath.map { .init(image: configureImage(path: $0.imagePath), imageType: .cameraImage, id: UUID().uuidString) })
        self.gender.accept(pet.sex)
        self.petName.accept(pet.name)
    }
    
    private func configureImage(path: String) -> UIImage {
        guard let defaultPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return .init() }
        let imagePath: String
        if #available(iOS 16.0, *) {
            imagePath = defaultPath.appendingPathComponent(path, conformingTo: .png).path()
        } else {
            imagePath = defaultPath.appendingPathComponent(path, conformingTo: .png).path
        }
        guard let image = UIImage(contentsOfFile: imagePath) else { return .init() }
        return image
    }
}
