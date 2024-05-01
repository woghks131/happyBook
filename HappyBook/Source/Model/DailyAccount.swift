//
//  DailyAccount.swift
//  HappyBook
//
//  Created by 박재환 on 4/29/24.
//

import Foundation

struct DailyAccount: Hashable {
    var date: Date
    var yearAndMonth: String
    var day : String
    var week: String
    var totalIncomePrice: String
    var totalExpensesPrice: String
    var accounts: [Account]
}
