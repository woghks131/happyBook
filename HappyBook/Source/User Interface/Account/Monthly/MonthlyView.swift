//
//  MonthlyView.swift
//  HappyBook
//
//  Created by 박재환 on 5/5/24.
//

import SwiftUI

struct MonthlyView: View {
    
    @EnvironmentObject var store: Store
    
    var body: some View {
        VStack {
            monthlyRow
        }
    }
}

extension MonthlyView {
    
    private var monthlyRow: some View {
        
        ForEach(store.monthlySummaries, id: \.self) { monthly in
            HStack {
                Text(monthly.month).fontWeight(.bold)
                Spacer()
                Text(monthly.incomePrice)
                    .font(.headline)
                    .foregroundStyle(.blue)
                Spacer()
                VStack {
                    Text(monthly.expensesPrice)
                        .font(.headline)
                        .foregroundStyle(.red)
                    Text(monthly.sumPirce)
                        .font(.subheadline)
                        .foregroundStyle(.gray)
                }
            }
            .padding()
        }
        
    }
    
}

#Preview {
    MonthlyView()
}
