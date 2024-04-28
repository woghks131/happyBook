//
//  ContentsInputView.swift
//  HappyBook
//
//  Created by 박재환 on 4/27/24.
//

import SwiftUI

struct ContentsInputView: View {
    @Binding var contents: String
    @Binding var pickerOption: String
    
    @State var isPresented: Bool
    
    var body: some View {
        HStack {
            Text("내용")
                .font(.system(size: 15))
                .foregroundStyle(.gray)
            
            TextField("", text: $contents)
                .multilineTextAlignment(.center)
                .keyboardType(.numberPad)
                .padding()
                .onTapGesture {
                    isPresented = true
                }
                .overlay(
                    Rectangle()
                        .frame(height: 2)
                        .padding(.top, 35)
                        .padding(.horizontal)
                        .foregroundStyle(isPresented ? pickerOption == "수입" ? .blue : .red : .gray)
                )
                .onAppear(perform: {
                    UIApplication.shared.hideKeyboard()
                    self.isPresented = false
                })
                .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)) { _ in
                    isPresented = false
                }
        }
        .padding([.top, .bottom], 1)
        .padding([.leading, .trailing])
    }
}

#Preview {
    ContentsInputView(contents: .constant(""), pickerOption: .constant("수입"), isPresented: false)
}
