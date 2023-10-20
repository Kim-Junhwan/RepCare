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
}

class PetCalenderView: UIView {
    
    enum Section: Int {
        case task
        case calender
        case timeline
    }

    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: makeCollectionViewLayout())
        collectionView.register(TaskCollectionViewCell.self, forCellWithReuseIdentifier: TaskCollectionViewCell.identifier)
        collectionView.register(TimelineCollectionViewCell.self, forCellWithReuseIdentifier: TimelineCollectionViewCell.identifier)
        collectionView.register(CalenderHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CalenderHeaderView.identifier)
        collectionView.register(TimeLineHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: TimeLineHeaderView.identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.isScrollEnabled = false
        collectionView.bounces = false
        collectionView.contentInsetAdjustmentBehavior = .never
        return collectionView
    }()
    
    private let dateFormatter: DateFormatter = {
       let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM월 dd일"
        return dateFormatter
    }()
    
    weak var delegate: PetCalenderViewDelegate?
    weak var datasource: PetCalenderDataSource?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
        setConstrains()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
            let sectionKind = Section(rawValue: sectionIndex) ?? .timeline
            let section: NSCollectionLayoutSection
            if sectionKind == .task {
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(65), heightDimension: .absolute(65))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
                section.interGroupSpacing = 10
                section.contentInsets = .init(top: 10, leading: 10, bottom: 20, trailing: 10)
            } else if sectionKind == .calender {
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                section = NSCollectionLayoutSection(group: group)
                let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(200))
                let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .topLeading)
                section.boundarySupplementaryItems = [sectionHeader]
            } else if sectionKind == .timeline {
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(50))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(50.0))
                let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
                section = NSCollectionLayoutSection(group: group)
                section.interGroupSpacing = 10
                let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(50))
                let timeLineHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .topLeading)
                section.boundarySupplementaryItems = [timeLineHeader]
                section.interGroupSpacing = 10.0
                section.contentInsets = .init(top: 0, leading: 10, bottom: 0, trailing: 10)
            } else {
                fatalError("Unknown Section")
            }
            return section
        }
        let layout = UICollectionViewCompositionalLayout(sectionProvider: sectionProvier)
        return layout
    }
}

extension PetCalenderView: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        let sectionCount = datasource?.numberOfDaysInTask() ?? 0
        return sectionCount+2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let datasource else { return 0 }
        if section == 0 {
            return TaskModel.allCases.count
        } else if section == 1 {
            return 0
        }
        return datasource.numberOfTask(section: section-2)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.section == 0 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TaskCollectionViewCell.identifier, for: indexPath) as? TaskCollectionViewCell else { return .init() }
            guard let task = TaskModel(rawValue: indexPath.row) else { return .init() }
            cell.configureCell(task: task)
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TimelineCollectionViewCell.identifier, for: indexPath) as? TimelineCollectionViewCell else { return .init() }
            guard let detailTask = datasource?.detailTaskToDay(section: indexPath.section-2, row: indexPath.row) else { return .init() }
            cell.configureCell(detailTask: detailTask)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if indexPath.section == 1 {
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CalenderHeaderView.identifier, for: indexPath) as? CalenderHeaderView else { return .init() }
            header.fsCalendar.delegate = self
            if collectionView.numberOfSections == 2 {
                header.emptyView.isHidden = false
            } else {
                header.emptyView.isHidden = true
            }
            return header
        }
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: TimeLineHeaderView.identifier, for: indexPath) as? TimeLineHeaderView else { return .init() }
        guard let sectionDate = datasource?.date(section: indexPath.section-2) else { return TimeLineHeaderView() }
        header.dateLabel.text = dateFormatter.string(from: sectionDate)
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            guard let task = TaskModel(rawValue: indexPath.row) else { return }
            delegate?.selectTaskCell(task: task)
        }
    }
}

extension PetCalenderView: FSCalendarDelegate {
    
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
