//
//  TaskCollectionViewCell.swift
//  RepCare
//
//  Created by JunHwan Kim on 2023/10/15.
//

import UIKit

class TaskCollectionViewCell: UICollectionViewCell {
    static let identifier = "TaskCollectionViewCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .black
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
