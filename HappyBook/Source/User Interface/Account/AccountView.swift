//
//  AccountView.swift
//  HappyBook
//
//  Created by 박재환 on 4/21/24.
//

import SwiftUI

private enum TabMenu : String, CaseIterable {
    case day = "일일"
    case calendar = "달력"
    case month = "월별"
    case memo = "메모"
}


struct AccountView: View {
    
    @State private var selectedPicker: TabMenu = .day
    @Namespace private var animation
    
    @State private var showingPopup: Bool = false
    @State private var showingInsertAccountView : Bool = false
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .bottomTrailing) {
                VStack {
                    tabMenu
                    if (selectedPicker != .memo) {
                        totalView
                    }
                    
                    darkerDivider
                    
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
                
                floatingButton
            }
        }
    }
}




private extension AccountView {

    var leadingItems: some View {
        HStack(spacing:3) {
            Button(action: { }) {
                Text("<")
                    .font(.headline)
                    .foregroundStyle(.black)
                
            }
            
            Text("2024년 4월")
                .font(.headline)
                .onTapGesture {
                    showingPopup = true
                }
            
            Button(action: { }) {
                Text(">")
                    .font(.headline)
                    .foregroundStyle(.black)
            }
        }
    }
    
    var trailingItems: some View {
        HStack {
            
            //즐겨찾기
            Button(action: {}) {
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
    
    var tabMenu: some View {
        HStack {
            ForEach(TabMenu.allCases, id: \.self) { item in
                VStack {
                    Text(item.rawValue)
                        .font(.headline)
                        .frame(maxWidth: .infinity/CGFloat(TabMenu.allCases.count), maxHeight: 40)
                        .foregroundStyle(selectedPicker == item ? .peach : .gray)
                    if selectedPicker == item {
                        Capsule()
                            .foregroundStyle(.peach)
                            .frame(height: 3)
                            .matchedGeometryEffect(id: "day", in: animation)
                    }
                }
                .onTapGesture {
                    withAnimation(.easeInOut) {
                        self.selectedPicker = item
                    }
                }
            }
        }
    }
    
    var totalView: some View {
        HStack {
            Spacer()
            VStack {
                Text("수입")
                Text("3,500")
                    .foregroundStyle(.blue)
            }
            Spacer()
            Spacer()
            VStack {
                Text("지출")
                Text("6,380")
                    .foregroundStyle(.red)
            }
            Spacer()
            Spacer()
            VStack {
                Text("합계")
                Text("-2,880")
            }
            Spacer()
        }
        .font(.system(size: 15))
    }
    
    var darkerDivider: some View {
      Color.primary
        .opacity(0.3)
        .frame(maxWidth: .infinity, maxHeight: 1)
    }
    
    var accountList: some View {
        List {
            AccountRow()
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
    
    func popupMessage() -> some View {
      return VStack {
        Text("name")
          .font(.title).bold().kerning(3)
          .foregroundColor(.peach)
          .padding()
      }
    }
}

#Preview {
    AccountView()
}
