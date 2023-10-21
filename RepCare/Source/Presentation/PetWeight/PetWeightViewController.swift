//
//  PetWeightViewController.swift
//  RepCare
//
//  Created by JunHwan Kim on 2023/10/15.
//

import Foundation
import UIKit

final class PetWeightViewController: BaseViewController {
    
    private enum Metric {
        static let chartViewHeight: CGFloat = 400
    }
    
    enum TimeInterval: Int {
        case week
        case month
        case year
    }
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: makeCollectionViewLayout())
        collectionView.register(WeightChartView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: WeightChartView.identifier)
        collectionView.register(WeightCollectionViewCell.self, forCellWithReuseIdentifier: WeightCollectionViewCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()
    
    
    
    var dayData: [Date] = []
    let calender = Calendar.current
    private lazy var currentDate = Date()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        title = "체중"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureView() {
        view.addSubview(collectionView)
    }
    
    override func setContraints() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func makeCollectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        let width = view.frame.width
        layout.itemSize = .init(width: width, height: 50)
        return layout
    }
    
    func calculateDate(timeInterval: TimeInterval) {
        dayData.removeAll()
        if timeInterval == .week {
            for i in 0..<7 {
                if let previousDate = calender.date(byAdding: .day, value: -i, to: currentDate) {
                    dayData.append(previousDate)
                }
            }
        } else if timeInterval == .month {
            for i in 0..<30 {
                if let previousDate = calender.date(byAdding: .day, value: -i, to: currentDate) {
                    dayData.append(previousDate)
                }
            }
        } else if timeInterval == .year {
            for i in 0..<12 {
                if let previousDate = calender.date(byAdding: .month, value: -i, to: currentDate) {
                    dayData.append(previousDate)
                }
            }
        }
    }
}

extension PetWeightViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 100
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WeightCollectionViewCell.identifier, for: indexPath) as? WeightCollectionViewCell else { return .init() }
        cell.configureCell(date: Date(), weight: 10, change: 2.3)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: WeightChartView.identifier, for: indexPath) as? WeightChartView else { return .init() }
        header.datasource = self
        header.delegate = self
        return header
    }
    
}

extension PetWeightViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
            return .init(width: view.frame.width, height: Metric.chartViewHeight)
    }
}

extension PetWeightViewController: WeightChartViewDataSource, WeightChartViewDelegate {
    func getWeightDataList() -> [PetWeightModel] {
        []
    }
    
    func getDateList() -> [String] {
        return dayData.map {$0.description}
    }
    
    func getLineUnitList() -> [Double] {
       [1,2,3]
    }
    
    func tapSeguement(index: Int) {
        guard let timeInt = TimeInterval(rawValue: index) else { return }
        calculateDate(timeInterval: timeInt)
    }
    
    
}
