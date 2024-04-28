//
//  BundleExtension.swift
//  HappyBook
//
//  Created by 박재환 on 4/25/24.
//

import Foundation

extension Bundle {
  func decode<T: Decodable>(filename: String, as type: T.Type) -> T {
    guard let url = self.url(forResource: filename, withExtension: nil) else {
      fatalError("번들에 \(filename)이 없습니다.")
    }
    guard let data = try? Data(contentsOf: url) else {
      fatalError("\(url)로부터 데이터를 불러올 수 없습니다.")
    }
    guard let decodedData = try? JSONDecoder().decode(T.self, from: data) else {
      fatalError("데이터 복호화에 실패했습니다.")
    }
    return decodedData
  }
}
