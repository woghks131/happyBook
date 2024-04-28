//
//  DividerView.swift
//  HappyBook
//
//  Created by 박재환 on 4/27/24.
//

import SwiftUI

struct DividerView: View {
    
    let opacity: Double
    let maxHeight: CGFloat
    
    init(
        opacity: Double = 0.3,
        maxHeight: CGFloat = 1
    ) {
        self.opacity = opacity
        self.maxHeight = maxHeight
    }
    
    var body: some View {
        Color.primary
          .opacity(opacity)
          .frame(maxWidth: .infinity, maxHeight: maxHeight)
    }
}
