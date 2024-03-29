//
//  ImageViewController.swift
//  RepCare
//
//  Created by JunHwan Kim on 2023/10/16.
//

import UIKit

class ImageViewController: BaseViewController {
    
    let imageBaseView = UIView()
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.tintColor = .systemGray3
        return imageView
    }()
    let isEmptyImage: Bool
    let imagePath: String
    let imagePathList: [PetImageModel]
    var pagingBindingAction: ((Int) -> Void)?
    
    init(imagePath: PetImageModel, imagePathList: [PetImageModel], petClass: PetClassModel) {
        self.imagePath = imagePath.imagePath
        self.imagePathList = imagePathList
        do {
            try  imageView.configureImageFromFilePath(path: imagePath.imagePath)
            isEmptyImage = false
        } catch {
            isEmptyImage = true
            imageView.image = UIImage(named: petClass.image)?.withRenderingMode(.alwaysTemplate)
        }
        super.init(nibName: nil, bundle: nil)
    }
    
    init(petClass: PetClassModel) {
        isEmptyImage = true
        self.imagePath = ""
        self.imagePathList = []
        super.init(nibName: nil, bundle: nil)
        imageView.image = UIImage(named: petClass.image)?.withRenderingMode(.alwaysTemplate)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configureView() {
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showFullScreenImage)))
        view.addSubview(imageBaseView)
        imageBaseView.addSubview(imageView)
    }
    
    override func setContraints() {
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
            let selectIndex = Int(imagePathList.firstIndex { $0.imagePath == imagePath} ?? 0)
            let fullScreenImage = FullScreenImagePageViewController(selectIndex: selectIndex, imagePathList: imagePathList) { pagingNum in
                self.pagingBindingAction?(pagingNum)
            }
            fullScreenImage.modalPresentationStyle = .overFullScreen
            present(fullScreenImage, animated: true)
        }
    }
}
