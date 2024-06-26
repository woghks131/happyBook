//
//  Store.swift
//  HappyBook
//
//  Created by 박재환 on 4/25/24.
//

import Foundation
import SwiftUI
import Combine

final class Store: ObservableObject {
    
    @Published var divisions: [Division]
    @Published var tabInfo: TabInfo
    @Published var accounts: [Account]
    @Published var favoritedAccounts: [Account]
    @Published var memoList: [Account]
    
    @Published var dailySummaries: [DailyAccount] = []
    @Published var monthlySummaries: [MonthlyAccount] = []
    
    @Published var assets: Set<Asset> = []
    @Published var currentDate = Date()     //현재 년월 가져오기
    
    private var cancellables = Set<AnyCancellable>()

    static var accountSequence = sequence(first: lastAccountID + 1) { $0 &+ 1 }
    static var lastAccountID: Int {
      get { UserDefaults.standard.integer(forKey: "LastAccountID") }
      set { UserDefaults.standard.set(newValue, forKey: "LastAccountID") }
    }

    init(filename: String = "DivisionData.json") //분류 json 데이터 가져오기)
    {
        self.divisions = Bundle.main.decode(filename: filename, as: [Division].self)
        self.tabInfo = TabInfo(incomePrice: "", expensesPrice: "", sumPrice: "")
        self.accounts = []
        self.favoritedAccounts = []
        self.memoList = []
        
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
        
        
        
        //currentDate에 대한 변경을 구독 하고 변경이 감지되면 sink
        $currentDate
            .sink { [weak self] date in
                self?.accounts = self?.loadData(date: date) ?? []
                self?.loadAccountTabData(date: date)
                self?.updateDailySummaries()
                self?.updateMonthlySummaries()
            }
            .store(in: &cancellables)
        
        
//        self.accounts = loadData(date: currentDate)
        self.favoritedAccounts = loadFavoriteAccount()
        self.memoList = loadMemoList()
        
//        loadAccountTabData(date: currentDate)
//        updateDailySummaries()
//        updateMonthlySummaries()
    }
}

extension Store {
    
    // MARK: - 가계부 데이터 CRUD
    
    /*
     * 가계부 조회
     */
    func loadData(date: Date?) -> [Account] {
        guard let data = UserDefaults.standard.data(forKey: "UserAccounts") else { return [] }
        
        do {
            var accounts = try JSONDecoder().decode([Account].self, from: data)
            
            if date != nil {
                accounts = accounts.filter { account in
                    return date!.formattedYearAndMonth() == account.date.formattedYearAndMonth()
                }
            }
            
            accounts.sort { $0.date != $1.date ? $0.date > $1.date : $0.id > $1.id }
            return accounts
        } catch {
            print("Error decoding assets: \(error)")
            return []
        }
    }
    
    /*
     * 가계부 저장
     */
    func saveData(account: inout Account) {
        //inout: dailyTime을 변경해야하기 때문에
        account.dailyTime = Date().getTimeString(from: account.date)
        
        Just(account)
            .map { [weak self] account in
                var accounts = self?.loadData(date: nil) ?? []
                accounts.append(account)
                return accounts
            }
            .sink { [weak self] accounts in
                self?.saveAccounts(accounts)
            }
            .store(in: &cancellables)
    }
 
    /*
     * 가계부 수정
     */
    func updateData(account: inout Account) {
        //inout: dailyTime을 변경해야하기 때문에
        account.dailyTime = Date().getTimeString(from: account.date)
        
        Just(account)
            .map { [weak self] account in
                var accounts = self?.loadData(date: nil) ?? []
                
                // 데이터 변경 작업
                if let index = accounts.firstIndex(where: { $0.id == account.id }) {
                    accounts[index] = account
                }
                
                return accounts
            }
            .sink { [weak self] accounts in
                self?.saveAccounts(accounts)
            }
            .store(in: &cancellables)
    }
    
    /*
     * 가계부 삭제
     */
    func deleteData(id: Int) {
        
        Just(id)
            .map { [weak self] id in
                var accounts = self?.loadData(date: nil) ?? []
                accounts = accounts.filter { $0.id != id }
                
                return accounts
            }
            .sink { [weak self] accounts in
                self?.saveAccounts(accounts)
            }
            .store(in: &cancellables)
    }
    
