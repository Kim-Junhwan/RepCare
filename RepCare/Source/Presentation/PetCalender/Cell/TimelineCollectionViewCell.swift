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
        stackView.spacing = 0
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
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    let titleLabel: UILabel = {
       let label = UILabel()
        
        return label
    }()
    
    let memoLabel: UILabel = {
       let label = UILabel()
        label.numberOfLines = 0
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
        backgroundColor = UIColor(red: 0.96, green: 0.96, blue: 0.96, alpha: 1.00)
        layer.cornerRadius = 10
    }
    
    func configureCell(memo: String?) {
        titleLabel.text = "먹이 급여"
        logoImageView.image = UIImage(systemName: "star")
        if let memo {
            memoLabel.text = memo
        } else {
            memoLabel.isHidden = true
        }
        
    }
    
    override func prepareForReuse() {
        memoLabel.isHidden = false
        titleLabel.text = nil
        memoLabel.text = nil
    }
}
