//
//  RegisterWeightViewController.swift
//  RepCare
//
//  Created by JunHwan Kim on 2023/10/22.
//

import Foundation
import UIKit

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
        config.contentInsets = .init(top: 20, leading: 0, bottom: 20, trailing: 0)
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
        button.setTitle(dateFormatter.string(from: currentDate), for: .normal)
        button.actionClosure = { [weak self] date in
            button.setTitle(self?.dateFormatter.string(from: date), for: .normal)
            self?.currentDate = date
        }
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
        stackView.addArrangedSubview(memoTextField)
        return stackView
    }()
    
    let memoTitleLabel: UILabel = {
        let label = UILabel()
         label.text = "메모"
        label.font = .boldSystemFont(ofSize: 25)
         return label
     }()
    
    let memoTextField: UITextView = {
        let textField = UITextView()
        textField.layer.borderWidth = 1.0
        textField.layer.cornerRadius = 10
        textField.keyboardType = .decimalPad
        return textField
    }()
    
    private let dateFormatter: DateFormatter = {
       let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter
    }()
    var currentDate: Date
    var registerClosure: ((Date, Double) -> Void)?
    
    init(date: Date) {
        self.currentDate = date
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "무게"
        tapViewEndEdit()
    }
    
    override func configureView() {
        view.addSubview(registerDateView)
        view.addSubview(memoStackView)
        navigationItem.setRightBarButton(registerButton, animated: false)
        navigationItem.setLeftBarButton(cancelButton, animated: false)
    }
    
    override func setContraints() {
        registerDateView.setContentHuggingPriority(.init(751), for: .vertical)
        registerDateView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        memoStackView.setContentHuggingPriority(.init(750), for: .vertical)
        memoStackView.snp.makeConstraints { make in
            make.top.equalTo(registerDateView.snp.bottom).offset(20)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(view.snp.height).multipliedBy(0.4)
        }
        
    }
    
    @objc func register() {
        self.dismiss(animated: true) {
            guard let weight = Double(self.memoTextField.text) else { return }
            self.registerClosure?(self.currentDate, weight)
        }
    }
    
    @objc func cancel() {
        self.dismiss(animated: true)
    }
}
