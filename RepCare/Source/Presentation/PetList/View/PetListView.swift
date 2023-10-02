//
//  PetListView.swift
//  RepCare
//
//  Created by JunHwan Kim on 2023/10/02.
//

import UIKit
import SnapKit

final class PetListView: UIView {
    
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
    
    lazy var petClassCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: makePetClassCollectionViewLayout())
        collectionView.register(PetClassCell.self, forCellWithReuseIdentifier: PetClassCell.identifier)
        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    lazy var petListCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: makePetListCollectionViewLayout())
        collectionView.backgroundColor = .yellow
        return collectionView
    }()
    
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
        addSubview(petClassCollectionView)
        addSubview(petListCollectionView)
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
        petClassCollectionView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp_bottomMargin).offset(10)
            make.leading.trailing.equalTo(safeAreaLayoutGuide)
            make.height.equalTo(Metric.petClassCellHeight)
        }
        petListCollectionView.snp.makeConstraints { make in
            make.top.equalTo(petClassCollectionView.snp_bottomMargin).offset(10)
            make.leading.trailing.equalTo(safeAreaLayoutGuide)
            make.bottom.equalToSuperview()
        }
        addPetButton.snp.makeConstraints { make in
            make.width.height.equalTo(70)
            make.bottom.trailing.equalTo(safeAreaLayoutGuide).inset(20)
        }
        
    }
    
    private func makePetClassCollectionViewLayout() -> UICollectionViewLayout {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: Metric.petClassCellWidth, height: Metric.petClassCellHeight)
        flowLayout.scrollDirection = .horizontal
        flowLayout.sectionInset = .init(top: .zero, left: Metric.sectionInset, bottom: .zero, right: Metric.sectionInset)
        flowLayout.minimumLineSpacing = 10.0
        return flowLayout
    }
    
    private func makePetListCollectionViewLayout() -> UICollectionViewLayout {
        return UICollectionViewFlowLayout()
    }
}

extension PetListView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PetClassCell.identifier, for: indexPath) as? PetClassCell else { return .init() }
        
        return cell
    }
    
    
}
