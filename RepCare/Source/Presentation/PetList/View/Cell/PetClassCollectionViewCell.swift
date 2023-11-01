//
//  PetClassCell.swift
//  RepCare
//
//  Created by JunHwan Kim on 2023/10/02.
//

import UIKit

final class PetClassCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "PetClassCell"
    
    let classImageBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray5
        view.clipsToBounds = true
        return view
    }()
    
    let classImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.tintColor = .systemGray2
        return imageView
    }()
    
    let classLabel: UILabel = {
       let label = UILabel()
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
        setConstraints()
        classImageView.image = UIImage(systemName: "star")
        classLabel.text = "123"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureView() {
        classImageBackgroundView.addSubview(classImageView)
        contentView.addSubview(classImageBackgroundView)
        contentView.addSubview(classLabel)
    }
    
    private func setConstraints() {
        classImageBackgroundView.layer.cornerRadius = 10
        classImageBackgroundView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(classImageBackgroundView.snp.width).multipliedBy(1.0)
        }
        classImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(50)
        }
        classLabel.snp.makeConstraints { make in
            make.top.equalTo(classImageBackgroundView.snp.bottom)
            make.centerX.equalTo(snp.centerX)
        }
    }
    
    func configureCell(petClass: PetClassModel) {
         classImageView.image = UIImage(named: petClass.image)?.withRenderingMode(.alwaysTemplate)
        classLabel.text = petClass.title
    }
    
    override var isSelected: Bool {
        didSet {
            classImageBackgroundView.backgroundColor = isSelected ? .deepGreen : .systemGray5
            classImageView.tintColor = isSelected ? .white : .systemGray2
        }
    }
    
}
