//
//  PetCalenderView.swift
//  RepCare
//
//  Created by JunHwan Kim on 2023/10/15.
//

import UIKit
import FSCalendar

protocol PetCalenderViewDelegate: AnyObject {
    func selectCalendarDate(date: Date)
    func changeCalenderMonth(date: Date)
    func selectTaskCell(task: TaskModel)
    func deselectCalendarDate(date: Date)
}

protocol PetCalenderDataSource: AnyObject {
    func numberOfTask(section: Int) -> Int
    func numberOfDaysInTask() -> Int
    func date(section: Int) -> Date
    func detailTaskToDay(section: Int, row: Int) -> DetailTaskModel
    func numberOfEventOnDay(date: Date) -> Int
    func dayEventColor(date: Date) -> [UIColor]?
    
}

enum CalendarSectionType: Int {
    case task
    case calendar
    case timeline
    case empty
}

enum ItemType {
    case task
    case timeline
}

struct CalendarCollectioViewSectionItem: Hashable {
    let id: String
    let type: CalendarSectionType
}

struct CalendarCollectionViewItem: Hashable {
    let id: String
    let taskType: ItemType
}

class PetCalenderView: UIView {
    
    static let calendarHeaderElementKind = "CalendatHeaderElemendKind"
    static let timeLineHeaderElementKind = "TimeLineHeaderElementKind"
    static let emptyHeaderElementKind = "EmptyHeaderElementKind"

    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: makeCollectionViewLayout())
        collectionView.delegate = self
        collectionView.isScrollEnabled = false
        collectionView.bounces = false
        collectionView.contentInsetAdjustmentBehavior = .never
        return collectionView
    }()
    
    private var isTimeLineEmpty = true
    weak var calendar: FSCalendar?
    weak var isEmptyView: CalenderHeaderView?
    weak var delegate: PetCalenderViewDelegate?
    weak var datasource: PetCalenderDataSource?
    var collectionViewDatasource: UICollectionViewDiffableDataSource<CalendarCollectioViewSectionItem, CalendarCollectionViewItem>?
    
    var currentSnapShot: NSDiffableDataSourceSnapshot<CalendarCollectioViewSectionItem, CalendarCollectionViewItem> = {
        var snapShot = NSDiffableDataSourceSnapshot<CalendarCollectioViewSectionItem, CalendarCollectionViewItem>()
        let taskSection = CalendarCollectioViewSectionItem(id: UUID().uuidString, type: .task)
        let calendarSection = CalendarCollectioViewSectionItem(id: UUID().uuidString, type: .calendar)
        var taskItems: [CalendarCollectionViewItem] = []
        for i in TaskModel.allCases {
            taskItems.append(CalendarCollectionViewItem(id: UUID().uuidString, taskType: .task))
        }
        snapShot.appendSections([taskSection, calendarSection])
        snapShot.appendItems(taskItems, toSection: taskSection)
        return snapShot
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
        setConstrains()
        configureDatasource()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateTaskList(tasks: [Int:[DetailTaskModel]]) {
        currentSnapShot.deleteSections(currentSnapShot.sectionIdentifiers.filter { $0.type == .timeline || $0.type == .empty })
        let sortedTasks = tasks.sorted { $0.key > $1.key }
        if tasks.count <= 1  {
            if tasks.first?.value.count ?? 0 == 0  {
                isTimeLineEmpty = true
            } else {
                isTimeLineEmpty = false
            }
        } else {
            isTimeLineEmpty = false
        }
        for task in sortedTasks {
            if task.value.isEmpty {
                currentSnapShot.appendSections([CalendarCollectioViewSectionItem(id: UUID().uuidString, type: .empty)])
                continue
            }
            let dateSection = CalendarCollectioViewSectionItem(id: "\(task.key)", type: .timeline)
            currentSnapShot.appendSections([dateSection])
            currentSnapShot.appendItems(task.value.map{.init(id: $0.id, taskType: .timeline)}, toSection: dateSection)
        }
        collectionViewDatasource?.apply(currentSnapShot)
    }
    
    func configureDatasource() {
        let taskCellRegistration = UICollectionView.CellRegistration<TaskCollectionViewCell, TaskModel> { (cell, indexPath, task) in
            cell.configureCell(task: task)
        }
        
        let timeCellRegistration = UICollectionView.CellRegistration<TimelineCollectionViewCell, DetailTaskModel> { (cell, indexPath, detailTask) in
            cell.configureCell(detailTask: detailTask)
        }
        
        let calendarHeaderRegistration = UICollectionView.SupplementaryRegistration<CalenderHeaderView>(elementKind: PetCalenderView.calendarHeaderElementKind) { supplementaryView, elementKind, indexPath in
            supplementaryView.fsCalendar.delegate = self
            supplementaryView.fsCalendar.dataSource = self
            self.calendar = supplementaryView.fsCalendar
            self.isEmptyView = supplementaryView
        }
        
        let emptyHeaderRegistration = UICollectionView.SupplementaryRegistration<EmptyHeaderView>(elementKind: PetCalenderView.emptyHeaderElementKind) { supplementaryView, elementKind, indexPath in
        }
        
        let timeLineHeaderRegistration = UICollectionView.SupplementaryRegistration<TimeLineHeaderView>(elementKind: PetCalenderView.timeLineHeaderElementKind) { supplementaryView, elementKind, indexPath in
            guard let sectionDate = self.datasource?.date(section: indexPath.section-2) else { return }
            supplementaryView.dateLabel.text = DateFormatter.monthDateFormatter.string(from: sectionDate)
        }
        
        collectionViewDatasource = UICollectionViewDiffableDataSource<CalendarCollectioViewSectionItem, CalendarCollectionViewItem>(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            if itemIdentifier.taskType == .task {
                return collectionView.dequeueConfiguredReusableCell(using: taskCellRegistration, for: indexPath, item: TaskModel(rawValue: indexPath.row))
            }
            return collectionView.dequeueConfiguredReusableCell(using: timeCellRegistration, for: indexPath, item: self.datasource?.detailTaskToDay(section: indexPath.section-2, row: indexPath.row))
        })
        
        collectionViewDatasource?.supplementaryViewProvider = { (view, kind, index) in
            if kind == PetCalenderView.calendarHeaderElementKind {
                return self.collectionView.dequeueConfiguredReusableSupplementary(using: calendarHeaderRegistration, for: index)
            } else if kind == PetCalenderView.emptyHeaderElementKind {
                return self.collectionView.dequeueConfiguredReusableSupplementary(using: emptyHeaderRegistration, for: index)
            }
            return self.collectionView.dequeueConfiguredReusableSupplementary(using: timeLineHeaderRegistration, for: index)
        }
    }
    
    private func configureView() {
        addSubview(collectionView)
    }

    private func setConstrains() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(safeAreaLayoutGuide)
        }
    }
    
    private func makeCollectionViewLayout() -> UICollectionViewLayout {
        let sectionProvier = { (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            let sectionKind: CalendarCollectioViewSectionItem
            if sectionIndex == 0 {
                sectionKind = .init(id: UUID().uuidString, type: .task)
            } else if sectionIndex == 1 {
                sectionKind = .init(id: UUID().uuidString, type: .calendar)
            } else {
                if self.isTimeLineEmpty {
                    sectionKind = .init(id: UUID().uuidString, type: .empty)
                } else {
                    guard let datasource = self.datasource else { fatalError() }
                    sectionKind = .init(id: datasource.date(section: sectionIndex-2).description, type: .timeline)
                }
            }
            
            let section: NSCollectionLayoutSection
            if sectionKind.type == .task {
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(65), heightDimension: .estimated(80))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
                section.interGroupSpacing = 10
                section.contentInsets = .init(top: 10, leading: 10, bottom: 0, trailing: 10)
            } else if sectionKind.type == .calendar {
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                section = NSCollectionLayoutSection(group: group)
                let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(200))
                let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: PetCalenderView.calendarHeaderElementKind, alignment: .topLeading)
                section.boundarySupplementaryItems = [sectionHeader]
            } else if sectionKind.type == .timeline {
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(60.0))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(60.0))
                let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
                section = NSCollectionLayoutSection(group: group)
                section.interGroupSpacing = 10
                let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(50))
                let timeLineHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: PetCalenderView.timeLineHeaderElementKind, alignment: .topLeading)
                section.boundarySupplementaryItems = [timeLineHeader]
                //section.interGroupSpacing = 10.0
                section.contentInsets = .init(top: 0, leading: 10, bottom: 0, trailing: 10)
            } else if sectionKind.type == .empty {
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                section = NSCollectionLayoutSection(group: group)
                let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(70))
                let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: PetCalenderView.emptyHeaderElementKind, alignment: .topLeading)
                section.boundarySupplementaryItems = [sectionHeader]
                section.contentInsets = .init(top: 0, leading: 10, bottom: 0, trailing: 10)
            }
            else {
                fatalError("Unknown Section")
            }
            section.contentInsets.bottom = 10
            return section
        }

        let layout = UICollectionViewCompositionalLayout(sectionProvider: sectionProvier)
        return layout
    }
}

extension PetCalenderView: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            guard let task = TaskModel(rawValue: indexPath.row) else { return }
            delegate?.selectTaskCell(task: task)
        }
    }
}

extension PetCalenderView: FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        return datasource?.numberOfEventOnDay(date: date) ?? 0
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventDefaultColorsFor date: Date) -> [UIColor]? {
        return datasource?.dayEventColor(date: date)
    }
    
    private func getYearAndMonthCurrentCalendarPage(_ calendar: FSCalendar) -> (Int, Int) {
        let currentMonthYear = Calendar.current.dateComponents([.month, .year], from: calendar.currentPage)
        if let month = currentMonthYear.month, let year = currentMonthYear.year {
            return (month, year)
        }
        return (1,1)
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        var selectedDates = calendar.selectedDates
        if calendar.selectedDates.count > 1 {
            calendar.deselect(selectedDates.removeFirst())
        }
        delegate?.selectCalendarDate(date: date)
    }
    
    func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosition: FSCalendarMonthPosition) {
        delegate?.deselectCalendarDate(date: date)
    }
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        delegate?.changeCalenderMonth(date: calendar.currentPage)
    }
    
}
