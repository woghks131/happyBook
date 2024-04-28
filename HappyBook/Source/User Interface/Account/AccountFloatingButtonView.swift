//
//  AccountFloatingButtonView.swift
//  HappyBook
//
//  Created by 박재환 on 4/27/24.
//

import SwiftUI

struct AccountFloatingButtonView: View {
    
    @Binding var showingInsertAccountView: Bool
    
    var body: some View {
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
    AccountFloatingButtonView(showingInsertAccountView: .constant(false))
        .environmentObject(Store())
}
