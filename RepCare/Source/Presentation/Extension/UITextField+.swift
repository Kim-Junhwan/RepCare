//
//  UITextField+.swift
//  RepCare
//
//  Created by JunHwan Kim on 2023/10/09.
//

import UIKit

extension UITextField {
    func setToolbar() {
        guard let window = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
        let toolWidth = window.screen.bounds.width
        let toolBar = UIToolbar(frame: .init(origin: .zero, size: .init(width: toolWidth, height: 35.0)))
        let appearance = UIToolbarAppearance()
        appearance.configureWithOpaqueBackground()
        toolBar.standardAppearance = appearance
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
