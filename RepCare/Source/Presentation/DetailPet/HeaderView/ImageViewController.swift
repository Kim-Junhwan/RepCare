//
//  ImageViewController.swift
//  RepCare
//
//  Created by JunHwan Kim on 2023/10/16.
//

import UIKit

class ImageViewController: UIViewController {
    
    private enum Sentence {
        static let emptyImageIdentifier = "star"
    }
    
    let imageView: UIImageView = UIImageView(frame: .zero)
    
    init(imagePath: PetImageModel) {
        super.init(nibName: nil, bundle: nil)
        imageView.configureImageFromFilePath(path: imagePath.imagePath)
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
        imageView.image = UIImage(systemName: Sentence.emptyImageIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = imageView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
