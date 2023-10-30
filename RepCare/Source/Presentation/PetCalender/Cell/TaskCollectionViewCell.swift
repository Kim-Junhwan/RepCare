//
//  TaskCollectionViewCell.swift
//  RepCare
//
//  Created by JunHwan Kim on 2023/10/15.
//

import UIKit

class TaskCollectionViewCell: UICollectionViewCell {
    static let identifier = "TaskCollectionViewCell"
    
    let classImageBackgroundView: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        return view
    }()
    
    let classImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.tintColor = .white
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
            make.width.height.equalTo(40)
        }
        classLabel.snp.makeConstraints { make in
            make.top.equalTo(classImageBackgroundView.snp.bottom)
            make.centerX.equalTo(snp.centerX)
        }
    }
    
    func configureCell(task: TaskModel) {
        classImageView.image = UIImage(named: task.image)?.withRenderingMode(.alwaysTemplate)
        classLabel.text = task.title
        classImageBackgroundView.backgroundColor = task.color
    }
}
