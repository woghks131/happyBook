//
//  LoginView.swift
//  HappyBook
//
//  Created by 박재환 on 4/20/24.
//

import SwiftUI

struct LoginView: View {
    var body: some View {
        VStack {
            
            Spacer()
            
            Text("행복 가계부")
                .font(.largeTitle)
                .fontWeight(.medium)
                .foregroundStyle(.peach)
            
            Image("pig")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 150, height: 150)
            
            Spacer()
            Spacer()
            
            KakaoSignInButton()
        }
    }
}

#Preview {
    LoginView()
        .environmentObject(Store())
}
