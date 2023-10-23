//
//  Date+.swift
//  RepCare
//
//  Created by JunHwan Kim on 2023/10/23.
//

import Foundation

extension Date {
    func isEqualDay(_ date: Date) -> Bool {
        var calendar = Calendar.current
        calendar.timeZone = TimeZone.current
        let compareDate = calendar.dateComponents([.year, .month, .day], from: date)
        let currentDate = calendar.dateComponents([.year, .month, .day], from: self)
        return compareDate == currentDate
    }
}
