//
//  RegisterImageCollectionViewCell.swift
//  RepCare
//
//  Created by JunHwan Kim on 2023/10/11.
//

import UIKit

class RegisterImageCollectionViewCell: UICollectionViewCell {
    static let identifier = "RegisterImageCollectionViewCell"
    
    lazy var mainStackView: UIStackView = {
       let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.addArrangedSubview(cameraImageView)
        stackView.addArrangedSubview(limitLabel)
        return stackView
    }()
    
    let cameraImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "camera.fill")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let limitLabel: UILabel = {
       let label = UILabel()
        label.font = .systemFont(ofSize: 13)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureView() {
        contentView.addSubview(mainStackView)
        cameraImageView.tintColor = .black
        mainStackView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        cameraImageView.snp.makeConstraints { make in
            make.width.height.equalTo(32)
        }
    }
    
    func configureCell(imageCount: Int) {
        limitLabel.text = "\(imageCount)/5"
    }
}
