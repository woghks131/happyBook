//
//  MemoView.swift
//  HappyBook
//
//  Created by 박재환 on 5/4/24.
//

import SwiftUI

struct MemoView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var store: Store
    
    var body: some View {
        ZStack {
            if store.memoList.isEmpty {
                emptyMemoList
            } else {
                memoList
            }
        }
    }
}

private extension MemoView {
    private var emptyMemoList: some View {
        VStack(spacing: 25) {
          Image("box")
            .renderingMode(.template)
            .foregroundColor(Color.gray.opacity(0.4))
          
          Text("등록된 메모가 없습니다")
            .font(.headline).fontWeight(.medium)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.background)
    }
    
    private var memoList: some View {
        Form {
            ForEach(store.memoList) {
                MemoRow(account: $0)
            }
            .onDelete{ indexes in
                withAnimation {
                    store.deleteMemo(at: indexes)
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
        !store.memoList.isEmpty
        ? AnyView(EditButton())
        : AnyView(EmptyView())
    }
    
    private func dismiss() {
        presentationMode.wrappedValue.dismiss()
    }
}

#Preview {
    MemoView()
}
