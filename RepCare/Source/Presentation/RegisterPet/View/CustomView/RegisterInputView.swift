//
//  RegisterInputView.swift
//  RepCare
//
//  Created by JunHwan Kim on 2023/10/05.
//

import UIKit

class RegisterInputView: UIView {
    enum InputViewType {
        case button
        case datePicker
        case textField
    }
    
    let mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .equalSpacing
        stackView.spacing = 5
        return stackView
    }()
    
    let labelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        stackView.spacing = 7
        return stackView
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 17)
        return label
    }()
    
    let essentialLabel: UILabel = {
        let label = UILabel()
        label.text = "*"
        label.textColor = .red
        return label
    }()
    
    lazy var textField: CustomTextField = {
       let textField = CustomTextField()
        return textField
    }()
    
    lazy var actionButton: UIButton = {
        let button = ActionButton()
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        return button
    }()
    
    lazy var datePickerButton: DatePickerButton = {
        let button = DatePickerButton()
        
        return button
    }()
    
    let inputViewType: InputViewType 
    
    init(inputView: InputViewType, isEssential: Bool) {
        self.inputViewType = inputView
        super.init(frame: .zero)
        essentialLabel.isHidden = !isEssential
        defaultLayout()
        switch inputViewType {
        case .button:
            buttonLayout()
        case .datePicker:
            datePickerLayout()
        case .textField:
            textFieldLayout()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func defaultLayout() {
        addSubview(mainStackView)
        labelStackView.addArrangedSubview(descriptionLabel)
        labelStackView.addArrangedSubview(essentialLabel)
        mainStackView.addArrangedSubview(labelStackView)
        mainStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func buttonLayout() {
        mainStackView.addArrangedSubview(actionButton)
        actionButton.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(45)
        }
    }
    
    private func textFieldLayout() {
        mainStackView.addArrangedSubview(textField)
        textField.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(45)
        }
    }
    
    private func datePickerLayout() {
        mainStackView.addArrangedSubview(datePickerButton)
        datePickerButton.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(45)
        }
    }
    
}
