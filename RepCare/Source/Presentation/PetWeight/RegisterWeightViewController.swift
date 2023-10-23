//
//  RegisterWeightViewController.swift
//  RepCare
//
//  Created by JunHwan Kim on 2023/10/22.
//

import Foundation
import UIKit
import RxCocoa
import RxSwift

final class RegisterWeightViewController: BaseViewController {
    lazy var cancelButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(cancel))
        button.tintColor = .red
        return button
    }()
    
    lazy var registerButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "등록", style: .done, target: self, action: #selector(register))
        return button
    }()
    
    lazy var registerDateView: RegisterInputView = {
        var config = UIButton.Configuration.plain()
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .regular)
        let calendarImage = UIImage(systemName: "calendar", withConfiguration: imageConfig)
        config.contentInsets = .init(top: 10, leading: 0, bottom: 10, trailing: 0)
        config.image = calendarImage
        config.baseForegroundColor = .black
        config.imagePadding = 50
        
        let view = RegisterInputView(inputView: .datePicker, isEssential: false)
        view.mainStackView.spacing = 10
        view.descriptionLabel.text = "등록할 날짜"
        view.descriptionLabel.font = .boldSystemFont(ofSize: 25)
        view.datePickerButton.configuration = config
        let button = view.datePickerButton
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 1.0
        button.layer.cornerRadius = 10.0
        button.datePicker.setDate(currentDate, animated: true)
        button.titleLabel?.font = .systemFont(ofSize: 20)
        button.titleLabel?.textColor = .black
        button.setTitle(DateFormatter.yearMonthDateFormatter.string(from: currentDate), for: .normal)
        button.actionClosure = { [weak self] date in
            button.setTitle(DateFormatter.yearMonthDateFormatter.string(from: date), for: .normal)
            self?.currentDate = date
        }
        button.datePicker.maximumDate = Date()
        button.viewController = self
        return view
    }()
    
    lazy var memoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 5
        stackView.addArrangedSubview(memoTitleLabel)
        stackView.addArrangedSubview(weightTextField)
        return stackView
    }()
    
    let memoTitleLabel: UILabel = {
        let label = UILabel()
         label.text = "무게"
        label.font = .boldSystemFont(ofSize: 25)
         return label
     }()
    
    let weightTextField: UITextField = {
        let textField = UITextField()
        textField.layer.borderWidth = 1.0
        textField.layer.cornerRadius = 10
        textField.keyboardType = .decimalPad
        textField.textAlignment = .center
        return textField
    }()
    
    var currentDate: Date
    var weight: Double = 0
    var registerClosure: ((Date, Double) -> Void)?
    let disposeBag = DisposeBag()
    
    init(date: Date) {
        self.currentDate = date
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "무게 추가"
        tapViewEndEdit()
        bind()
    }
    
    func bind() {
        weightTextField.rx.text.subscribe(with: self) { owner, input in
            if let text = input, !text.isEmpty, let number = Double(text), number > 0 {
                owner.weight = number
                owner.registerButton.isEnabled = true
            } else {
                owner.registerButton.isEnabled = false
            }
        }.disposed(by: disposeBag)
    }
    
    override func configureView() {
        view.addSubview(registerDateView)
        view.addSubview(memoStackView)
        navigationItem.setRightBarButton(registerButton, animated: false)
        navigationItem.setLeftBarButton(cancelButton, animated: false)
    }
    
    override func setContraints() {
        registerDateView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        memoStackView.snp.makeConstraints { make in
            make.top.equalTo(registerDateView.snp.bottom).offset(20)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        weightTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
        }
    }
    
    @objc func register() {
        self.dismiss(animated: true) {
            self.registerClosure?(self.currentDate, self.weight)
        }
    }
    
    @objc func cancel() {
        self.dismiss(animated: true)
    }
}
