//
//  ImageFetchOperation.swift
//  RepCare
//
//  Created by JunHwan Kim on 2024/04/05.
//

import Foundation
import UIKit

class ImageFetchOperation: Operation {
    let imagePath: String
    let id: String
    private(set) var fetchedImage: UIImage?
    var loadingCompletion: ((Result<UIImage, Error>)-> Void)?
    
    init(imagePath: String, id: String, loadingCompletion: ((Result<UIImage, Error>)-> Void)?) {
        self.imagePath = imagePath
        self.id = id
        self.loadingCompletion = loadingCompletion
    }
    
    private var _excuting = false {
        willSet {
            willChangeValue(forKey: "isExecuting")
        }
        
        didSet {
            didChangeValue(forKey: "isExecuting")
        }
    }
    
    override var isExecuting: Bool {
        return _excuting
    }
    
    override var isAsynchronous: Bool {
        return true
    }
    
    private var _finished = false {
        willSet {
            willChangeValue(forKey: "isFinished")
        }
        
        didSet {
            didChangeValue(forKey: "isFinished")
        }
    }
    
    override var isFinished: Bool {
        return _finished
    }
    
    func finish() {
        self._finished = true
        self._excuting = false
    }
    
    override func start() {
        guard !isCancelled else { 
            finish()
            return
        }
        _finished = false
        _excuting = true
        main()
    }
    
    override func main() {
        guard !isCancelled else {
            finish()
            return
        }
        _finished = false
        _excuting = true
        fetchImage()
    }
    
    func fetchImage() {
        guard let defaultPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        let imagePath: String
        if #available(iOS 16.0, *) {
            imagePath = defaultPath.appendingPathComponent(self.imagePath, conformingTo: .jpeg).path()
        } else {
            imagePath = defaultPath.appendingPathComponent(self.imagePath, conformingTo: .jpeg).path
        }
        DispatchQueue.global().async {
            if let imageFile = FileManager.default.contents(atPath: imagePath) {
                guard let image = UIImage(data: imageFile) else {
                    self.loadingCompletion?(.failure(FetchFileImageError.cannotFetchImage))
                    return
                }
                self.loadingCompletion?(.success(image))
            } else {
                self.loadingCompletion?(.failure(FetchFileImageError.cannotFetchImage))
            }
        }
    }
}
