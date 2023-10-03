//
//  SearchHeaderView.swift
//  RepCare
//
//  Created by JunHwan Kim on 2023/10/03.
//

import UIKit

class SearchHeaderView: UICollectionReusableView {
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureView() {
        addSubview(searchBar)
        addSubview(filterButton)
        filterButton.snp.makeConstraints { make in
            make.width.height.equalTo(50)
            make.top.trailing.equalTo(safeAreaLayoutGuide)
        }
        searchBar.snp.makeConstraints { make in
            make.top.leading.equalTo(safeAreaLayoutGuide)
            make.trailing.equalTo(filterButton.snp_leadingMargin)
        }
    }
}
