//
//  PetCalenderViewController.swift
//  RepCare
//
//  Created by JunHwan Kim on 2023/10/15.
//

import Foundation
import UIKit

final class PetCalenderViewController: BaseViewController {
    
    let mainView = PetCalenderView()
    let taskRepository: TaskRepository
    let pet: PetModel
    
    init(taskRepository: TaskRepository, pet: PetModel) {
        self.taskRepository = taskRepository
        self.pet = pet
        super.init(nibName: nil, bundle: nil)
        title = "캘린더 / 타임라인"
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
    
    
    func selectTaskCell(date: Date, task: TaskModel) {
        
    }
    
    func selectCalenderDate(date: Date) {
        
    }
    
    //현재 캘린더의 달이 변경되었을때 수행
    func changeCalenderMonth(month: Int, year: Int) {
        print(taskRepository.fetchTaskListInMonth(petId: pet.id, month: month, year: year))
    }
    
    //작업이 존재하는 일의 개수
    func numberOfDaysInTask() -> Int {
        return 2
    }
    
    // 작업이 존재한 일에 작업한 작업의 개수
    func numberOfTask(date: Date) -> Int {
        return 10
    }
    
    //섹션 헤더에 넣을 작업이 존재하는 일을 전달
    func date(section: Int) -> Date {
        return Date()
    }
    
}
