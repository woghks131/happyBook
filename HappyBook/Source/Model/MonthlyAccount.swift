//
//  MonthlyAccount.swift
//  HappyBook
//
//  Created by 박재환 on 5/5/24.
//

import Foundation

struct MonthlyAccount: Hashable {
    let date: Date
    let year: String
    let month: String
    let incomePrice: String
    let expensesPrice: String
    let sumPirce: String
}
