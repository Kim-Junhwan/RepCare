//
//  DatePickerButton.swift
//  RepCare
//
//  Created by JunHwan Kim on 2023/10/10.
//

import UIKit

class DatePickerButton: UIButton {
    
    let datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .inline
        datePicker.locale = Locale(identifier: "ko_KR")
        
        return datePicker
    }()
    
    var viewController: UIViewController?
    var actionClosure: ((Date) -> Void)?
    
    @objc func showDatePicker() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let ok = UIAlertAction(title: "확인", style: .default) { _ in
            self.actionClosure?(self.datePicker.date)
        }
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        alert.addAction(ok)
        alert.addAction(cancel)
        let vc = UIViewController()
        vc.view = datePicker
        alert.setValue(vc, forKey: "contentViewController")
        viewController?.present(alert, animated: true)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayout()
        addTarget(viewController, action: #selector(showDatePicker), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setLayout() {
        layer.borderWidth = 1.0
        layer.borderColor = UIColor.systemGray3.cgColor
        setTitleColor(.black, for: .normal)
    }
}
