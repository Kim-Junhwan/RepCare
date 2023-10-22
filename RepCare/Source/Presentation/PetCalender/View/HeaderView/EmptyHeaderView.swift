//
//  EmptyHeaderView.swift
//  RepCare
//
//  Created by JunHwan Kim on 2023/10/22.
//

import Foundation
import UIKit

final class EmptyHeaderView: UICollectionReusableView {
    let emptyLabel: UILabel = {
        let label = UILabel()
        label.text = "입력된 작업이 존재하지 않습니다."
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
        addSubview(emptyLabel)
        backgroundColor = .whiteGray
        layer.cornerRadius = 10
        clipsToBounds = true
        emptyLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(10)
        }
    }
}
