//
//  AssetInputView.swift
//  HappyBook
//
//  Created by 박재환 on 4/26/24.
//

import SwiftUI

struct AssetInputView: View {
    
    @Binding var asset: String
    @Binding var pickerOption: String
    
    @State var isPresented: Bool
    @State var detents: PresentationDetent = .medium    // 하단시트 크기
        
    var body: some View {
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
                    AssetModalView(asset: $asset)
                            .presentationDetents([.medium, .large], selection: $detents)
                }
        }
    }
}

#Preview {
    AssetInputView(asset: .constant(""), pickerOption: .constant("수입"), isPresented: false)
}
