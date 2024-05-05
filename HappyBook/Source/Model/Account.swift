//
//  Account.swift
//  HappyBook
//
//  Created by 박재환 on 4/25/24.
//

import Foundation

struct Account: Codable, Hashable, Identifiable{
    let id: Int
    var type: String        // 수입/지출
    var date: Date          // 날짜
    var price: String       // 금액
    var division: Division  // 분류
    var asset: String       // 자산
    var contents: String    // 내용
    var memo: String        // 메모
    
    var favorite: Bool = false
    var dailyTime: String?  //스켸쥴 Row에 시간 포맷
    
}






