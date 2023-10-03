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
    
    let searchBar: UISearchBar = {
       let searchBar = UISearchBar()
        searchBar.searchBarStyle = .minimal
        return searchBar
    }()
    
    let filterButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.image = UIImage(systemName: "slider.horizontal.3")
        config.baseForegroundColor = .black
            
       return UIButton(configuration: config)
    }()
    
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createCollectionViewLayout())
        
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
        snapshot.appendSections([.petClass])
        snapshot.appendItems([1,2,3])
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
        addSubview(searchBar)
        addSubview(filterButton)
        addSubview(collectionView)
        addSubview(addPetButton)
    }
    
    private func setConstraints() {
        filterButton.snp.makeConstraints { make in
            make.width.height.equalTo(50)
            make.top.trailing.equalTo(safeAreaLayoutGuide)
        }
        searchBar.snp.makeConstraints { make in
            make.top.leading.equalTo(safeAreaLayoutGuide)
            make.trailing.equalTo(filterButton.snp_leadingMargin)
        }
        addPetButton.snp.makeConstraints { make in
            make.width.height.equalTo(70)
            make.bottom.trailing.equalTo(safeAreaLayoutGuide).inset(20)
        }
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(10)
            make.leading.trailing.bottom.equalTo(safeAreaLayoutGuide)
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
                section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
                section.interGroupSpacing = 10.0
                section.contentInsets = .init(top: .zero, leading: 10.0, bottom: .zero, trailing: 10.0)
            } else if sectionKind == .petList {
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1.0))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(100.0))
                let group = NSCollectionLayoutGroup(layoutSize: groupSize)
                section = NSCollectionLayoutSection(group: group)
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
    
    func configureDatasource() {
        let petClassRegistration = createPetClassCellRegistration()
        
        dataSource = UICollectionViewDiffableDataSource<Section, Int>(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            guard let section = Section(rawValue: indexPath.section) else { return UICollectionViewCell()}
            switch section {
            case .petClass:
                return collectionView.dequeueConfiguredReusableCell(using: petClassRegistration, for: indexPath, item: itemIdentifier)
            case .petList:
                return collectionView.dequeueConfiguredReusableCell(using: petClassRegistration, for: indexPath, item: itemIdentifier)
            }
        })
    }
}
