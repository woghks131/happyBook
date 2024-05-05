//
//  DeleteButtonView.swift
//  HappyBook
//
//  Created by 박재환 on 5/1/24.
//

import SwiftUI

struct DeleteButtonView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @State private var showingAlert = false
    
    let id: Int
    
    @EnvironmentObject var store: Store
    
    var body: some View {
        HStack {
            Button(action: {
                showingAlert = true
            }) {
                Text("삭제")
                    .padding()
                    .frame(width: UIScreen.main.bounds.width * 0.25, height: 50)
                    .background(RoundedRectangle(cornerRadius: 10).strokeBorder())
                    .foregroundStyle(.gray)
            }
        }
        .alert(isPresented: $showingAlert, content: {
            Alert(title: Text("알림"), message: Text("정말 삭제하시겠습니까?"),
                  primaryButton: .default(Text("확인"), action: {
                        store.deleteData(id: id)
                        dismiss()
                    }),
                  secondaryButton: .cancel(Text("취소")))
        })
    }
    
    private func dismiss() {
        presentationMode.wrappedValue.dismiss()
    }
}

#Preview {
    DeleteButtonView(id: 0)
}
