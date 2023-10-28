//
//  UIImageView+.swift
//  RepCare
//
//  Created by JunHwan Kim on 2023/10/14.
//

import Foundation
import UIKit

enum FetchFileImageError: Error {
    case cannotFetchImage
}

extension UIImageView {
    func configureImageFromFilePath(path: String) throws {
        guard let defaultPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        let imagePath: String
        if #available(iOS 16.0, *) {
            imagePath = defaultPath.appendingPathComponent(path, conformingTo: .png).path()
        } else {
            imagePath = defaultPath.appendingPathComponent(path, conformingTo: .png).path
        }
        if let imageFile = FileManager.default.contents(atPath: imagePath) {
            DispatchQueue.main.async { [weak self] in
                self?.image = UIImage(data: imageFile)
            }
        } else {
            throw FetchFileImageError.cannotFetchImage
        }
    }
}