    // MARK: - 즐겨찾기 관리
    
    /*
     * 즐겨찾기 되어있는 가계부 데이터 조회
     */
    func loadFavoriteAccount() -> [Account] {
        
        guard let data = UserDefaults.standard.data(forKey: "UserAccounts") else { return [] }
        
        do {
            var accounts = try JSONDecoder().decode([Account].self, from: data)
            accounts = accounts.filter { $0.favorite }
            accounts.sort { $0.date != $1.date ? $0.date > $1.date : $0.id > $1.id }
            return accounts
        } catch {
            print("Error decoding assets: \(error)")
            return []
        }
    }
    
    /*
     * 즐겨찾기 수정
     */
    func updateFavoriteData(id: Int, favorite: Bool) {
        
        Just((id, favorite))
            .sink { [weak self] id, favorite in
                var accounts = self?.loadData(date: nil) ?? []
                // 데이터 변경 작업
                if let index = accounts.firstIndex(where: { $0.id == id }) {
                    accounts[index].favorite = favorite
                }
                
                self?.saveAccounts(accounts)
            }
            .store(in: &cancellables)
    }

    /*
     * 즐겨찾기 해제
     */
    func deleteFavorite(at indexes: IndexSet) {
        guard let index = indexes.first else {return}
        let favoriteAccount = self.favoritedAccounts[index]
        updateFavoriteData(id: favoriteAccount.id, favorite: false)
    }
    
    //MARK: - 메모 관리
    
    /*
     * 메모 조회
     */
    func loadMemoList() -> [Account] {
        guard let data = UserDefaults.standard.data(forKey: "UserAccounts") else { return [] }
        
        do {
            var accounts = try JSONDecoder().decode([Account].self, from: data)
            accounts = accounts.filter { !$0.memo.isEmpty }
            accounts.sort { $0.date != $1.date ? $0.date > $1.date : $0.id > $1.id }
            return accounts
        } catch {
            print("Error decoding assets: \(error)")
            return []
        }
    }
    
    /*
     * 메모 수정
     */
    func updateMemoData(id: Int, memo: String) {
        
        Just((id, memo))
            .sink { [weak self] id, memo in
                var accounts = self?.loadData(date: nil) ?? []
                
                // 데이터 변경 작업
                if let index = accounts.firstIndex(where: { $0.id == id }) {
                    accounts[index].memo = memo
                }
                
                self?.saveAccounts(accounts)
            }
            .store(in: &cancellables)
    }
    
    /*
     * 메모 삭제
     */
    func deleteMemo(at indexes: IndexSet) {
        guard let index = indexes.first else {return}
        let memo = self.memoList[index]
        updateMemoData(id: memo.id, memo: "")
    }
    
    //MARK: - Account Management
    
    /*
     * 가계부 Row 보여주기 위한 함수
     */
    func updateDailySummaries() {
        Just(currentDate)
            .map { [weak self] date -> [DailyAccount] in
                var accounts = self?.loadData(date: date) ?? []
                let groupedAccount = Dictionary(grouping: accounts) { account in
                    Calendar.current.startOfDay(for: account.date)
                }
                
                return groupedAccount.map{ key, accounts in
                    
                    let yearAndMonth = String(Date().getYear(from: key)) + "." + String(Date().getMonth(from: key))
                    let day = String(Date().getDay(from: key))
                    let week = Date().getDayOfWeek(from: key)
                        
                    let dailyIncomePrice = accounts.reduce(0) { result, account in
                        if account.type == "수입", let price = Int(account.price.replacingOccurrences(of: ",", with: "").replacingOccurrences(of: "원", with: "")) { return result + price }
                        return result
                    }
                    
                    let dailyExpensesPrice = accounts.reduce(0) { result, account in
                        if account.type == "지출", let price = Int(account.price.replacingOccurrences(of: ",", with: "").replacingOccurrences(of: "원", with: "")) { return result + price }
                        return result
                    }

                    return DailyAccount(date: key, yearAndMonth: yearAndMonth, day: day, week: week, totalIncomePrice: self?.formatPrice(dailyIncomePrice) ?? "0원", totalExpensesPrice: self?.formatPrice(dailyExpensesPrice) ?? "0원", accounts: accounts)
                }
                
            }
            .sink { [weak self] dailySummaries in
                self?.dailySummaries = dailySummaries
                self?.dailySummaries.sort{ $0.date > $1.date }
            }
            .store(in: &cancellables)
    }
    
