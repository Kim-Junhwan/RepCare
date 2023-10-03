//
//  PetListView.swift
//  RepCare
//
//  Created by JunHwan Kim on 2023/10/02.
//

import UIKit
import SnapKit

final class PetListView: UIView {
    
    enum Section: Int {
        case petClass
        case petList
    }
    
    private enum Metric {
        static let petClassCellWidth = 80.0
        static let petClassCellHeight = 100.0
        static let sectionInset = 10.0
    }
    
    static let searchHeaderElementKind = "searchHeaderElementKind"
    
    
    
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createCollectionViewLayout())
        collectionView.minimumZoomScale = 0
        return collectionView
    }()

    var dataSource: UICollectionViewDiffableDataSource<Section, Int>?
    
    let addPetButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.image = UIImage(systemName: "plus")
        config.baseForegroundColor = .white
        config.baseBackgroundColor = .lightDeepGreen
        let button = UIButton(configuration: config)
        button.clipsToBounds = true
       return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
        setConstraints()
        configureDatasource()
        var snapshot = NSDiffableDataSourceSnapshot<Section, Int>()
        snapshot.appendSections([.petClass, .petList])
        snapshot.appendItems([1,2,3], toSection: .petClass)
        snapshot.appendItems([4,5,6,7], toSection: .petList)
        dataSource?.apply(snapshot)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        addPetButton.layer.cornerRadius = addPetButton.frame.height/2
    }
    
    private func configureView() {
        addSubview(collectionView)
        addSubview(addPetButton)
    }
    
    private func setConstraints() {
        addPetButton.snp.makeConstraints { make in
            make.width.height.equalTo(70)
            make.bottom.trailing.equalTo(safeAreaLayoutGuide).inset(20)
        }
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(safeAreaLayoutGuide)
        }
    }
    
    private func createCollectionViewLayout() -> UICollectionViewLayout {
        let sectionProvier = { (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            guard let sectionKind = Section(rawValue: sectionIndex) else { return nil }
            let section: NSCollectionLayoutSection
            if sectionKind == .petClass {
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(80.0), heightDimension: .absolute(100.0))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(70.0))
                let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: PetListView.searchHeaderElementKind, alignment: .top)
                section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
                section.interGroupSpacing = 10.0
                section.boundarySupplementaryItems = [sectionHeader]
                section.contentInsets = .init(top: .zero, leading: 10.0, bottom: .zero, trailing: 10.0)
            } else if sectionKind == .petList {
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1.0))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(0.6))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                group.interItemSpacing = .flexible(20)
                section = NSCollectionLayoutSection(group: group)
                section.interGroupSpacing = 10.0
                section.contentInsets = .init(top: 20, leading: 10, bottom: 20, trailing: 10)
            } else {
                fatalError("Unknown section")
            }
            return section
        }
        return UICollectionViewCompositionalLayout(sectionProvider: sectionProvier)
    }
    
    func createPetClassCellRegistration() -> UICollectionView.CellRegistration<PetClassCollectionViewCell, Int> {
        return UICollectionView.CellRegistration<PetClassCollectionViewCell, Int> { cell, indexPath, itemIdentifier in
            cell.classLabel.text = "\(indexPath.row)"
        }
    }
    
    func createPetListCellRegistration() -> UICollectionView.CellRegistration<PetCollectionViewCell, Int> {
        return UICollectionView.CellRegistration<PetCollectionViewCell, Int> { cell, indexPath, itemIdentifier in
            cell.nameLabel.text = "\(indexPath.row)"
        }
    }
    
    func createHeaderViewRegistration() -> UICollectionView.SupplementaryRegistration<SearchHeaderView> {
        return UICollectionView.SupplementaryRegistration<SearchHeaderView>(elementKind: PetListView.searchHeaderElementKind) { supplementaryView, elementKind, indexPath in
            
        }
    }
    
    func configureDatasource() {
        let petClassRegistration = createPetClassCellRegistration()
        let headerRegistration = createHeaderViewRegistration()
        let petListRegistration = createPetListCellRegistration()
        
        dataSource = UICollectionViewDiffableDataSource<Section, Int>(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            guard let section = Section(rawValue: indexPath.section) else { return UICollectionViewCell()}
            switch section {
            case .petClass:
                return collectionView.dequeueConfiguredReusableCell(using: petClassRegistration, for: indexPath, item: itemIdentifier)
            case .petList:
                return collectionView.dequeueConfiguredReusableCell(using: petListRegistration, for: indexPath, item: itemIdentifier)
            }
        })
        
        dataSource?.supplementaryViewProvider = { (view, kind, index) in
            return self.collectionView.dequeueConfiguredReusableSupplementary(using: headerRegistration, for: index)
        }
    }
}
