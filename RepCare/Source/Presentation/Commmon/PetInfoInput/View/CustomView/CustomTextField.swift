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
        setToolbar()
        addLeftPadding()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setLayout() {
        layer.borderWidth = 1.0
        layer.borderColor = UIColor.systemGray3.cgColor
        layer.cornerRadius = 10.0
    }
    
    override func becomeFirstResponder() -> Bool {
        layer.borderWidth = 2.0
        layer.borderColor = UIColor.black.cgColor
        return super.becomeFirstResponder()
    }
    
    override func resignFirstResponder() -> Bool {
        layer.borderWidth = 1.0
        layer.borderColor = UIColor.systemGray3.cgColor
        return super.resignFirstResponder()
    }
    
    private func addLeftPadding() {
        let paddingView = UIView(frame: .init(origin: .zero, size: .init(width: 20, height: frame.height)))
        leftView = paddingView
        leftViewMode = .always
    }

}
