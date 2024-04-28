//
//  DIvisionCategoryButton.swift
//  HappyBook
//
//  Created by 박재환 on 4/26/24.
//

import SwiftUI

struct DIvisionCategoryButton: View {
    let imageName: String   //버튼 이미지
    let text: String        //버튼 이름
    
    @Binding var selectedDivision: Division
    
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        Button(action: {
            selectedDivision = Division(name: text, imageName: imageName)
            dismiss()
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
    
    private func dismiss() {
        presentationMode.wrappedValue.dismiss()
    }
}

#Preview {
    DIvisionCategoryButton(imageName: "", text: "", selectedDivision: .constant(Division(name: "", imageName: "")))
}
