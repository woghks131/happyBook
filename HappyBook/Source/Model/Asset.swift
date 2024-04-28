//
//  Asset.swift
//  HappyBook
//
//  Created by 박재환 on 4/25/24.
//

import Foundation

//자산 데이타
struct Asset: Codable, Hashable, Identifiable {
    var id: UUID = UUID()
    let name: String        //자산이름 (oo은행, oo카드 등등)
}

var Assets: Set<Asset> {
    get {
        guard let data = UserDefaults.standard.data(forKey: "Assets") else {
            return []
        }
        do {
            return try JSONDecoder().decode(Set<Asset>.self, from: data)
        } catch {
            print("Error decoding assets: \(error)")
            return []
        }
    }
    set {
        do {
            let data = try JSONEncoder().encode(newValue)
            UserDefaults.standard.set(data, forKey: "Assets")
        } catch {
            print("Error encoding assets: \(error)")
        }
    }
}

