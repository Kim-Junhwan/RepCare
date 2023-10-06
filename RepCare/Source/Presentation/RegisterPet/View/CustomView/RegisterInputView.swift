//
//  RegisterInputView.swift
//  RepCare
//
//  Created by JunHwan Kim on 2023/10/05.
//

import UIKit

class RegisterInputView: UIView {
    
    private let mainStackView: UIStackView = {
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
        return stackView
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        
        return label
    }()
    
    let essentialLabel: UILabel = {
        let label = UILabel()
        label.text = "*"
        label.textColor = .red
        return label
    }()
    
    lazy var textField: UITextField = {
       let textField = CustomTextField()
        
        return textField
    }()
    
    lazy var actionButton: UIButton = {
        let button = ActionButton()
        
        return button
    }()
    
    init(isButton: Bool, isEssential: Bool) {
        super.init(frame: .zero)
        if isButton {
            buttonLayout()
        } else {
            textFieldLayout()
        }
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
    
    func buttonLayout() {
        defaultLayout()
        mainStackView.addArrangedSubview(actionButton)
        actionButton.snp.makeConstraints { make in
            make.width.equalToSuperview()
        }
    }
    
    func textFieldLayout() {
        defaultLayout()
        mainStackView.addArrangedSubview(textField)
        textField.snp.makeConstraints { make in
            make.width.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
