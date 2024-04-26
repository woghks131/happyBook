//
//  InsertAccountView.swift
//  HappyBook
//
//  Created by 박재환 on 4/22/24.
//

import SwiftUI

struct InsertAccountView: View {
    @Environment(\.presentationMode) var presentationMode
    
    // 수입/지출 picker
    private let pickerDataSource = ["수입", "지출"]
    @State var pickerOption: String = "수입"
    
    //하단시트 크기
    @State var detents: PresentationDetent = .medium
    
    //날짜
    @State private var date: Date = Date()

    //금액
    @State private var price: String = ""
    @State private var isPricePresented = false
    
    //분류
    @State private var division: Division = Division(name: "", imageName: "")
    @State private var isDivisionSheetPresented = false
    
    //자산
    @State private var asset: String = ""
    @State private var isAssetSheetPresented = false
    
    //내용
    @State private var contents: String = ""
    @State private var isContentsPresented = false
    
    //메모
    @State private var memo: String = ""
    @State private var isMemoPresented = false
    
    @State private var showingAlert = false
    @State private var alertItem: String = ""
    
    

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
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter
    }
    
    var DateView: some View {
        HStack {
            Text("날짜")
                .font(.system(size: 15))
                .foregroundStyle(.gray)
            DatePicker(selection: $date, in: ...Date(), displayedComponents: .date
            ) {}.padding()
                .environment(\.locale, Locale(identifier: "ko_KR"))
                .labelsHidden()
            DatePicker(selection: $date, in: ...Date(), displayedComponents: .hourAndMinute
            ) {}
                .environment(\.locale, Locale(identifier: "ko_KR"))
                .padding()
                
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
                .onChange(of: price) { newValue in
                    
                    // 입력된 값에서 숫자와 콤마를 제외한 문자를 모두 제거합니다.
                    let filtered = newValue.filter { "0123456789".contains($0) }
                    // 숫자를 세 자리 콤마로 구분하여 표시합니다.
                    price = formatAmount(filtered)
                }
                
        }
        .padding([.top, .bottom], 1)
        .padding([.leading, .trailing])
    }
    
    // 세 자리 콤마로 포맷하는 함수
    private func formatAmount(_ amount: String) -> String {
        guard !amount.isEmpty else { return "" }

        // 입력된 숫자 문자열을 Int로 변환합니다.
        let number = Int(amount) ?? 0
        // 숫자를 세 자리 콤마로 포맷하여 반환합니다.
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.string(from: NSNumber(value: number)) ?? ""
    }
    
    var DivisionView: some View {
        HStack {
            Text("분류")
                .font(.system(size: 15))
                .foregroundStyle(.gray)
            
            HStack {
                Symbol(division.imageName, scale: .small, color: .black)
                Text(division.name)
            }
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
                DivisionModalView(division: $division)
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
        private let categories:[Division] = Store().divisions
        @Binding var division: Division
        
        var body: some View {
            GeometryReader { g in
                VStack(spacing: 0) {
                    Text("분류")
                        .padding()
                        .frame(width: g.size.width, height: 40, alignment: .leading)
                        .font(.headline)
                        .foregroundStyle(.white)
                        .background(.peach)
                    
                    LazyVGrid(
                        columns: Array(repeating: GridItem(spacing: 0),
                        count: 4
                    ), spacing: 0)
                    {
                        ForEach(categories) { category in
                            CategoryButton(imageName: category.imageName, text: category.name, selectedDivision: $division)
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
        @Binding var selectedDivision: Division
        @Environment(\.presentationMode) var presentationMode
        
        var body: some View {
            Button(action: {
                selectedDivision = Division(name: text, imageName: imageName)
                presentationMode.wrappedValue.dismiss()
            }) {
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
            Text(asset)
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
                    AssetModalView(asset: $asset)
                            // 높이 선택 값 바인딩)
                            .presentationDetents([.medium, .large], selection: $detents)
                }
        }
        
    }
    
    //자산 바텀시트
    struct AssetModalView: View {
        
        //자산 카테고리
        @ObservedObject var categories = Store()
        @Binding var asset: String
        
        var body: some View {
            GeometryReader { g in
                VStack(spacing: 0) {
                    Text("자산")
                        .padding()
                        .frame(width: g.size.width, height: 40, alignment: .leading)
                        .font(.headline)
                        .foregroundStyle(.white)
                        .background(.peach)
                    
                    LazyVGrid(
                        columns: Array(repeating: GridItem(spacing: 0),
                        count: 4
                    ), spacing: 0)
                    {
                        ForEach(Array(categories.assets)) { asset in
                            AssetCategoryButton(imageName: "", text: asset.name, selectedAsset: $asset)
                        }
                    }
                }
            }
        }
    }
    
    //자산 버튼카테고리
    struct AssetCategoryButton: View {
        let imageName: String   //버튼 이미지
        let text: String        //버튼 이름
        @Binding var selectedAsset: String
        @Environment(\.presentationMode) var presentationMode
        
        var body: some View {
            Button(action: {
                selectedAsset = text
                presentationMode.wrappedValue.dismiss()
            }) {
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
                if validationCheck() {
                    self.presentationMode.wrappedValue.dismiss()
                }
            }) {
                Text("저장하기")
                    .padding()
                    .frame(width: UIScreen.main.bounds.width * 0.75, height: 50)
                    .background(RoundedRectangle(cornerRadius: 10).strokeBorder())
                    .foregroundStyle(pickerOption == "수입" ? .blue : .red)
            }
        }
        .alert(isPresented: $showingAlert, content: {
            Alert(title: Text("알림"), message: Text("\(alertItem)을(를) 확인해 주세요."),
                  dismissButton: .default(Text("확인")))
        })
    }
    
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
        
        
        return true
    }
    
}


#Preview {
    InsertAccountView()
}
