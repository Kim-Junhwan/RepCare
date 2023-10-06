//
//  CustomTextField.swift
//  RepCare
//
//  Created by JunHwan Kim on 2023/10/05.
//

import UIKit

class CustomTextField: UITextField {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setLayout() {
        if isFirstResponder {
            layer.borderWidth = 2.0
            layer.borderColor = UIColor.black.cgColor
        } else {
            layer.borderWidth = 1.0
            layer.borderColor = UIColor.systemGray3.cgColor
        }
        
    }
    
    

}
