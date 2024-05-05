//
//  MemoRow.swift
//  HappyBook
//
//  Created by 박재환 on 5/4/24.
//

import SwiftUI

struct MemoRow: View {
    
    let account: Account
    
    var body: some View {
        memoInfoSection
    }
}

private extension MemoRow {
    var memoInfoSection: some View {
        Section(header:
                    HStack {
            Text(account.dailyTime!).fontWeight(.medium)
        })
        {
            Text(account.memo)
                .frame(height: 44)
        }
        
        
    }
}

#Preview {
    MemoRow(account: Account(id: 0, type: "", date: .now, price: "", division: Division(name: "", imageName: ""), asset: "", contents: "", memo: ""))
}
