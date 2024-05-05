//
//  ModifyButtonView.swift
//  HappyBook
//
//  Created by 박재환 on 5/1/24.
//

import SwiftUI

struct ModifyButtonView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @State private var showingAlert = false
    @State private var alertItem: String = ""
    
    let id: Int
    @Binding var pickerOption: String
    @Binding var date: Date
    @Binding var price: String
    @Binding var division: Division
    @Binding var asset: String
    @Binding var contents: String
    @Binding var memo: String
    
    @EnvironmentObject var store: Store
    
    var body: some View {
        HStack {
            Button(action: {
                if validationCheck() {
                    dismiss()
                }
            }) {
                Text("수정하기")
                    .padding()
                    .frame(width: UIScreen.main.bounds.width * 0.45, height: 50)
                    .background(RoundedRectangle(cornerRadius: 10).strokeBorder())
                    .foregroundStyle(pickerOption == "수입" ? .blue : .red)
            }
        }
        .alert(isPresented: $showingAlert, content: {
            Alert(title: Text("알림"), message: Text("\(alertItem)을(를) 확인해 주세요."),
                  dismissButton: .default(Text("확인")))
        })
    }
    
    private func dismiss() {
        presentationMode.wrappedValue.dismiss()
    }
}

private extension ModifyButtonView {
    private func validationCheck() -> Bool {
        if price.isEmpty {
            alertItem = "금액"
            showingAlert = true
            return false
        } else if division.name.isEmpty {
            alertItem = "분류"
            showingAlert = true
            return false
        } else if asset.isEmpty {
            alertItem = "자산"
            showingAlert = true
            return false
        } else if contents.isEmpty {
            alertItem = "내용"
            showingAlert = true
            return false
        }
        

        var account = Account(id: id, type: pickerOption, date: date, price: price, division: division, asset: asset, contents: contents, memo: memo)
        store.updateData(account: &account)   //& : dailyTime을 변경해야하기 때문에
                
        return true
    }
}

#Preview {
    ModifyButtonView(id: 1, pickerOption: .constant("수입"), date: .constant(.now), price: .constant(""), division: .constant(Division(name: "", imageName: "")), asset: .constant(""), contents: .constant(""), memo: .constant(""))
}
