//
//  DateFormatter++.swift
//  RepCare
//
//  Created by JunHwan Kim on 2023/10/23.
//

import Foundation

extension DateFormatter {
    static let yearMonthDateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "yyyy/MM/dd"
        return df
    }()
    
    static let monthDateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "MM월 dd일"
        return df
    }()
    
    static let yearMonthFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "yyyy년 MM월"
        return df
    }()
}
