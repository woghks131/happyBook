//
//  PriceInputView.swift
//  HappyBook
//
//  Created by 박재환 on 4/26/24.
//

import SwiftUI

struct PriceInputView: View {
    
    @Binding var price: String
    @Binding var pickerOption: String
    
    @State var isPresented: Bool
    
    var body: some View {
        HStack {
            Text("금액")
                .font(.system(size: 15))
                .foregroundStyle(.gray)
            TextField("", text: $price)
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
                        // 키보드가 내려갈 때 색상을 회색으로 변경
                    isPresented = false
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
}

private extension PriceInputView {
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
}

#Preview {
    PriceInputView(price: .constant(""), pickerOption: .constant("수입"), isPresented: false)
}
