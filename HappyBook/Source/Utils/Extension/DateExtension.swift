//
//  DateExtension.swift
//  HappyBook
//
//  Created by 박재환 on 4/27/24.
//

import Foundation

extension Date {
    static var current: Date {
        return Date()
    }
    
    func formattedYearAndMonth() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy년 MM월"
        return dateFormatter.string(from: self)
    }
    
    var previousMonth: Date {
        return Calendar.current.date(byAdding: .month, value: -1, to: self)!
    }
    
    var nextMonth: Date {
        return Calendar.current.date(byAdding: .month, value: 1, to: self)!
    }
    
    func getYear(from date: Date) -> Int {
        let calendar = Calendar.current
        return calendar.component(.year, from: date)
    }

    func getMonth(from date: Date) -> Int {
        let calendar = Calendar.current
        return calendar.component(.month, from: date)
    }

    func getDay(from date: Date) -> Int {
        let calendar = Calendar.current
        return calendar.component(.day, from: date)
    }

    func getDayOfWeek(from date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        dateFormatter.locale = Locale(identifier: "ko_KR")
        return dateFormatter.string(from: date)
    }
    
    func getTimeString(from date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "a hh:mm"
        return dateFormatter.string(from: date)
    }
    
}

