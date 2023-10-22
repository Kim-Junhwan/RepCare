//
//  CalenderHeaderView.swift
//  RepCare
//
//  Created by JunHwan Kim on 2023/10/17.
//

import UIKit
import FSCalendar

class CalenderHeaderView: UICollectionReusableView {
    
    static let identifier = "CalenderHeaderView"
    
    private let dateFormatter: DateFormatter = {
       let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy년 MM월"
        return dateFormatter
    }()
    
    let calendarbaseView: UIView = {
        let view = UIView()
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.masksToBounds = false
        view.layer.shadowOffset = CGSize(width: 0, height: 0)
        view.layer.shadowRadius = 5
        view.layer.shadowOpacity = 0.1
        return view
    }()
    
    lazy var calendarStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 0
         stackView.axis = .vertical
         stackView.alignment = .center
        stackView.layer.cornerRadius = 10
        stackView.distribution = .equalSpacing
        stackView.backgroundColor = .systemBackground
        stackView.addArrangedSubview(calendarHeaderView)
        stackView.addArrangedSubview(fsCalendar)
         return stackView
     }()
    
    lazy var calendarHeaderView: UIStackView = {
       let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillProportionally
        stackView.addArrangedSubview(backButton)
        stackView.addArrangedSubview(yearMonthLabel)
        stackView.addArrangedSubview(forwardButton)
        return stackView
    }()
    
    let backButton: UIButton = {
       let button = UIButton()
        button.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
        return button
    }()
    
    let yearMonthLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        return label
    }()
    
    let forwardButton: UIButton = {
        let button = UIButton()
         button.setImage(UIImage(systemName: "chevron.forward"), for: .normal)
         return button
    }()
    
    let fsCalendar: FSCalendar = {
       let calendar = FSCalendar()
        calendar.backgroundColor = .systemBackground
        calendar.locale = Locale(identifier: "ko_KR")
        calendar.layer.cornerRadius = 10
        calendar.clipsToBounds = true
        calendar.calendarHeaderView.isHidden = false
        calendar.scrollEnabled = false
        calendar.allowsMultipleSelection = true
        calendar.placeholderType = .none
        calendar.headerHeight = 0
        return calendar
    }()
    
    lazy var timeLineStackView: UIStackView = {
       let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 20
        stackView.addArrangedSubview(timelineLabel)
        return stackView
    }()
    
    let timelineLabel: UILabel = {
       let label = UILabel()
        label.text = "타임라인"
        label.font = .boldSystemFont(ofSize: 20)
        return label
    }()
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(calendarbaseView)
        addSubview(timeLineStackView)
        yearMonthLabel.text = dateFormatter.string(from: fsCalendar.currentPage)
        calendarbaseView.addSubview(calendarStackView)
        calendarbaseView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(10)
        }
        calendarStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalTo(350)
        }
        fsCalendar.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(fsCalendar.snp.width).multipliedBy(0.8)
        }
        calendarHeaderView.snp.makeConstraints { make in
            make.height.equalTo(40)
            make.width.equalToSuperview().multipliedBy(0.8)
        }
        timeLineStackView.snp.makeConstraints { make in
            make.top.equalTo(calendarbaseView.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(10)
            make.bottom.equalToSuperview()
        }
        forwardButton.addTarget(self, action: #selector(tapForward), for: .touchUpInside)
        backButton.addTarget(self, action: #selector(tapBackward), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func tapForward() {
        moveMonth(next: true)
    }
    
    @objc func tapBackward() {
        moveMonth(next: false)
    }
    
    func moveMonth(next: Bool) {
        var dateComponents = DateComponents()
        dateComponents.month = next ? 1 : -1
        let currentDate = Calendar.current.date(byAdding: dateComponents, to: fsCalendar.currentPage)!
        self.fsCalendar.setCurrentPage(currentDate, animated: true)
        yearMonthLabel.text = dateFormatter.string(from: currentDate)
    }
}
