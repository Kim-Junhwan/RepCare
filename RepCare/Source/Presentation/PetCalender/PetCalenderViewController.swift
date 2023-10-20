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
    var currentTaskList: [Int:[DetailTask]] = [:]
    var taskArr: [[DetailTask]] = []
    var taskDateArr: [Int] = []
    let pet: PetModel
    var isDateSelected: Bool = false
    var currentDate = Date()
    
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
        fetchTaskListForMonth(date: currentDate)
    }
    
    override func configureView() {
        mainView.datasource = self
        mainView.delegate = self
    }
    
    func fetchTaskListForMonth(date: Date) {
        taskArr.removeAll()
        let yearMonth = Calendar.current.dateComponents([.year,.month], from: date)
        if let year = yearMonth.year, let month = yearMonth.month {
            let fetchTaskDict = taskRepository.fetchTaskListInMonth(petId: pet.id, month: month, year: year)
            fetchTaskDict.sorted { $0.key > $1.key }.forEach { result in
                taskArr.append(result.value)
                taskDateArr.append(result.key)
            }
        }
        mainView.collectionView.reloadData()
    }
    
    func fetchTaskForDate(date: Date) {
        taskArr.removeAll()
        let fetchList = taskRepository.fetchTaskListInDate(petId: pet.id, date: date)
        if !fetchList.isEmpty {
            taskArr.append(fetchList)
        }
        mainView.collectionView.reloadData()
    }
}

extension PetCalenderViewController: PetCalenderDataSource, PetCalenderViewDelegate {
    //작업 등록
    func selectTaskCell(task: TaskModel) {
        presentRegisterViewController(task: task)
    }
    
    private func presentRegisterViewController(task: TaskModel) {
        let vc = RegisterTaskViewController(taskType: task, date: currentDate)
        vc.registerClosure = { [weak self] registDate, registTask, registStr in
            guard let self else { return }
            do {
                try self.taskRepository.registerTask(query: .init(petId: self.pet.id, taskType: registTask.toDomain(), registerDate: registDate, memo: registStr))
                if self.isDateSelected {
                    self.fetchTaskForDate(date: self.currentDate)
                } else {
                    self.fetchTaskListForMonth(date: self.currentDate)
                }
            } catch {
                print(error)
            }
        }
        let nvc = UINavigationController(rootViewController: vc)
        nvc.modalPresentationStyle = .pageSheet
        nvc.sheetPresentationController?.detents = [.medium()]
        nvc.sheetPresentationController?.widthFollowsPreferredContentSizeWhenEdgeAttached = true
        present(nvc, animated: true)
    }
    
    // 선택한 날짜에 해당하는 작업 가져오기
    func selectCalendarDate(date: Date) {
        isDateSelected = true
        fetchTaskForDate(date: date)
        currentDate = date
    }
    
    //선택된 날짜가 선택취소되는 경우 현재 calendar의 currentPage의 작업 가져오기
    func deselectCalendarDate(date: Date) {
        isDateSelected = false
        fetchTaskListForMonth(date: date)
        currentDate = date
    }
    
    //현재 캘린더의 달이 변경되었을때 수행
    func changeCalenderMonth(date: Date) {
        let changeMonth = Calendar.current.dateComponents([.year,.month], from: date)
        let selectedMonth = Calendar.current.dateComponents([.year, .month], from: currentDate)
        if isDateSelected  && (changeMonth == selectedMonth) {
            fetchTaskForDate(date: currentDate)
        } else {
            fetchTaskListForMonth(date: date)
        }
        
    }
    
    //작업이 존재하는 일의 개수
    func numberOfDaysInTask() -> Int {
        return taskArr.count
    }
    
    // 작업이 존재한 일에 작업한 작업의 개수
    func numberOfTask(section: Int) -> Int {
        return taskArr[section].count
    }
    
    //섹션 헤더에 넣을 작업이 존재하는 일(day)를 전달
    func date(section: Int) -> Date {
        return taskArr[section].first?.registerDate ?? Date()
    }
    
    func detailTaskToDay(section: Int, row: Int) -> DetailTaskModel {
        return .init(detailTask: taskArr[section][row])
    }
    
}
