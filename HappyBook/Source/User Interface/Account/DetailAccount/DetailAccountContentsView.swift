//
//  DetailAccountContentsView.swift
//  HappyBook
//
//  Created by 박재환 on 5/1/24.
//

import SwiftUI

struct DetailAccountContentsView: View {
    
    @Binding var pickerOption: String
    var account: Account
    
    private let pickerDataSource = ["수입", "지출"]
    
    let id: Int
    @State var date: Date
    @State var price: String
    @State var division: Division
    @State var asset: String
    @State var contents: String
    @State var memo: String
    @State var favorite: Bool
    
    init(pickerOption: Binding<String>, account: Account) {
        self.id = account.id
        self._pickerOption = pickerOption
        self.account = account
        // account.date를 date에 바인딩
        self._date = State(initialValue: account.date)
        // 나머지 속성들은 기본값으로 초기화
        self._price = State(initialValue: account.price)
        self._division = State(initialValue: account.division)
        self._asset = State(initialValue: account.asset)
        self._contents = State(initialValue: account.contents)
        self._memo = State(initialValue: account.memo)
        self._favorite = State(initialValue: account.favorite)
    }
    
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
            
            HStack {
                ModifyButtonView(id: id, pickerOption: $pickerOption, date: $date, price: $price, division: $division, asset: $asset, contents: $contents, memo: $memo)
                DeleteButtonView(id: id)
                FavoriteButtonView(id: id, isFavorite: favorite)
                
            }
        }
    }
}

//#Preview {
//    DetailAccountContentsView()
//}
