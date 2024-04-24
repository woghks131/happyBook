//
//  AccountRow.swift
//  HappyBook
//
//  Created by 박재환 on 4/21/24.
//

import SwiftUI

struct AccountRow: View {
    var body: some View {
        VStack {
            headView
            darkerDivider
            memoView
            darkerDivider
            accountView
        }
        .padding(.bottom, 15)
    }
}

private extension AccountRow {
    
    var headView: some View {
        HStack {
            Text("21")
                .font(.headline).fontWeight(.bold)
            Text("일요일")
                .font(.subheadline)
                .frame(width: 50, height: 20)
                .foregroundStyle(.white)
                .background(.peach)
                .clipShape(RoundedRectangle(cornerRadius: 6))
            Text("2024.04")
                .font(.system(size: 12))
                .foregroundStyle(.gray)
                .padding(.top,3)
            Spacer()
            Text("70,000")
                .font(.headline)
                .foregroundStyle(.blue)
            Spacer()
            Text("413,000")
                .font(.headline)
                .foregroundStyle(.red)
        }
        .padding(5)
        
    }
    
    var memoView: some View {
        HStack {
            Symbol("list.clipboard", scale: .small, color: .peach)
            Text("제목이 있으면 제목 보여주고 제목이 없으면 내용을 보여주는 공간")
                .font(.system(size: 10))
                .lineLimit(1)
            Spacer()
        }
        .padding(.leading, 10)
        .padding(.trailing, 10)
    }
    
    var accountView: some View {
        
        VStack {
            HStack {
                Symbol("medal", scale: .small, color: .black)
                Text("상여")
                    .font(.system(size: 13))
                    .foregroundStyle(.gray)
                    .padding(.trailing, 20)
                
                VStack {
                    Text("삼성카드")
                        .font(.system(size: 13))
                        .foregroundStyle(.gray)
                    Text("오후 3:20")
                        .font(.system(size: 13))
                        .foregroundStyle(.gray)
                }
                
                Spacer()
                
                Text("70,000")
                    .font(.headline)
                    .foregroundStyle(.blue)
            }
            .padding([.top, .bottom], 5)
            .padding([.leading, .trailing])
            
            
            
            HStack {
                Symbol("fork.knife", scale: .small, color: .black)
                Text("식비")
                    .font(.system(size: 13))
                    .foregroundStyle(.gray)
                    .padding(.trailing, 20)
                
                VStack {
                    Text("현금")
                        .font(.system(size: 13))
                        .foregroundStyle(.gray)
                    Text("오후 3:20")
                        .font(.system(size: 13))
                        .foregroundStyle(.gray)
                }
                
                Spacer()
                
                Text("9,000")
                    .font(.headline)
                    .foregroundStyle(.blue)
            }
            .padding([.top, .bottom], 5)
            .padding([.leading, .trailing])
        }
        
    }
    
    var darkerDivider: some View {
      Color.primary
        .opacity(0.3)
        .frame(maxWidth: .infinity, maxHeight: 1)
    }
}

#Preview {
    AccountRow()
}
