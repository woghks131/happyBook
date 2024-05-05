//
//  DetailAccountView.swift
//  HappyBook
//
//  Created by 박재환 on 5/1/24.
//

import SwiftUI

struct DetailAccountView: View {
    var account: Account
    
    @Environment(\.presentationMode) var presentationMode
    
    @State var pickerOption: String
    
    init(account: Account) {
        self.account = account
        self._pickerOption = State(initialValue: account.type)
    }
    
    
    var body: some View {
        DetailAccountNavigationView(title: pickerOption, backButtonAction: dismiss)
        DetailAccountContentsView(pickerOption: $pickerOption, account: account)
        Spacer()
    }
    
    private func dismiss() {
        presentationMode.wrappedValue.dismiss()
    }
}
