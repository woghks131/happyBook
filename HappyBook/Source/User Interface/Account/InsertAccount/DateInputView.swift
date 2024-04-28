//
//  DateInputView.swift
//  HappyBook
//
//  Created by 박재환 on 4/26/24.
//

import SwiftUI

struct DateInputView: View {
    @Binding var date: Date
    
    var body: some View {
        HStack {
            Text("날짜")
                .font(.system(size: 15))
                .foregroundStyle(.gray)
            DatePicker(selection: $date, in: ...Date(), displayedComponents: .date
            ) {}.padding()
                .environment(\.locale, Locale(identifier: "ko_KR"))
                .labelsHidden()
            DatePicker(selection: $date, in: ...Date(), displayedComponents: .hourAndMinute
            ) {}
                .environment(\.locale, Locale(identifier: "ko_KR"))
                .padding()
                
        }
        .padding([.top, .bottom], 1)
        .padding([.leading, .trailing])
    }
}

#Preview {
    DateInputView(date: .constant(.now))
}
