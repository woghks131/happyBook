//
//  FavoriteRow.swift
//  HappyBook
//
//  Created by 박재환 on 5/3/24.
//

import SwiftUI

struct FavoriteRow: View {
    
    let account: Account
    
    var body: some View {
        HStack {
            Symbol(account.division.imageName, scale: .small, color: .black)
                .frame(width: 20)
            Text(account.division.name)
                .frame(width: 80, alignment: .leading)
                .font(.system(size: 13))
                .foregroundStyle(.gray)
            
            VStack {
                Text(account.contents)
                    .font(.system(size: 13))
                    .foregroundStyle(.gray)
                Text(account.asset)
                    .font(.system(size: 13))
                    .foregroundStyle(.peach)
            }
            
            Spacer()
            
            Text("\(account.price)원")
                .font(.headline)
        }
        .padding()
    }
}

#Preview {
    FavoriteRow(account: Account(id: 0, type: "", date: .now, price: "", division: Division(name: "", imageName: ""), asset: "", contents: "", memo: ""))
}
