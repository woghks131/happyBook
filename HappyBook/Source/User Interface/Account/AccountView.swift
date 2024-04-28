//
//  AccountView.swift
//  HappyBook
//
//  Created by 박재환 on 4/21/24.
//

import SwiftUI

enum TabMenu : String, CaseIterable {
    case day = "일일"
    case calendar = "달력"
    case month = "월별"
    case memo = "메모"
}


struct AccountView: View {
    @EnvironmentObject private var store: Store
    
    @State private var currentDate = Date()     //현재 년월 가져오기
    @State private var selectedPicker: TabMenu = .day   //탭바 구성 디폴트 '일일'
    @State private var showingInsertAccountView : Bool = false  //플로팅버튼

    var body: some View {
        NavigationView {
            ZStack(alignment: .bottomTrailing) {
                VStack {
                    
                    AccountTabMenuView(selectedPicker: $selectedPicker)
                    
                    DividerView()
                    
                    if (selectedPicker == .day) {
                        accountList
                    } else if (selectedPicker == .calendar) {
                        Text("2")
                    } else if (selectedPicker == .month) {
                        Text("3")
                    } else if (selectedPicker == .memo) {
                        Text("4")
                    }
                    
                    Spacer()
                }
                    .navigationBarItems(leading: leadingItems, trailing: trailingItems)
                
                AccountFloatingButtonView(showingInsertAccountView: $showingInsertAccountView)
            }
        }
    }
}




private extension AccountView {
    
    var leadingItems: some View {
        HStack(spacing:3) {
            Button(action: { 
                currentDate = currentDate.previousMonth
            }) {
                Text("<")
                    .font(.headline)
                    .foregroundStyle(.black)
                
            }
            
            Text(currentDate.formattedYearAndMonth())
                .font(.headline)
            
            Button(action: { 
                currentDate = currentDate.nextMonth
            }) {
                Text(">")
                    .font(.headline)
                    .foregroundStyle(.black)
            }
        }
    }
    
    var trailingItems: some View {
        HStack {
            
            //즐겨찾기
            Button(action: {
                print("불러오기 : \(store.loadData())")
                
            }) {
                Symbol("star", scale: .large, color: .primary)
                    
            }
            
            //검색
            Button(action: {}) {
                Symbol("magnifyingglass", scale: .large, color: .primary)
            }
            
            //필터링
            Button(action: {}) {
                Symbol("slider.horizontal.3", scale: .large, color: .primary)
            }
        }
    }
    
    var accountList: some View {
        List {
            AccountRow()
        }
        .listStyle(PlainListStyle())
        .background(Color.background)
    }
    
    var floatingButton: some View {
        Button(action: {
            showingInsertAccountView = true
        }) {
            Symbol("plus", scale: .large, color: .white)
                .font(.title.weight(.semibold))
                .padding()
                .background(.peach)
                .clipShape(Circle())
                .shadow(radius: 4, x: 0, y: 4)
        }
        .padding()
        .sheet(isPresented: $showingInsertAccountView){
            InsertAccountView()
        }
    }
}

#Preview {
    AccountView()
        .environmentObject(Store())
}
