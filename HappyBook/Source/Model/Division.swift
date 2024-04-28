//
//  Division.swift
//  HappyBook
//
//  Created by 박재환 on 4/25/24.
//

import Foundation

struct Division {
    let id: UUID = UUID()
    let name: String
    let imageName: String
    
    private enum CodingKeys: CodingKey {
        case name, imageName
    }
}

extension Division: Codable {}
extension Division: Identifiable {}
extension Division: Equatable {}
