//
//  FavoriteView.swift
//  HappyBook
//
//  Created by 박재환 on 5/3/24.
//

import SwiftUI

struct FavoriteView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var store: Store
    
    var body: some View {
        ZStack {
            if store.favoritedAccounts.isEmpty {
                emptyFavoriteList
            } else {
                favoriteList
            }
        }
        .navigationTitle("즐겨찾기")
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: backButton, trailing: editButton)
    }
    
}

private extension FavoriteView {
    
    var emptyFavoriteList: some View {
        VStack(spacing: 25) {
          Image("box")
            .renderingMode(.template)
            .foregroundColor(Color.gray.opacity(0.4))
          
          Text("즐겨찾기가 없습니다")
            .font(.headline).fontWeight(.medium)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.background)
    }
    
    var favoriteList: some View {
        List {
            ForEach(store.favoritedAccounts) {
                FavoriteRow(account: $0)
            }
            .onDelete{ indexes in
                withAnimation {
                    store.deleteFavorite(at: indexes)
                }
            }
        }
    }
    
    var backButton: some View {
        Button(action: {
            dismiss()
        }, label: {
            Symbol("arrow.left", color: .black)
        })
    }
    
    var editButton: some View {
        !store.favoritedAccounts.isEmpty
        ? AnyView(EditButton())
        : AnyView(EmptyView())
    }
    
    private func dismiss() {
        presentationMode.wrappedValue.dismiss()
    }
    
}


#Preview {
    FavoriteView()
}
