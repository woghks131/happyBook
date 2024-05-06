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
    
    private var emptyFavoriteList: some View {
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
    
    private var favoriteList: some View {
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
    
    private var backButton: some View {
        Button(action: {
            dismiss()
        }, label: {
            Symbol("arrow.left", color: .black)
        })
    }
    
    private var editButton: some View {
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
