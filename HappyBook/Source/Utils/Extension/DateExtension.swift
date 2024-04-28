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
    
}

