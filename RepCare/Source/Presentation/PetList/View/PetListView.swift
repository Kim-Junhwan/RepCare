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
    
    let searchBarStackView: UIStackView = {
       let stackView = UIStackView()
        stackView.spacing = 0
        stackView.distribution = .fill
        stackView.alignment = .center
        return stackView
    }()
    
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
        collectionView.register(PetClassCollectionViewCell.self, forCellWithReuseIdentifier: PetClassCollectionViewCell.identifier)
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    lazy var petListCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: .init())
        collectionView.register(PetCollectionViewCell.self, forCellWithReuseIdentifier: PetCollectionViewCell.identifier)
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
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        petListCollectionView.collectionViewLayout = makePetListCollectionViewLayout()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        addPetButton.layer.cornerRadius = addPetButton.frame.height/2
    }
    
    private func configureView() {
        addSubview(searchBarStackView)
        searchBarStackView.addArrangedSubview(searchBar)
        searchBarStackView.addArrangedSubview(filterButton)
        addSubview(petClassCollectionView)
        addSubview(petListCollectionView)
        addSubview(addPetButton)
    }
    
    private func setConstraints() {
        searchBarStackView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(safeAreaLayoutGuide)
            make.height.equalTo(50)
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
        let flowLayout = UICollectionViewFlowLayout()
        let viewWidth = frame.width
        let itemWidth = (viewWidth/2) - 20.0
        flowLayout.itemSize = CGSize(width: itemWidth, height: itemWidth * 1.5)
        flowLayout.scrollDirection = .vertical
        flowLayout.minimumInteritemSpacing = 10.0
        flowLayout.sectionInset = .init(top: .zero, left: 10.0, bottom: .zero, right: 10.0)
        flowLayout.minimumLineSpacing = 10.0
        return flowLayout
    }
}
