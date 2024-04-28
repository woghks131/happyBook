//
//  AccountTabMenuView.swift
//  HappyBook
//
//  Created by 박재환 on 4/27/24.
//

import SwiftUI

struct AccountTabMenuView: View {
    
    @Binding var selectedPicker: TabMenu
    @EnvironmentObject var store: Store
    @Namespace private var animation
    
    var body: some View {
        VStack {
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
            
            if (selectedPicker != .memo) {
                HStack {
                    Spacer()
                    VStack {
                        Text("수입")
                        Text(store.tabInfo.incomePrice)
                            .foregroundStyle(.blue)
                    }
                    Spacer()
                    Spacer()
                    VStack {
                        Text("지출")
                        Text(store.tabInfo.expensesPrice)
                            .foregroundStyle(.red)
                    }
                    Spacer()
                    Spacer()
                    VStack {
                        Text("합계")
                        Text(store.tabInfo.sumPrice)
                    }
                    Spacer()
                }
                .font(.system(size: 15))
            }
            
            
        }
    }
}

#Preview {
    AccountTabMenuView(selectedPicker: .constant(.day))
        .environmentObject(Store())
}
