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
    
    override func configureView() {
        mainView.datasource = self
        mainView.delegate = self
    }
}

extension PetCalenderViewController: PetCalenderDataSource, PetCalenderViewDelegate {
    func selectCalenderDate(date: Date) {
        print(date)
    }
    
    func changeCalenderMonth(date: Date) {
        print(date)
    }
    
    func numberOfDaysInTask() -> Int {
        return 1
    }
    
    func numberOfTask(date: Date) -> Int {
        return 0
    }
    
}
