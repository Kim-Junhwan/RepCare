//
//  SpeciesView.swift
//  RepCare
//
//  Created by JunHwan Kim on 2023/10/05.
//

import UIKit

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
    
    var dataSource: UICollectionViewDiffableDataSource<Section, Item>?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureDatasource(dataSource: UICollectionViewDiffableDataSource<Section, Item>?) {
        self.dataSource = dataSource
        
        let headerRegistration = UICollectionView.SupplementaryRegistration<SpeciesHeaderView>(elementKind: ElementKind.sectionHeader) { supplementaryView, elementKind, indexPath in
            guard let section = Section(rawValue: indexPath.section) else { return }
            if section == .petClass {
                supplementaryView.descriptionLabel.isHidden = false
                supplementaryView.descriptionLabel.text = "※ 종 / 상세 종 / 모프를 꾹 눌러서 수정 및 삭제할 수 있습니다."
            }
            supplementaryView.titleLabel.text = section.title
        }
        dataSource?.supplementaryViewProvider = { (collectionView, elementKind, indexPath) in
            return collectionView.dequeueConfiguredReusableSupplementary(using: headerRegistration, for: indexPath)
        }
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
        section.contentInsets = .init(top: 0, leading: 10, bottom: 0, trailing: 10)
        section.boundarySupplementaryItems = [sectionHeader]
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 10
        return UICollectionViewCompositionalLayout(section: section, configuration: config)
    }
    
    private func configureView() {
        addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func applyData(section: [Section: [Item]]) {
        dataSource?.apply(appendSection(section: section), animatingDifferences: true)
    }
    
    func appendSection(section: [Section: [Item]]) -> NSDiffableDataSourceSnapshot<Section, Item> {
        var snapShot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapShot.appendSections(Section.allCases)
        for i in section {
            snapShot.appendItems(i.value, toSection: i.key)
        }
        return snapShot
    }
    
    func reloadSection(section: Section) {
        guard let dataSource else { return }
        var currentSnapshot = dataSource.snapshot()
        currentSnapshot.reloadSections([section])
        dataSource.apply(currentSnapshot)
    }
    
}