    /*
     * 월별 Row 보여주기 위한 함수
     */
    func updateMonthlySummaries() {
        accounts = loadData(date: nil)
        
        let groupedAccount = Dictionary(grouping: accounts) { account in
            Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: account.date)) ?? Date()
        }
        
        self.monthlySummaries = groupedAccount.compactMap{ key, accounts in
            
            guard Date().getYear(from: currentDate) == Calendar.current.component(.year, from: key) else {
                return nil
            }
            
            let year = key.formattedYear()
            let month = String(Date().getMonth(from: key)) + "월"
                        
            var monthlyIncomePrice = 0
            var monthlyExpensesPrice = 0
            
            monthlyIncomePrice = accounts.reduce(0) { result, account in
                if account.type == "수입", let price = Int(account.price.replacingOccurrences(of: ",", with: "").replacingOccurrences(of: "원", with: "")) { return result + price }
                return result
            }
            
            monthlyExpensesPrice = accounts.reduce(0) { result, account in
                if account.type == "지출", let price = Int(account.price.replacingOccurrences(of: ",", with: "").replacingOccurrences(of: "원", with: "")) { return result + price }
                return result
            }
            
            return MonthlyAccount(date:key, year: year, month: month, incomePrice: formatPrice(monthlyIncomePrice), expensesPrice: formatPrice(monthlyExpensesPrice), sumPirce: formatPrice(monthlyIncomePrice - monthlyExpensesPrice))
        }
        
        monthlySummaries.sort{ $0.month > $1.month }
    }
    
    /*
     * 가계부 탭 메뉴에 데이터 보여주기 위한 함수
     */
    func loadAccountTabData(date: Date) {
        
        Just(date)
            .sink { [weak self] date in
                var incomePrice: Int = 0
                var expensesPrice: Int = 0

                guard let data = UserDefaults.standard.data(forKey: "UserAccounts") else { return }
                
                do {
                    var accounts = try JSONDecoder().decode([Account].self, from: data)
                    accounts.sort { $0.id > $1.id }
                    
                    for account in accounts {
                        if date.formattedYearAndMonth() == account.date.formattedYearAndMonth() {
                            if account.type == "수입" {
                                let cleanedPrice = account.price.replacingOccurrences(of: ",", with: "").replacingOccurrences(of: "원", with: "")
                                if let price = Int(cleanedPrice) { incomePrice += price }
                            }
                            if account.type == "지출" {
                                let cleanedPrice = account.price.replacingOccurrences(of: ",", with: "").replacingOccurrences(of: "원", with: "")
                                if let price = Int(cleanedPrice) { expensesPrice += price }
                            }
                        }
                    }
                    
                    self?.tabInfo.incomePrice = self?.formatPrice(incomePrice) ?? "0원"
                    self?.tabInfo.expensesPrice = self?.formatPrice(expensesPrice) ?? "0원"
                    self?.tabInfo.sumPrice = self?.formatPrice(incomePrice - expensesPrice) ?? "0원"
                } catch {
                    print("Error decoding assets: \(error)")
                }
            }
            .store(in: &cancellables)
    }

    // MARK: - Helper Functions
    
    /*
     * 가계부 최신화
     */
    private func saveAccounts(_ accounts: [Account]) {
        do {
            let data = try JSONEncoder().encode(accounts)
            UserDefaults.standard.setValue(data, forKey: "UserAccounts")
            loadAccountTabData(date: currentDate)
            updateDailySummaries()
            updateMonthlySummaries()
            memoList = loadMemoList()
            favoritedAccounts = loadFavoriteAccount()
        } catch {
            print("Error encoding assets: \(error)")
        }
    }
    
    /*
     * 금액에 콤마와 맨 뒷자리에 원 추가
     */
    private func formatPrice(_ price: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        
        if let formattedPrice = formatter.string(from: NSNumber(value: price)) {
            return formattedPrice + "원"
        } else {
            return "\(price)원"
        }
    }
}
