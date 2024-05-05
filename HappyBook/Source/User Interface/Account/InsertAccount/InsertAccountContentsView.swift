//
//  InsertAccountContentsView.swift
//  HappyBook
//
//  Created by 박재환 on 4/26/24.
//

import SwiftUI

struct InsertAccountContentsView: View {
    @Binding var pickerOption: String
    @Binding var date: Date
    @Binding var price: String
    @Binding var division: Division
    @Binding var asset: String
    @Binding var contents: String
    @Binding var memo: String
    
    private let pickerDataSource = ["수입", "지출"]
    
    var body: some View {
        Picker("", selection: $pickerOption) {
            ForEach(pickerDataSource, id: \.self) {
                Text($0)
                    .foregroundStyle(.white)
            }
        }
        .pickerStyle(SegmentedPickerStyle())
        .frame(height: 72)
        .padding()
        
        VStack {
            DateInputView(date: $date)
            PriceInputView(price: $price, pickerOption: $pickerOption, isPresented: false)
            DivisionInputView(division: $division, pickerOption: $pickerOption, isPresented: false)
            AssetInputView(asset: $asset, pickerOption: $pickerOption, isPresented: false)
            ContentsInputView(contents: $contents, pickerOption: $pickerOption, isPresented: false)
            MemoInputView(memo: $memo, pickerOption: $pickerOption, isPresented: false)
            SaveButtonView(pickerOption: $pickerOption, date: $date, price: $price, division: $division, asset: $asset, contents: $contents, memo: $memo)
        }
    }
}

#Preview {
    InsertAccountContentsView(pickerOption: .constant("수입"), date: .constant(.now), price: .constant(""), division: .constant(Division(name: "", imageName: "")), asset: .constant(""), contents: .constant(""), memo: .constant(""))
        .environmentObject(Store())
}
