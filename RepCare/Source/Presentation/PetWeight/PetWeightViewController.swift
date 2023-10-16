//
//  PetWeightViewController.swift
//  RepCare
//
//  Created by JunHwan Kim on 2023/10/15.
//

import Foundation

final class PetWeightViewController: BaseViewController {
    init() {
        super.init(nibName: nil, bundle: nil)
        title = "체중"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
