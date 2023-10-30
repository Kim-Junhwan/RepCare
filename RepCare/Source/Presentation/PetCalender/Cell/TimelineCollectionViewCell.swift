//
//  TimelineCollectionViewCell.swift
//  RepCare
//
//  Created by JunHwan Kim on 2023/10/17.
//

import UIKit

class TimelineCollectionViewCell: UICollectionViewCell {
    static let identifier = "TimelineCollectionViewCell"
    
    lazy var allStackView: UIStackView = {
        let stackView = UIStackView()
         stackView.axis = .vertical
        stackView.spacing = 5
        stackView.distribution = .equalSpacing
        stackView.alignment = .trailing
         stackView.addArrangedSubview(topStackView)
        stackView.addArrangedSubview(memoLabel)
         return stackView
    }()
    
    lazy var topStackView: UIStackView = {
       let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 10
        stackView.addArrangedSubview(logoImageView)
        stackView.addArrangedSubview(titleLabel)
        return stackView
    }()
    
    let logoImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.backgroundColor = .white
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let titleLabel: UILabel = {
       let label = UILabel()
        label.font = .boldSystemFont(ofSize: 17)
        return label
    }()
    
    let memoLabel: PaddingLabel = {
       let label = PaddingLabel()
        label.numberOfLines = 0
        label.layer.cornerRadius = 10
        label.clipsToBounds = true
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    
    let menuButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.image = UIImage(named: "ellipsis")?.withRenderingMode(.alwaysTemplate).resizeImage(size: .init(width: 20, height: 20)).withTintColor(.white)
        let button = UIButton(configuration: config)
        return button
    }()
    
    lazy var menu: UIMenu = {
        let menu = UIMenu(title: "", children: menuItems)
        return menu
    }()
    
    var editClosure: (() -> Void)?
    var deleteClosure: (() -> Void)?
    
    var menuItems: [UIAction] {
        return [
            UIAction(title: "수정", image: UIImage(systemName: "pencil"), handler: { [weak self] (_) in
                self?.editClosure?()
            }),
            UIAction(title: "삭제", image: UIImage(systemName: "trash"), attributes: .destructive, handler: { [weak self] _ in
                self?.deleteClosure?()
            })
        ]
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureView() {
        contentView.addSubview(allStackView)
    }
    
    private func setConstraints() {
        allStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(10)
        }
        topStackView.snp.makeConstraints { make in
            make.width.equalToSuperview()
        }
        logoImageView.snp.makeConstraints { make in
            make.width.height.equalTo(40)
        }
        memoLabel.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel.snp.leading)
        }
        layer.cornerRadius = 10
        logoImageView.layer.cornerRadius = 20
    }
    
    func configureCell(detailTask: DetailTaskModel) {
        titleLabel.text = detailTask.taskType.title
        backgroundColor = detailTask.taskType.color
        logoImageView.image = UIImage(named: detailTask.taskType.timeLineImage)
        if let memo = detailTask.memo , !memo.isEmpty {
            memoLabel.text = memo
            memoLabel.backgroundColor = detailTask.taskType.color.adjustBrightness(factor: 1.2)
            memoLabel.isHidden = false
        } else {
            memoLabel.isHidden = true
        }
    }
}
