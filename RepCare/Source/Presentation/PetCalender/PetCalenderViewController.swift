//
//  PetCalenderViewController.swift
//  RepCare
//
//  Created by JunHwan Kim on 2023/10/15.
//

import Foundation

final class PetCalenderViewController: BaseViewController {
    let mainView = PetCalenderView()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        title = "캘린더 · 타임라인"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
