//
//  TimeLineHeaderView.swift
//  RepCare
//
//  Created by JunHwan Kim on 2023/10/17.
//

import Foundation
import UIKit

class TimeLineHeaderView: UICollectionReusableView {
    
    static let identifier = "TimeLineHeaderView"
    
    let dateLabel: UILabel = {
       let label = UILabel()
        
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
        addSubview(dateLabel)
        dateLabel.snp.makeConstraints { make in
            make.bottom.trailing.leading.equalToSuperview().inset(10)
        }
    }
}
