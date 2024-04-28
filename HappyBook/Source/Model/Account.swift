//
//  Account.swift
//  HappyBook
//
//  Created by 박재환 on 4/25/24.
//

import Foundation

struct Account: Codable, Hashable{
    let id: Int
    let type: String        // 수입/지출
    let date: Date          // 날짜
    let price: String       // 금액
    let division: String    // 분류
    let asset: String       // 자산
    let contents: String    // 내용
    let memo: String        // 메모
}






