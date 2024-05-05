//
//  DetailAccountNavigationView.swift
//  HappyBook
//
//  Created by 박재환 on 5/1/24.
//

import SwiftUI

struct DetailAccountNavigationView: View {
    
    let title: String
    let backButtonAction: () -> Void
   
    var body: some View {
        HStack {
            Button(action: backButtonAction) {
                Image(systemName: "arrow.left")
                    .foregroundColor(.black)
            }
            .padding(.trailing, 10)
            
            Text(title).font(.headline)
            
            Spacer()
        }
        .padding()
    }
}

#Preview {
    InsertAccountNavigationView(title: "수입", backButtonAction: {})
}
