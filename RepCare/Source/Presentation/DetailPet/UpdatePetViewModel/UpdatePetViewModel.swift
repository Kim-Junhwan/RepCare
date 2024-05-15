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
    let pet: PetModel
    
    override var title: String {
        return "개체 정보 수정"
    }
    
    override var registerButtonTitle: String {
        return "수정"
    }
    
    init(updatePetUseCase: UpdatePetUseCase, pet: PetModel, diContainer: PetListSceneDIContainer) {
        self.updatePetUseCase = updatePetUseCase
        self.pet = pet
        super.init(diContainer: diContainer)
        self.adoptionDate.accept(pet.adoptionDate)
        self.hatchDate.accept(pet.hatchDate)
        self.overPetSpecies.accept(pet.overSpecies)
        self.petImageList.accept(pet.imagePath.map { .init(image: configureImage(path: $0.imagePath), imageType: .cameraImage, id: UUID().uuidString) })
        self.gender.accept(pet.sex)
        self.petName.accept(pet.name)
    }
    
    override func register() throws {
        let imageListData = petImageList.value.map({ image in
            guard let imageData = image.image.jpegData(compressionQuality: 1.0) else { fatalError() }
            return imageData
        })
        guard let petClass = overPetSpecies.value?.petClass else { return }
        guard let species = overPetSpecies.value?.petSpecies else { return }
        guard let adoptionDate = adoptionDate.value else { return }
        guard let gender = gender.value else { return }
        let editRequest = UpdatePetRequest(id: pet.id, name: petName.value, imageDataList: imageListData, petClass: petClass.toDomain(), petSpecies: species.toDomain(), detailSpecies: overPetSpecies.value?.detailSpecies?.toDomain(), morph: overPetSpecies.value?.morph?.toDomain(), adoptionDate: adoptionDate, birthDate: hatchDate.value, gender: gender.toDomain())
        try updatePetUseCase.updatePet(request: editRequest)
    }
    
    private func configureImage(path: String) -> UIImage {
        guard let defaultPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return .init() }
        let imagePath: String
        if #available(iOS 16.0, *) {
            imagePath = defaultPath.appendingPathComponent(path, conformingTo: .jpeg).path()
        } else {
            imagePath = defaultPath.appendingPathComponent(path, conformingTo: .jpeg).path
        }
        guard let image = UIImage(contentsOfFile: imagePath) else { return .init() }
        return image
    }
}
