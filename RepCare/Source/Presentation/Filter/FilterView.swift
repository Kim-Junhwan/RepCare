//
//  FilterView.swift
//  RepCare
//
//  Created by JunHwan Kim on 2023/10/25.
//

import Foundation
import UIKit

final class FilterView: SpeciesView {
    
    override func appendSection(section: [Section : [Item]]) -> NSDiffableDataSourceSnapshot<Section, Item> {
        var snapShot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapShot.appendSections(Section.allCases)
        for i in section {
            snapShot.appendItems(i.value, toSection: i.key)
        }
        snapShot.appendSections([])
        return snapShot
    }
}
