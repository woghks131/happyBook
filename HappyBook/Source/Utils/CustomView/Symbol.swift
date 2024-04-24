//
//  Symbol.swift
//  HappyBook
//
//  Created by 박재환 on 4/21/24.
//

import SwiftUI

struct Symbol: View {
    
    let systemName: String
    let imageScale: Image.Scale
    let color: Color?
    
    init(
        _ systemName: String,
        scale imageScale: Image.Scale = .medium,
        color: Color? = nil
    ) {
        self.systemName = systemName
        self.imageScale = imageScale
        self.color = color
    }
    
    
    var body: some View {
        Image(systemName: systemName)
            .imageScale(imageScale)
            .foregroundStyle(color ?? .white)
    }
}
