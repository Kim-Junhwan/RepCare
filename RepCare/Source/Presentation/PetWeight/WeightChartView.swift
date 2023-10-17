//
//  WeightChartView.swift
//  RepCare
//
//  Created by JunHwan Kim on 2023/10/16.
//

import UIKit
import DGCharts

protocol WeightChartViewDelegate: AnyObject {
    func tapSeguement(index: Int)
}

protocol WeightChartViewDataSource: AnyObject {
    func getWeightDataList() -> [PetWeightModel]
}

class WeightChartView: UICollectionReusableView {
    
    static let identifier = "WeightChartView"
    
    weak var datasource: WeightChartViewDataSource?
    weak var delegate: WeightChartViewDelegate?

    lazy var dateSeguement: UISegmentedControl = {
        let segue = UISegmentedControl(items: ["주","월","년"])
        segue.addTarget(self, action: #selector(tapSegue), for: .valueChanged)
        return segue
    }()
    
    
    let lineChart = LineChartView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
        setConstraints()
        lineChart.dragEnabled = false
        lineChart.noDataText = "최근 입력된 데이터가 없어요"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureView() {
        addSubview(dateSeguement)
        addSubview(lineChart)
    }
    
    private func setConstraints() {
        dateSeguement.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(10)
        }
        lineChart.snp.makeConstraints { make in
            make.top.equalTo(dateSeguement.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview().inset(10)
        }
    }
    
    @objc func tapSegue(_ sender: UISegmentedControl) {
        delegate?.tapSeguement(index: sender.selectedSegmentIndex)
        updateChartTapSegue()
    }
    
    func updateChartTapSegue() {
        guard let datasource else { return }
        let weightData = datasource.getWeightDataList()
        lineChart.xAxis.valueFormatter = IndexAxisValueFormatter(values: weightData.map{ $0.date.description })
        lineChart.xAxis.setLabelCount(weightData.count, force: false)
        setLineData(weightDataEntry: makeDataEntry(weights: weightData))
    }
    
    func setLineData(weightDataEntry: [ChartDataEntry]) {
        let lineChartDataSet = LineChartDataSet(entries: weightDataEntry)
        let lineChartData = LineChartData(dataSet: lineChartDataSet)
        lineChart.data = lineChartData
    }
    
    func makeDataEntry(weights: [PetWeightModel]) -> [ChartDataEntry] {
//        var lineDataEntries: [ChartDataEntry] = []
//        for i in 0..<weights.count {
//            let lineDataEntry = ChartDataEntry(x: Double(i), y: weights[i])
//            lineDataEntries.append(lineDataEntry)
//        }
//        return lineDataEntries
        return []
    }
}
