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
    //해당 달의 전체 작업 목록
    var currentTaskMonthList: [Int:[DetailTaskModel]] = [:]
    //선택된 일의 작업 목록
    var taskArr: [[DetailTaskModel]] = []
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
        let fetchList = fetchTaskListForMonth(date: currentDate)
        updateTaskList(tasks: fetchList)
    }
    
    override func configureView() {
        mainView.datasource = self
        mainView.delegate = self
    }
    
    func updateTaskList(tasks: [Int: [DetailTaskModel]]) {
        currentTaskMonthList = tasks
        tasks.sorted { $0.key > $1.key }.forEach { _, values in
            taskArr.append(values)
        }
        mainView.updateTaskList(tasks: tasks)
    }
    
    func resetTaskList() {
        currentTaskMonthList.removeAll()
        taskArr.removeAll()
    }
    
    private func fetchTaskListForMonth(date: Date) -> [Int: [DetailTaskModel]] {
        let yearMonth = Calendar.current.dateComponents([.year,.month], from: date)
        if let year = yearMonth.year, let month = yearMonth.month {
            let fetchTaskDict = taskRepository.fetchTaskListInMonth(petId: pet.id, month: month, year: year)
            let detailTaskModelDict: [Int: [DetailTaskModel]] = Dictionary(uniqueKeysWithValues: fetchTaskDict.map({ key, tasks in
                return (key, tasks.map({ DetailTaskModel(detailTask: $0) }))
            }))
            return detailTaskModelDict
        }
        return [:]
    }
    
    func updateTaskOnDay(date: Date, taskList: [DetailTaskModel]) {
        guard let day = Calendar.current.dateComponents([.day], from: date).day else { return }
        taskArr = [taskList]
        mainView.updateTaskList(tasks: [day:taskList])
    }
    
    func fetchTaskForDate(date: Date) -> [DetailTaskModel] {
        let fetchList = taskRepository.fetchTaskListInDate(petId: pet.id, date: date)
        return fetchList.map { .init(detailTask: $0) }
    }
    
    
}

extension PetCalenderViewController: PetCalenderDataSource, PetCalenderViewDelegate {
    
    func dayEventColor(date: Date) -> [UIColor]? {
        guard let day =  Calendar.current.dateComponents([.day], from: date).day else { return [] }
        let endIndex = min(3, currentTaskMonthList[day]?.count ?? 0)
        let events = currentTaskMonthList[day]?.prefix(endIndex)
        return events?.map({ $0.taskType.color })
    }
    
    //Calendar에 day마다 표시할 이벤트 개수
    func numberOfEventOnDay(date: Date) -> Int {
        guard let day =  Calendar.current.dateComponents([.day], from: date).day else { return 0 }
        return currentTaskMonthList[day]?.count ?? 0
    }
    
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
                updateTaskOnDay(date: currentDate, taskList: fetchTaskForDate(date: currentDate))
                
                currentTaskMonthList = fetchTaskListForMonth(date: currentDate)
                mainView.calendar?.reloadData()
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
        updateTaskOnDay(date: date, taskList: fetchTaskForDate(date: date))
        currentDate = date
    }
    
    //선택된 날짜가 선택취소되는 경우 현재 calendar의 currentPage의 작업 가져오기
    func deselectCalendarDate(date: Date) {
        isDateSelected = false
        resetTaskList()
        updateTaskList(tasks: fetchTaskListForMonth(date: date))
        currentDate = date
    }
    
    //현재 캘린더의 달이 변경되었을때 수행
    func changeCalenderMonth(date: Date) {
        let changeMonth = Calendar.current.dateComponents([.year,.month], from: date)
        let selectedMonth = Calendar.current.dateComponents([.year, .month], from: currentDate)
        resetTaskList()
        if isDateSelected  && (changeMonth == selectedMonth) {
            currentTaskMonthList = fetchTaskListForMonth(date: date)
            updateTaskOnDay(date: date, taskList: fetchTaskForDate(date: currentDate))
        } else {
            updateTaskList(tasks: fetchTaskListForMonth(date: date))
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
        return taskArr[section][row]
    }
    
}
