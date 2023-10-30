//
//  ImageViewController.swift
//  RepCare
//
//  Created by JunHwan Kim on 2023/10/16.
//

import UIKit

class ImageViewController: UIViewController {
    
    let imageBaseView = UIView()
    let imageView: UIImageView = UIImageView(frame: .zero)
    let isEmptyImage: Bool
    let imagePath: String
    
    init(imagePath: PetImageModel) {
        self.imagePath = imagePath.imagePath
        do {
           try  imageView.configureImageFromFilePath(path: imagePath.imagePath)
            isEmptyImage = false
        } catch {
            isEmptyImage = true
        }
        super.init(nibName: nil, bundle: nil)
    }
    
    init(petClass: PetClassModel) {
        isEmptyImage = true
        self.imagePath = ""
        super.init(nibName: nil, bundle: nil)
        imageView.image = UIImage(named: petClass.image)?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = .systemGray2
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showFullScreenImage)))
        view.addSubview(imageBaseView)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageBaseView.addSubview(imageView)
        imageBaseView.backgroundColor = .systemGray4
        imageBaseView.snp.makeConstraints { $0.edges.equalToSuperview() }
        imageView.snp.makeConstraints { make in
            if isEmptyImage {
                make.center.equalToSuperview()
                make.width.height.equalTo(imageBaseView.snp.width).multipliedBy(0.5)
            } else {
                make.edges.equalToSuperview()
            }
        }
    }
    
    @objc func showFullScreenImage() {
        if !isEmptyImage {
            let fullScreenImage = FullScreenImageViewController(imagePath: imagePath)
            fullScreenImage.modalPresentationStyle = .overFullScreen
            present(fullScreenImage, animated: true)
        }
    }
}
