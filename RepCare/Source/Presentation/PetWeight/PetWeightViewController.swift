//
//  PetWeightViewController.swift
//  RepCare
//
//  Created by JunHwan Kim on 2023/10/15.
//

import Foundation
import UIKit
import DGCharts

final class PetWeightViewController: BaseViewController {
    
    private enum Metric {
        static let chartViewHeight: CGFloat = 400
    }
    
    enum TimeInterval: Int {
        case week
        case month
        case year
    }
    
    private var registerWeightButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.tintColor = .black
        return button
    }()
    
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
    var weightRepository: WeightRepository
    private var pet: PetModel
    private lazy var currentDate = Date()
    var weightList: [PetWeightModel] = []
    weak var chartView: LineChartView?
    
    init(weightRepository: WeightRepository, pet: PetModel) {
        self.weightRepository = weightRepository
        self.pet = pet
        super.init(nibName: nil, bundle: nil)
        title = "무게"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        weightList = weightRepository.fetchAllWeight(petId: pet.id).map { .init(id: $0.id, date: $0.date, weight: $0.weight) }.sorted { $0.date < $1.date }
    }
    
    private func setChart(weightList: [PetWeightModel]) {
        if weightList.isEmpty {
            return
        }
        var dataEntries: [ChartDataEntry] = []
        chartView?.xAxis.valueFormatter = IndexAxisValueFormatter(values: Array(weightList.map { DateFormatter.yearMonthDateFormatter.string(from: $0.date) }))
        chartView?.xAxis.setLabelCount(min(4, weightList.count), force: false)
        chartView?.leftAxis.setLabelCount(weightList.count, force: false)
        for weight in weightList.enumerated() {
            let dataEntry = ChartDataEntry(x: Double(weight.offset), y: weight.element.weight)
            dataEntries.append(dataEntry)
        }
        let lineDataSet = LineChartDataSet(entries: dataEntries)
        lineDataSet.mode = .linear
        lineDataSet.lineWidth = 3
        lineDataSet.valueFont = .systemFont(ofSize: 10)
        lineDataSet.valueFormatter = DataSetValueFormatter()
        lineDataSet.setColor(.deepGreen)
        lineDataSet.setCircleColor(.deepGreen)
        lineDataSet.drawCircleHoleEnabled = false
        self.chartView?.data = LineChartData(dataSet: lineDataSet)
    }
    
    func reloadView() {
        if collectionView.dataSource == nil {
            return
        }
        DispatchQueue.main.async {
            self.weightList = self.weightRepository.fetchAllWeight(petId: self.pet.id).map { .init(id: $0.id, date: $0.date, weight: $0.weight) }
            self.setChart(weightList: self.weightList)
            self.collectionView.reloadData()
        }
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
        layout.itemSize = .init(width: width - 20, height: 50)
        return layout
    }
    
    @objc private func deleteWeight(_ sender: UIButton) {
        let deleteWeight = weightList[weightList.count-sender.tag-1]
        do {
            try weightRepository.deleteWeight(weightId: deleteWeight.id)
            reloadView()
        } catch {
            showErrorAlert(title: "몸무게 삭제 실패", message: error.localizedDescription)
        }
        
    }
    
    deinit {
        print("deinit PetCalendarVC")
    }
}

extension PetWeightViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return weightList.count+1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WeightCollectionViewCell.identifier, for: indexPath) as? WeightCollectionViewCell else { return .init() }
        if indexPath.row == 0 {
            cell.deleteButton.isHidden = true
            cell.dateLabel.text = "날짜"
            cell.weightLabel.text = "무게(g)"
            cell.changeWeightLabel.text = "변화량(g)"
            return cell
        }
        let reverseWeightList = Array(weightList.sorted{$0.date < $1.date}.reversed())
        let weight = reverseWeightList[indexPath.row-1]
        let lastWeight = indexPath.row >= weightList.count ? 0 : reverseWeightList[indexPath.row].weight
        cell.configureCell(date: weight.date, weight: weight.weight, change: weight.weight-lastWeight)
        cell.deleteButton.tag = indexPath.row-1
        cell.deleteButton.addTarget(self, action: #selector(self.deleteWeight(_:)), for: .touchUpInside)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: WeightChartView.identifier, for: indexPath) as? WeightChartView else { return .init() }
        header.delegate = self
        chartView = header.lineChart
        
        setChart(weightList: weightList)
        return header
    }
    
}

extension PetWeightViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let indexPath = IndexPath(row: 0, section: section)
        let headerView = self.collectionView(collectionView, viewForSupplementaryElementOfKind: UICollectionView.elementKindSectionHeader, at: indexPath)
        return headerView.systemLayoutSizeFitting(.init(width: collectionView.frame.width, height: UIView.layoutFittingExpandedSize.height), withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel)
    }
}

extension PetWeightViewController: WeightChartViewDelegate {
    func tapEditButton() {
        
    }
    
    func tapRegisterWeightButton() {
        let vc = RegisterWeightViewController(date: Date())
        vc.registerClosure = tapRegisterButton(date:weight:completion:)
        vc.updateClosure = updateWeight(date:weight:)
        let nvc = UINavigationController(rootViewController: vc)
        nvc.modalPresentationStyle = .pageSheet
        nvc.sheetPresentationController?.detents = [.medium()]
        nvc.sheetPresentationController?.widthFollowsPreferredContentSizeWhenEdgeAttached = true
        present(nvc, animated: true)
    }
    
    func tapRegisterButton(date: Date, weight: Double, completion: @escaping (Bool) -> Void) {
        if weightRepository.checkRegisterWeightInDay(petId: pet.id, date: date) {
            completion(false)
        } else {
            completion(true)
            do {
                try weightRepository.registerWeight(petId: pet.id, date: date, weight: weight)
                reloadView()
            } catch {
                showErrorAlert(title: "무게 등록 실패", message: error.localizedDescription)
            }
        }
        collectionView.reloadData()
    }
    
    func updateWeight(date: Date, weight: Double) {
        try? weightRepository.updateWeightAtDate(petId: pet.id, date: date, weight: weight)
        reloadView()
    }
    
}

final class DataSetValueFormatter: NSObject, ValueFormatter {
    
    private func format(value: Double) -> String {
        return String(format: "%.1f", value)
    }
    
    func stringForValue(_ value: Double, entry: DGCharts.ChartDataEntry, dataSetIndex: Int, viewPortHandler: DGCharts.ViewPortHandler?) -> String {
        return format(value: value)
    }
    
    
}
