//
//  DivisionModalView.swift
//  HappyBook
//
//  Created by 박재환 on 4/26/24.
//

import SwiftUI

struct DivisionModalView: View {
    
    @Binding var division: Division
    
    private let categories:[Division] = Store().divisions

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
                        DIvisionCategoryButton(imageName: category.imageName, text: category.name, selectedDivision: $division)
                    }
                }
            }
        }
    }
}

#Preview {
    DivisionModalView(division: .constant(Division(name: "", imageName: "")))
}
