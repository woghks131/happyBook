//
//  AssetModalView.swift
//  HappyBook
//
//  Created by 박재환 on 4/26/24.
//

import SwiftUI

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

#Preview {
    AssetModalView(asset: .constant(""))
}
