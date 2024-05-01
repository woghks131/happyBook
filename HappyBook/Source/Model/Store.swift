//
//  Store.swift
//  HappyBook
//
//  Created by 박재환 on 4/25/24.
//

import Foundation
import SwiftUI

final class Store: ObservableObject {
    
    
    @Published var divisions: [Division]
    @Published var tabInfo: TabInfo
    @Published var accounts: [Account]
    @Published var dailySummaries: [DailyAccount] = []
    @Published var assets: Set<Asset> = []
    @Published var currentDate = Date()     //현재 년월 가져오기
    
    
    static var accountSequence = sequence(first: lastAccountID + 1) { $0 &+ 1 }
    static var lastAccountID: Int {
      get { UserDefaults.standard.integer(forKey: "LastAccountID") }
      set { UserDefaults.standard.set(newValue, forKey: "LastAccountID") }
    }

    init(
        //분류 json 데이터 가져오기
        filename: String = "DivisionData.json"
    ) {
        self.divisions = Bundle.main.decode(filename: filename, as: [Division].self)
        self.tabInfo = TabInfo(incomePrice: "", expensesPrice: "", sumPrice: "")
        self.accounts = []
//        self.dailyAccount = DailyAccount(date: .now, yearAndMonth: "", day: "", week: "", totalIncomePrice: "", totalExpensesPrice: "", accounts: [Account(id: 0, type: "", date: .now, price: "", division: Division(name: "", imageName: ""), asset: "", contents: "", memo: "")])
        
        //초기 데이터
        let initAssets: Set<Asset> = [
            Asset(name: "현금"),
            Asset(name: "신한은행"),
            Asset(name: "카카오뱅크"),
            Asset(name: "하나은행"),
            Asset(name: "삼성카드"),
            Asset(name: "하나카드")
        ]

        if assets.isEmpty {
            self.assets = initAssets
        }
        self.accounts = loadData(date: currentDate)
        
        loadAccountTabData(date: currentDate)
        updateDailySummaries()
    }
}

extension Store {
    func saveData(account: inout Account) {
        //inout: dailyTime을 변경해야하기 때문에
        
        account.dailyTime = Date().getTimeString(from: account.date)
        
        // 기존의 계정 데이터를 가져옵니다.
        var accounts = loadData(date: currentDate)

        // 새로운 계정을 배열에 추가합니다.
        accounts.append(account)

        do {
            // 배열을 직렬화하여 UserDefaults에 저장합니다.
            let data = try JSONEncoder().encode(accounts)
            UserDefaults.standard.setValue(data, forKey: "UserAccounts")
            
            loadAccountTabData(date: currentDate)
            updateDailySummaries()
        } catch {
            print("Error encoding assets: \(error)")
        }
    }
    
    func loadData(date: Date) -> [Account] {
        // UserDefaults에서 데이터를 가져옵니다.
        if let data = UserDefaults.standard.data(forKey: "UserAccounts") {
            do {
                // 데이터를 역직렬화하여 배열로 반환합니다.
                var accounts = try JSONDecoder().decode([Account].self, from: data)
                
                accounts = accounts.filter { account in
                    return date.formattedYearAndMonth() == account.date.formattedYearAndMonth()
                }
                
                accounts.sort {
                    if $0.date != $1.date {
                        return $0.date > $1.date
                    } else {
                        return $0.id > $1.id
                    }
                }
                
                
                
                return accounts
            } catch {
                print("Error decoding assets: \(error)")
            }
        }
        // 데이터가 없는 경우 빈 배열을 반환합니다.
        return []
    }
    
    
    func updateDailySummaries() {
        accounts = loadData(date: currentDate)
        
        let groupedAccount = Dictionary(grouping: accounts) { account in
            Calendar.current.startOfDay(for: account.date)
        }
        
        self.dailySummaries = groupedAccount.map{ key, accounts in
            
            let yearAndMonth = String(Date().getYear(from: key)) + "." + String(Date().getMonth(from: key))
            let day = String(Date().getDay(from: key))
            let week = Date().getDayOfWeek(from: key)
                
            let dailyIncomePrice = accounts.reduce(0) { result, account in
                if account.type == "수입" {
                    if let price = Int(account.price.replacingOccurrences(of: ",", with: "").replacingOccurrences(of: "원", with: "")) {
                        return result + price
                    }
                }
                return result
            }
            
            let dailyExpensesPrice = accounts.reduce(0) { result, account in
                if account.type == "지출" {
                    if let price = Int(account.price.replacingOccurrences(of: ",", with: "").replacingOccurrences(of: "원", with: "")) {
                        return result + price
                    }
                }
                return result
            }

            return DailyAccount(date: key, yearAndMonth: yearAndMonth, day: day, week: week, totalIncomePrice: formatPrice(dailyIncomePrice), totalExpensesPrice: formatPrice(dailyExpensesPrice), accounts: accounts)
        }
        
        dailySummaries.sort{ $0.date > $1.date }
    }
    
    //가계부 탭 메뉴에 데이터 보여주기 위함
    func loadAccountTabData(date: Date) {
        var incomePrice: Int = 0
        var expensesPrice: Int = 0

        if let data = UserDefaults.standard.data(forKey: "UserAccounts") {
            do {
                // 데이터를 역직렬화하여 배열로 반환합니다.
                var accounts = try JSONDecoder().decode([Account].self, from: data)
                accounts.sort { $0.id > $1.id }
                
                for account in accounts {
                    
                    if date.formattedYearAndMonth() == account.date.formattedYearAndMonth() {
                        
                        if account.type == "수입" {
                            let cleanedPrice = account.price.replacingOccurrences(of: ",", with: "").replacingOccurrences(of: "원", with: "")
                            if let price = Int(cleanedPrice) {
                                incomePrice += price
                            }
                        }
                        if account.type == "지출" {
                            let cleanedPrice = account.price.replacingOccurrences(of: ",", with: "").replacingOccurrences(of: "원", with: "")
                            if let price = Int(cleanedPrice) {
                                expensesPrice += price
                            }
                        }
                        
                    }
                }
                
                tabInfo.incomePrice = formatPrice(incomePrice)
                tabInfo.expensesPrice = formatPrice(expensesPrice)
                tabInfo.sumPrice = formatPrice(incomePrice - expensesPrice)
                
            } catch {
                print("Error decoding assets: \(error)")
            }
        }
    }
    
    
    //금액에 콤마와 맨 뒷자리에 원 추가
    func formatPrice(_ price: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        
        if let formattedPrice = formatter.string(from: NSNumber(value: price)) {
            return formattedPrice + "원"
        } else {
            return "\(price)원"
        }
    }
}
