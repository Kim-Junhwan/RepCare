//
//  BaseViewController.swift
//  RepCare
//
//  Created by JunHwan Kim on 2023/10/02.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        configureView()
        setContraints()
    }
    
    func configureView() {
        
    }
    
    func setContraints() {
        
    }
    
    func showErrorAlert(title: String?, message: String?, action: ((UIAlertAction) -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "확인", style: .default, handler: action)
        alert.addAction(ok)
        present(alert, animated: true)
    }
    
    func tapViewEndEdit() {
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(endEdit)))
    }

    @objc func endEdit() {
        view.endEditing(true)
    }
}
