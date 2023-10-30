//
//  PetListView.swift
//  RepCare
//
//  Created by JunHwan Kim on 2023/10/02.
//

import UIKit
import SnapKit

protocol PetListViewDelegate: AnyObject {
    func selectPetClass(petClass: PetClassModel)
    func selectPet(at index: Int)
    func reloadPetList(completion: @escaping () -> Void)
    func searchPetList(searchKeyword: String)
    func tapFilterButton()
    func loadNextPage(completion: (()-> Void)?)
}

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
        searchBar.searchTextField.setToolbar()
        searchBar.placeholder = "종 혹은 개체 이름을 입력하세요"
        return searchBar
    }()
    
    let filterButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.image = UIImage(systemName: "slider.horizontal.3")?.withRenderingMode(.alwaysTemplate)
        let button = UIButton(configuration: config)
        button.tintColor = .black
       return button
    }()
    
    let emptyLabel: UILabel = {
        let label = UILabel()
        label.text = "등록된 개체가 없습니다. 우측 상단 버튼을 눌러 등록해주세요."
        label.numberOfLines = 0
        label.font = .boldSystemFont(ofSize: 20)
        label.textColor = .systemGray4
        return label
    }()
    
    lazy var petClassCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: makePetClassCollectionViewLayout())
        collectionView.register(PetClassCollectionViewCell.self, forCellWithReuseIdentifier: PetClassCollectionViewCell.identifier)
        collectionView.delegate = self
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    lazy var petListCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: .init())
        collectionView.register(PetCollectionViewCell.self, forCellWithReuseIdentifier: PetCollectionViewCell.identifier)
        collectionView.delegate = self
        collectionView.refreshControl = .init()
        collectionView.refreshControl?.addTarget(self, action: #selector(updatePetList), for: .valueChanged)
        return collectionView
    }()
    
    let footerRefreshView: UIActivityIndicatorView = {
       let view = UIActivityIndicatorView()
        view.hidesWhenStopped = false
        return view
    }()
    
    weak var delegate: PetListViewDelegate?
    var isFetching = false
    
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
    
    private func configureView() {
        addSubview(searchBarStackView)
        addSubview(emptyLabel)
        searchBarStackView.addArrangedSubview(searchBar)
        searchBarStackView.addArrangedSubview(filterButton)
        addSubview(petClassCollectionView)
        addSubview(petListCollectionView)
        addSubview(footerRefreshView)
        searchBar.delegate = self
        filterButton.addTarget(self, action: #selector(tapFilterButton), for: .touchUpInside)
    }
    
    private func setConstraints() {
        emptyLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.leading.trailing.lessThanOrEqualToSuperview().inset(30)
        }
        
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
        footerRefreshView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(0)
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
        let itemWidth = (viewWidth/2) - 15.0
        flowLayout.itemSize = CGSize(width: itemWidth, height: itemWidth * 1.4)
        flowLayout.scrollDirection = .vertical
        flowLayout.minimumInteritemSpacing = 10.0
        flowLayout.sectionInset = .init(top: 10, left: 10.0, bottom: .zero, right: 10.0)
        flowLayout.minimumLineSpacing = 10.0
        flowLayout.minimumInteritemSpacing = 10.0
        return flowLayout
    }
    
    @objc func tapFilterButton() {
        delegate?.tapFilterButton()
    }
    
    @objc func updatePetList() {
        delegate?.reloadPetList {
            self.petListCollectionView.refreshControl?.endRefreshing()
        }
    }
    
    func setFilterButtonIsFilteringStatus(isFiltering: Bool) {
        if isFiltering {
            filterButton.tintColor = .lightDeepGreen
        } else {
            filterButton.tintColor = .black
        }
    }
}

extension PetListView: UICollectionViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentOffset = scrollView.contentOffset.y+scrollView.frame.height - scrollView.safeAreaInsets.bottom
        let startAnimatingHeight: CGFloat = 80
        
        let contentSizeHeight = max(scrollView.contentSize.height, scrollView.frame.height)
        let isBottomScroll = currentOffset > contentSizeHeight //스크롤이 contentSize보다 더 스크롤 중인가?
        let playIndicatorAnimation = currentOffset >= contentSizeHeight + startAnimatingHeight //indicator 애니메이션을 실행 할 시점
        
        if isBottomScroll {
            footerRefreshView.isHidden = false
            if playIndicatorAnimation {
                isFetching = true
                footerRefreshView.startAnimating()
            } else {
                isFetching = false
                footerRefreshView.stopAnimating()
            }
            footerRefreshView.snp.updateConstraints { make in
                make.height.equalTo(currentOffset - contentSizeHeight)
            }
            footerRefreshView.alpha = (footerRefreshView.frame.height / startAnimatingHeight)
        } else {
            footerRefreshView.isHidden = true
        }
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if isFetching {
            scrollView.setContentOffset(.init(x: .zero, y: scrollView.contentSize.height+80), animated: true)
            delegate?.loadNextPage(completion: nil)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == petClassCollectionView {
            delegate?.selectPetClass(petClass: .init(rawValue: indexPath.row) ?? .all)
        } else if collectionView == petListCollectionView {
            delegate?.selectPet(at: indexPath.row)
        }
    }
}

extension PetListView: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        delegate?.searchPetList(searchKeyword: searchText)
    }
}
