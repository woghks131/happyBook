//
//  InsertAccountView.swift
//  HappyBook
//
//  Created by 박재환 on 4/22/24.
//

import SwiftUI

struct InsertAccountView: View {
    @Environment(\.presentationMode) var presentationMode
    
    /*
     * @State 가계부 데이터 저장값
     */
    @State private var pickerOption: String = "수입"     // defualt 수입 탭으로 설정
    @State private var date: Date = Date()      // 날짜
    @State private var price: String = ""       // 금액
    @State private var division: Division = Division(name: "", imageName: "")   //분류
    @State private var asset: String = ""       // 자산
    @State private var contents: String = ""    // 내용
    @State private var memo: String = ""        // 메모
    
    var body: some View {
        InsertAccountNavigationView(title: pickerOption, backButtonAction: dismiss)
        InsertAccountContentsView(
            pickerOption: $pickerOption,
            date: $date,
            price: $price,
            division: $division,
            asset: $asset,
            contents: $contents,
            memo: $memo
        )

        
        Spacer()
    }
    
    private func dismiss() {
        presentationMode.wrappedValue.dismiss()
    }
}

#Preview {
    InsertAccountView()
}
