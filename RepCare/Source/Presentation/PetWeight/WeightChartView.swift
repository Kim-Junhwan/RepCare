//
//  WeightChartView.swift
//  RepCare
//
//  Created by JunHwan Kim on 2023/10/16.
//

import UIKit
import DGCharts

protocol WeightChartViewDelegate: AnyObject {
    func tapRegisterWeightButton()
}

class WeightChartView: UICollectionReusableView {
    
    static let identifier = "WeightChartView"
    weak var delegate: WeightChartViewDelegate?
    let lineChart: LineChartView = {
        let view = LineChartView()
        view.backgroundColor = .brightLightGreen
        view.rightAxis.enabled = false
        view.xAxis.labelPosition = .bottom
        view.animate(yAxisDuration: 1.0)
        view.doubleTapToZoomEnabled = false
        view.pinchZoomEnabled = true
        view.highlightPerDragEnabled = false
        view.legend.enabled = false
        view.highlightPerTapEnabled = false
        
        let yAxis = view.leftAxis
        yAxis.labelFont = .boldSystemFont(ofSize: 10)
        yAxis.labelPosition = .insideChart
        
        let xAxis = view.xAxis
        xAxis.labelFont = .boldSystemFont(ofSize: 10)
        xAxis.spaceMin = 1.0
        xAxis.spaceMax = 0.5
        
        return view
    }()
    
    lazy var buttonStackView: UIStackView = {
       let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        stackView.spacing = 10
        stackView.addArrangedSubview(addWeightButton)
        return stackView
    }()
    
    let addWeightButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = .lightDeepGreen
        config.baseForegroundColor = .black
        config.title = "무게 추가"
       let button = UIButton(configuration: config)
        button.titleLabel?.numberOfLines = 1
        button.invalidateIntrinsicContentSize()
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
        setConstraints()
        lineChart.dragEnabled = true
        lineChart.noDataFont = .boldSystemFont(ofSize: 20)
        lineChart.noDataText = "입력된 무게가 없어요."
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureView() {
        addSubview(lineChart)
        addSubview(buttonStackView)
        addWeightButton.addTarget(self, action: #selector(showRegisterView), for: .touchUpInside)
    }
    
    @objc func showRegisterView() {
        delegate?.tapRegisterWeightButton()
    }
    
    private func setConstraints() {
        lineChart.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(lineChart.snp.width).multipliedBy(0.8)
        }
        buttonStackView.snp.makeConstraints { make in
            make.top.equalTo(lineChart.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(10)
            make.height.equalTo(40)
            make.bottom.equalToSuperview()
        }
    }
}
