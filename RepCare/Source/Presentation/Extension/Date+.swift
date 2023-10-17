//
//  Date+.swift
//  RepCare
//
//  Created by JunHwan Kim on 2023/10/17.
//

import Foundation

extension Date {
    func convertDateToKoreaLocale() -> Date {
        let dateformatter = DateFormatter()
        let dateFormat = "yyyy.MM.dd HH:mm"
        dateformatter.dateFormat = dateFormat
        let formattedDate = dateformatter.string(from: self)
        dateformatter.locale = NSLocale.current
        dateformatter.timeZone = TimeZone(abbreviation: "GMT+0:00")
        return dateformatter.date(from: formattedDate) ?? Date()
    }
}
