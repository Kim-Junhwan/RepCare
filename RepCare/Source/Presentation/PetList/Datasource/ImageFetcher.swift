//
//  ImageOperation.swift
//  RepCare
//
//  Created by JunHwan Kim on 2024/04/03.
//

import Foundation
import UIKit

final class ImageFetcher {
    private let imageFetchingQueue = OperationQueue()
    private var imageCache = NSCache<NSString, UIImage>()
    var loadingOperations: [String: ImageFetchOperation] = [:]
    
    func fetchImage(id: String, imagePath: String, completion: ((Result<UIImage, Error>)-> Void)? = nil) {
        if let cachedImage = imageCache.object(forKey: id as NSString) {
            completion?(.success(cachedImage))
        } else {
            if let dataFetchOperation = loadingOperations[id] {
                if let fetchImage = dataFetchOperation.fetchedImage {
                    loadingOperations.removeValue(forKey: id)
                    completion?(.success(fetchImage))
                } else {
                    dataFetchOperation.loadingCompletion = completion
                }
            } else {
                registerNewFetchImageOperation(id: id, imagePath: imagePath, completion: completion)
            }
        }
    }
    
    private func registerNewFetchImageOperation(id: String, imagePath: String, completion: ((Result<UIImage, Error>)-> Void)?) {
        let operation = ImageFetchOperation(imagePath: imagePath, id: id) { result in
            switch result {
            case .success(let fetchImage):
                self.imageCache.setObject(fetchImage, forKey: id as NSString)
                self.loadingOperations.removeValue(forKey: id)
                completion?(.success(fetchImage))
            case .failure(let error):
                completion?(.failure(error))
            }
        }
        imageFetchingQueue.addOperation(operation)
        loadingOperations[id] = operation
    }
    
    func cancelFetchImage(id: String) {
        if let cancelOperation = loadingOperations[id] {
            cancelOperation.cancel()
            loadingOperations.removeValue(forKey: id)
        }
    }
}

