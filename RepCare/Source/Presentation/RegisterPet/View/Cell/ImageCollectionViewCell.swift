//
//  ImageCollectionViewCell.swift
//  RepCare
//
//  Created by JunHwan Kim on 2023/10/11.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let deleteButton: UIButton = {
        var config = UIButton.Configuration.filled()
        var imageConfig = UIImage.SymbolConfiguration(pointSize: 6, weight: .light)
        config.image = UIImage(systemName: "xmark", withConfiguration: imageConfig)
        config.baseForegroundColor = .white
        config.baseBackgroundColor = .black
        let button = UIButton(configuration: config)
        button.clipsToBounds = true
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureView() {
        contentView.addSubview(imageView)
        contentView.addSubview(deleteButton)
        deleteButton.addTarget(self, action: #selector(tapDelete), for: .touchUpInside)
        imageView.snp.makeConstraints { make in
            make.leading.bottom.equalToSuperview()
            make.width.height.equalToSuperview().multipliedBy(0.9)
        }
        deleteButton.snp.makeConstraints { make in
            make.centerX.equalTo(imageView.snp.trailing)
            make.centerY.equalTo(imageView.snp.top)
            make.width.height.equalToSuperview().multipliedBy(0.2)
        }
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        deleteButton.layer.cornerRadius = deleteButton.bounds.height/2
    }
    
    func configureCell(petImage: PetImageItem) {
        imageView.image = petImage.image
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.layer.cornerRadius = 10.0
    }
    
    @objc private func tapDelete() {
        print("DELETE")
    }
}
