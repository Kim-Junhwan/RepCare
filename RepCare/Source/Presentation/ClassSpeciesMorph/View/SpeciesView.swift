//
//  SpeciesView.swift
//  RepCare
//
//  Created by JunHwan Kim on 2023/10/05.
//

import UIKit

protocol SpeciesViewDelegate: AnyObject {
    func getSectionItemCount(section: Section) -> Int
}

class SpeciesView: UIView {
    
    private enum Metric {
        static let estimateCellWidth = 44.0
        static let estimateCellHeight = 44.0
    }
    
    private enum ElementKind {
        static let sectionHeader = "SpeciesHeaderView"
    }
    
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: makeCollectionViewLayout())
        collectionView.allowsMultipleSelection = true
        collectionView.register(RegisterCollectionViewCell.self, forCellWithReuseIdentifier: RegisterCollectionViewCell.identifier)
        return collectionView
    }()
    
    private var dataSource: UICollectionViewDiffableDataSource<Section, Item>?
    weak var delegate: SpeciesViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureDataSource()
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func makeCollectionViewLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .estimated(Metric.estimateCellWidth), heightDimension: .estimated(Metric.estimateCellHeight))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(Metric.estimateCellHeight))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.interItemSpacing = .fixed(10)
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 10
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(50))
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: ElementKind.sectionHeader, alignment: .top)
        
        section.boundarySupplementaryItems = [sectionHeader]
        
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    private func configureView() {
        addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func configureDataSource() {
        
        let cellRegistration = UICollectionView.CellRegistration<SpeciesCell, Item> { cell, indexPath, itemIdentifier in
            cell.titleLabel.text = itemIdentifier.title
        }
        
        let headerRegistration = UICollectionView.SupplementaryRegistration<SpeciesHeaderView>(elementKind: ElementKind.sectionHeader) { supplementaryView, elementKind, indexPath in
            supplementaryView.titleLabel.text = Section(rawValue: indexPath.section)?.title
        }
        
        dataSource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            guard let section = Section(rawValue: indexPath.section), let delegate = self.delegate else { return .init() }
            if itemIdentifier.isRegisterCell {
                return collectionView.dequeueReusableCell(withReuseIdentifier: RegisterCollectionViewCell.identifier, for: indexPath)
            }
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
        })
        
        dataSource?.supplementaryViewProvider = { (collectionView, elementKind, indexPath) in
            return collectionView.dequeueConfiguredReusableSupplementary(using: headerRegistration, for: indexPath)
        }
        
    }
    
    func applyData(section: [Section: [Item]]) {
        var snapShot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapShot.appendSections(Section.allCases)
        for i in section {
            snapShot.appendItems(i.value, toSection: i.key)
        }
        dataSource?.apply(snapShot, animatingDifferences: true)
    }
    
}
