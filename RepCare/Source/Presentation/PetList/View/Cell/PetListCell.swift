//
//  PetListCell.swift
//  RepCare
//
//  Created by JunHwan Kim on 2024/04/09.
//

import UIKit

class PetListCell: UICollectionViewCell {
    var petModel: PetModel?
    var petImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = .systemGray3
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    
    func applyImage(fetchResult: Result<UIImage, Error>) {
        switch fetchResult {
        case .success(let fetchImage):
            self.petImageView.image = fetchImage
        case .failure(_):
            self.whenPetImageCannotRender(petClass: petModel?.overSpecies.petClass ?? .reptile)
        }
    }
    
    func whenPetImageCannotRender(petClass: PetClassModel) {
        fatalError("Must Override cannot fetch image")
    }
}
