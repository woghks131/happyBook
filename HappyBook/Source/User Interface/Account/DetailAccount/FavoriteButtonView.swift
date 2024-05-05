//
//  FavoriteButtonView.swift
//  HappyBook
//
//  Created by 박재환 on 5/1/24.
//

import SwiftUI

struct FavoriteButtonView: View {
    
    let id: Int
    @State var isFavorite: Bool
    
    @EnvironmentObject var store: Store
    
    var body: some View {
        Symbol(isFavorite ? "star.fill" : "star", scale: .large, color: .peach)
            .onTapGesture {
                withAnimation {
                    isFavorite.toggle()
                    store.updateFavoriteData(id: id, favorite: isFavorite)
                }
            }
    }
}

#Preview {
    FavoriteButtonView( id: 0, isFavorite: true)
}
