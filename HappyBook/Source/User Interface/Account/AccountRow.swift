//
//  AccountRow.swift
//  HappyBook
//
//  Created by 박재환 on 4/21/24.
//

import SwiftUI

struct AccountRow: View {
    @EnvironmentObject private var store: Store
    var daily: DailyAccount
    @State private var detailAccount: Account?
    
    var body: some View {
        VStack {
            headView
            DividerView()
            memoView
            DividerView()
            accountView
                .sheet(item: $detailAccount) { da in
                    DetailAccountView(account: da)
                }
        }
        .padding(.bottom, 15)
    }
        
}

private extension AccountRow {
    
    var headView: some View {
        HStack {
            Text(daily.day)
                .font(.headline).fontWeight(.bold)
            Text(daily.week)
                .font(.subheadline)
                .frame(width: 50, height: 20)
                .foregroundStyle(.white)
                .background(.peach)
                .clipShape(RoundedRectangle(cornerRadius: 6))
            Text(daily.yearAndMonth)
                .font(.system(size: 12))
                .foregroundStyle(.gray)
                .padding(.top,3)
            Spacer()
            Text(daily.totalIncomePrice)
                .font(.headline)
                .foregroundStyle(.blue)
            Spacer()
            Text(daily.totalExpensesPrice)
                .font(.headline)
                .foregroundStyle(.red)
        }
        .padding(5)
        
    }
    
    var memoView: some View {
        ForEach(daily.accounts, id: \.self) { account in
            if !account.memo.isEmpty {
                HStack {
                    Symbol("list.clipboard", scale: .small, color: .peach)
                    Text(account.memo)
                        .font(.system(size: 10))
                        .lineLimit(1)
                    Spacer()
                }
                .padding(.leading, 10)
                .padding(.trailing, 10)
            }
        }
    }
    
    var accountView: some View {
        
        ForEach(daily.accounts, id: \.self) { account in
            HStack {
                Symbol(account.division.imageName, scale: .small, color: .black)
                    .frame(width: 20)
                Text(account.division.name)
                    .frame(width: 80, alignment: .leading)
                    .font(.system(size: 13))
                    .foregroundStyle(.gray)
                
                VStack {
                    Text(account.asset)
                        .font(.system(size: 13))
                        .foregroundStyle(.gray)
                    Text(account.dailyTime ?? "")
                        .font(.system(size: 13))
                        .foregroundStyle(.gray)
                }
                
                Spacer()
                
                Text(account.price)
                    .font(.headline)
                    .foregroundStyle(account.type == "수입" ? .blue : .red)
            }
            .onTapGesture {
                detailAccount = account
            }
            .padding([.top, .bottom], 5)
            .padding([.leading, .trailing])
            
        }
    }
}

#Preview {
    AccountRow(daily: DailyAccount(date: .now, yearAndMonth: "123", day: "", week: "'", totalIncomePrice: "", totalExpensesPrice: "", accounts: [Account(id: 1, type: "수입", date: .now, price: "3000", division: Division(name: "교통/차량", imageName: "cart"), asset: "카드", contents: "내용", memo: "")]))
        .environmentObject(Store())
}
