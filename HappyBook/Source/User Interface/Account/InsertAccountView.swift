//
//  InsertAccountView.swift
//  HappyBook
//
//  Created by 박재환 on 4/22/24.
//

import SwiftUI

struct InsertAccountView: View {
    @Environment(\.presentationMode) var presentationMode
    
    private let pickerDataSource = ["수입", "지출"]
    @State var pickerOption: String = "수입"
    
    @State var detents: PresentationDetent = .medium
    
    @State private var isDateSheetPresented = false
    @State private var date: Date = Date()

    @State private var price: String = ""
    @State private var isPricePresented = false
    
    @State private var isDivisionSheetPresented = false
    @State private var isAssetSheetPresented = false
    
    @State private var contents: String = ""
    @State private var isContentsPresented = false
    
    @State private var memo: String = ""
    @State private var isMemoPresented = false

    var body: some View {
        navigationBarView
        acccountPicker
        accountInputView
        Spacer()
    }
}

private extension InsertAccountView {
    
    var navigationBarView: some View {
        VStack {
            HStack {
                Button(action: { 
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    Symbol("arrow.left", scale: .small, color: .black)
                }
                .padding(.trailing, 10)
                
                Text("수입")
                    .font(.headline)
                
                Spacer()
            }.padding()
        }
    }
    
    var acccountPicker: some View {
        Picker("", selection: $pickerOption) {
            ForEach(pickerDataSource, id: \.self) {
                Text($0)
                    .foregroundStyle(.white)
            }
        }
        .pickerStyle(SegmentedPickerStyle())
        .frame(height: 72)
        .padding()
    }
    
    var accountInputView: some View {
        VStack {
            DateView
            PriceView
            DivisionView
            AssetView
            ContentsView
            MemoView
            SaveButtonView
        }
        
    }
    
    var DateView: some View {
        HStack {
            Text("날짜")
                .font(.system(size: 15))
                .foregroundStyle(.gray)
            Text("")
                .frame(width: UIScreen.main.bounds.width * 0.75, height: 30)
                .background(.white)
                .multilineTextAlignment(.center)
                .padding()
                .tint(.clear)
                .onTapGesture {

                }
                .overlay(
                    Rectangle()
                        .frame(height: 2)
                        .padding(.top, 35)
                        .padding(.horizontal)
                        .foregroundStyle(isDateSheetPresented ? pickerOption == "수입" ? .blue : .red : .gray)
                )
        }
        .padding([.top, .bottom], 1)
        .padding([.leading, .trailing])
    }
    
    var PriceView: some View {
        HStack {
            Text("금액")
                .font(.system(size: 15))
                .foregroundStyle(.gray)
            TextField("", text: $price)
                .multilineTextAlignment(.center)
                .keyboardType(.numberPad)
                .padding()
                .onTapGesture {
                    isPricePresented = true
                }
                .overlay(
                    Rectangle()
                        .frame(height: 2)
                        .padding(.top, 35)
                        .padding(.horizontal)
                        .foregroundStyle(isPricePresented ? pickerOption == "수입" ? .blue : .red : .gray)
                )
                .onAppear(perform: {
                    UIApplication.shared.hideKeyboard()
                    self.isPricePresented = false
                })
                .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)) { _ in
                                    // 키보드가 내려갈 때 색상을 회색으로 변경
                                    isPricePresented = false
                                }
        }
        .padding([.top, .bottom], 1)
        .padding([.leading, .trailing])
    }
    
    var DivisionView: some View {
        HStack {
            Text("분류")
                .font(.system(size: 15))
                .foregroundStyle(.gray)
            Text("")
                .frame(width: UIScreen.main.bounds.width * 0.75, height: 30)
                .background(.white)
                .multilineTextAlignment(.center)
                .padding()
                .tint(.clear)
                .onTapGesture {
                    
                    isDivisionSheetPresented = true
                }
                .overlay(
                    Rectangle()
                        .frame(height: 2)
                        .padding(.top, 35)
                        .padding(.horizontal)
                        .foregroundStyle(isDivisionSheetPresented ? pickerOption == "수입" ? .blue : .red : .gray)
                )
                .sheet(isPresented: $isDivisionSheetPresented) {
                    DivisionModalView()
                            // 높이 선택 값 바인딩)
                            .presentationDetents([.medium, .large], selection: $detents)
                }
        }
        .padding([.top, .bottom], 1)
        .padding([.leading, .trailing])
        
    }
    
    //분류 바텀시트
    struct DivisionModalView: View {
        
        //분류 카테고리
        private let categories = [
            ["식비", "fork.knife"],
            ["교통/차량", "car"],
            ["문화생활", "photo.circle"],
            ["마트/편의점", "cart"],
            ["패션/미용", "hanger"],
            ["생활용품", "pencil"],
            ["주거/통신", "house"],
            ["건강", "figure.walk.motion"],
            ["교육", "book"],
            ["경조사/회비", "archivebox"],
            ["부모님", "person"],
            ["기타", ""]
        ]
        
        var body: some View {
            GeometryReader { g in
                VStack(spacing: 0) {
                    Text("분류")
                        .padding()
                        .frame(width: g.size.width, height: 40, alignment: .leading)
                        .font(.headline)
                        .foregroundStyle(.white)
                        .background(.peach)
                    
                    VStack(spacing: 0) {
                        ForEach(0..<3, id: \.self) { row in
                            HStack(spacing: 0) {
                                ForEach(0..<4, id: \.self) { column in
                                    CategoryButton(
                                        imageName: self.categories[row * 4 + column][1], text: self.categories[row * 4 + column][0]
                                    )
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    //분류 버튼카테고리
    struct CategoryButton: View {
        let imageName: String   //버튼 이미지
        let text: String        //버튼 이름
        
        var body: some View {
            Button(action: {}) {
                HStack {
                    Symbol(imageName, scale: .small, color: .black)
                    
                    Text(text)
                        .font(.system(size: 15))
                        .foregroundStyle(.black)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 60)
            .border(.gray)
        }
    }
    
    var AssetView: some View {
        HStack {
            Text("자산")
                .font(.system(size: 15))
                .foregroundStyle(.gray)
            Text("")
                .frame(width: UIScreen.main.bounds.width * 0.75, height: 30)
                .background(.white)
                .multilineTextAlignment(.center)
                .padding()
                .tint(.clear)
                .onTapGesture {
                    
                    isAssetSheetPresented = true
                }
                .overlay(
                    Rectangle()
                        .frame(height: 2)
                        .padding(.top, 35)
                        .padding(.horizontal)
                        .foregroundStyle(isAssetSheetPresented ? pickerOption == "수입" ? .blue : .red : .gray)
                )
                .sheet(isPresented: $isAssetSheetPresented) {
                    AssetModalView()
                            // 높이 선택 값 바인딩)
                            .presentationDetents([.medium, .large], selection: $detents)
                }
        }
        
    }
    
    //자산 바텀시트
    struct AssetModalView: View {
        
        //자산 카테고리
        private let categories = ["현금","신한은행","카카오뱅크","하나은행","삼성카드","하나카드"]
        
        var body: some View {
            GeometryReader { g in
                VStack(spacing: 0) {
                    Text("자산")
                        .padding()
                        .frame(width: g.size.width, height: 40, alignment: .leading)
                        .font(.headline)
                        .foregroundStyle(.white)
                        .background(.peach)
                    
                    VStack(spacing: 0) {
                        HStack(spacing: 0) {
                            CategoryButton(
                                imageName: "", text: self.categories[0]
                            )
                            CategoryButton(
                                imageName: "", text: self.categories[1]
                            )
                            CategoryButton(
                                imageName: "", text: self.categories[2]
                            )
                            CategoryButton(
                                imageName: "", text: self.categories[3]
                            )
                        }
                        HStack(spacing: 0) {
                            CategoryButton(
                                imageName: "", text: self.categories[4]
                            )
                            CategoryButton(
                                imageName: "", text: self.categories[5]
                            )
                        }
                    }
                }
            }
        }
    }
    
    var ContentsView: some View {
        HStack {
            Text("내용")
                .font(.system(size: 15))
                .foregroundStyle(.gray)
            
            TextField("", text: $contents)
                .multilineTextAlignment(.center)
                .keyboardType(.numberPad)
                .padding()
                .onTapGesture {
                    isContentsPresented = true
                }
                .overlay(
                    Rectangle()
                        .frame(height: 2)
                        .padding(.top, 35)
                        .padding(.horizontal)
                        .foregroundStyle(isContentsPresented ? pickerOption == "수입" ? .blue : .red : .gray)
                )
                .onAppear(perform: {
                    UIApplication.shared.hideKeyboard()
                    self.isContentsPresented = false
                })
                .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)) { _ in
                                    // 키보드가 내려갈 때 색상을 회색으로 변경
                    isContentsPresented = false
                                }
        }
        .padding([.top, .bottom], 1)
        .padding([.leading, .trailing])
    }
    
    var MemoView: some View {
        HStack {
            Text("메모")
                .font(.system(size: 15))
                .foregroundStyle(.gray)
            
            TextField("", text: $memo)
                .multilineTextAlignment(.center)
                .keyboardType(.numberPad)
                .padding()
                .onTapGesture {
                    isMemoPresented = true
                }
                .overlay(
                    Rectangle()
                        .frame(height: 2)
                        .padding(.top, 35)
                        .padding(.horizontal)
                        .foregroundStyle(isMemoPresented ? pickerOption == "수입" ? .blue : .red : .gray)
                )
                .onAppear(perform: {
                    UIApplication.shared.hideKeyboard()
                    self.isMemoPresented = false
                })
                .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)) { _ in
                                    // 키보드가 내려갈 때 색상을 회색으로 변경
                    isMemoPresented = false
                                }
        }
        .padding([.top, .bottom], 1)
        .padding([.leading, .trailing])
    }
    
    var SaveButtonView: some View {
        HStack {
            Button(action: { 
                self.presentationMode.wrappedValue.dismiss()
            }) {
                Text("저장하기")
                    .padding()
                    .frame(width: UIScreen.main.bounds.width * 0.75, height: 50)
                    .background(RoundedRectangle(cornerRadius: 10).strokeBorder())
                    .foregroundStyle(pickerOption == "수입" ? .blue : .red)
            }
        }
    }
}


#Preview {
    InsertAccountView()
}
