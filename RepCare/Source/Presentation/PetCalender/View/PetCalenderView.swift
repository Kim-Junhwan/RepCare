//
//  PetCalenderView.swift
//  RepCare
//
//  Created by JunHwan Kim on 2023/10/15.
//

import UIKit
import FSCalendar

protocol PetCalenderViewDelegate: AnyObject {
    func selectCalenderDate(date: Date)
    func changeCalenderMonth(month: Int, year: Int)
    func selectTaskCell(date: Date, task: TaskModel)
}

protocol PetCalenderDataSource: AnyObject {
    func numberOfTask(date: Date) -> Int
    func numberOfDaysInTask() -> Int
    func date(section: Int) -> Date
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
    var currentDate = Date()
    
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
        return (datasource?.numberOfDaysInTask() ?? 0)+2 
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let datasource else { return 0 }
        if section == 0 {
            return TaskModel.allCases.count
        } else if section == 1 {
            return 0
        }
        return datasource.numberOfTask(date: Date())
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.section == 0 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TaskCollectionViewCell.identifier, for: indexPath) as? TaskCollectionViewCell else { return .init() }
            guard let task = TaskModel(rawValue: indexPath.row) else { return .init() }
            cell.configureCell(task: task)
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TimelineCollectionViewCell.identifier, for: indexPath) as? TimelineCollectionViewCell else { return .init() }
            cell.configureCell(memo: " \(indexPath.section) ,\(indexPath.row)")
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if indexPath.section == 1 {
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CalenderHeaderView.identifier, for: indexPath) as? CalenderHeaderView else { return .init() }
            header.fsCalendar.delegate = self
            return header
        }
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: TimeLineHeaderView.identifier, for: indexPath) as? TimeLineHeaderView else { return .init() }
        guard let sectionDate = datasource?.date(section: indexPath.section) else { return .init() }
        header.dateLabel.text = sectionDate.description
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            guard let task = TaskModel(rawValue: indexPath.row) else { return }
            delegate?.selectTaskCell(date: currentDate, task: task)
        }
    }
}

extension PetCalenderView: FSCalendarDelegate {
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let convertDate = date.convertDateToKoreaLocale()
        if convertDate == currentDate {
            calendar.deselect(date)
            currentDate = Date()
        } else {
            currentDate = convertDate
            delegate?.selectCalenderDate(date: currentDate)
        }
    }
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        let currentMonthYear = Calendar.current.dateComponents([.month, .year], from: calendar.currentPage.convertDateToKoreaLocale())
        if let month = currentMonthYear.month, let year = currentMonthYear.year {
            delegate?.changeCalenderMonth(month: month, year: year)
        }
    }
    
}
