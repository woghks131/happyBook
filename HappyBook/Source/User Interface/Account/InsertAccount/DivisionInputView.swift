//
//  DivisionInputView.swift
//  HappyBook
//
//  Created by 박재환 on 4/26/24.
//

import SwiftUI

struct DivisionInputView: View {
    @Binding var division: Division
    @Binding var pickerOption: String
    
    @State var isPresented: Bool
    @State var detents: PresentationDetent = .medium    // 하단시트 크기
    
    var body: some View {
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
                
                isPresented = true
            }
            .overlay(
                Rectangle()
                    .frame(height: 2)
                    .padding(.top, 35)
                    .padding(.horizontal)
                    .foregroundStyle(isPresented ? pickerOption == "수입" ? .blue : .red : .gray)
            )
            .sheet(isPresented: $isPresented) {
                DivisionModalView(division: $division)
                        // 높이 선택 값 바인딩)
                        .presentationDetents([.medium, .large], selection: $detents)
            }
            
            
        }
        .padding([.top, .bottom], 1)
        .padding([.leading, .trailing])
    }
}

#Preview {
    DivisionInputView(division: .constant(Division(name: "", imageName: "")), pickerOption: .constant("수입"), isPresented: false)
}
