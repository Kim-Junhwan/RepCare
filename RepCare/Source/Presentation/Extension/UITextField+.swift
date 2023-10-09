//
//  UITextField+.swift
//  RepCare
//
//  Created by JunHwan Kim on 2023/10/09.
//

import UIKit

extension UITextField {
    func setToolbar() {
        let toolBar = UIToolbar(frame: .init(origin: .zero, size: .init(width: bounds.width, height: 35.0)))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(tapDoneButton))
        toolBar.items = [flexibleSpace,doneButton]
        toolBar.sizeToFit()
        inputAccessoryView = toolBar
    }
    
    @objc func tapDoneButton() {
        resignFirstResponder()
    }
}
