//
//  RegisterNewPetViewController.swift
//  RepCare
//
//  Created by JunHwan Kim on 2023/10/04.
//

import UIKit

class RegisterNewPetViewController: BaseViewController {
    
    let mainView = RegisterPetView()
    
    lazy var registerButton: UIBarButtonItem = {
        let barButton = UIBarButtonItem(title: "등록", style: .plain, target: self, action: #selector(tapRegisterButton))
        return barButton
    }()
    
    override func loadView() {
        view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func configureView() {
        title = "개체 등록"
        navigationItem.setRightBarButton(registerButton, animated: false)
    }
    
    @objc func tapRegisterButton() {
        
    }

}
