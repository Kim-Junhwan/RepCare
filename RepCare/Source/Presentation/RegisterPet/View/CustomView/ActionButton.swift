//
//  ActionButton.swift
//  RepCare
//
//  Created by JunHwan Kim on 2023/10/05.
//

import UIKit

class ActionButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setLayout() {
        layer.borderWidth = 1.0
        layer.cornerRadius = 10.0
        layer.borderColor = UIColor.systemGray3.cgColor
        setTitleColor(.black, for: .normal)
    }
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                backgroundColor = .red
            } else {
                backgroundColor = .white
            }
        }
    }
    
}
