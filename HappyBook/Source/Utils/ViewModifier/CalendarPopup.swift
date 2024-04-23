//
//  Popup.swift
//  HappyBook
//
//  Created by 박재환 on 4/21/24.
//

import SwiftUI

enum PopupStyle {
    case none       // 효과 없음
    case blur       // 배경을 흐리게
    case dimmed     // 배경을 어둡게
}

struct Popup<Message: View>: ViewModifier {
    let size: CGSize?       // 팝업창의 크기
    let style: PopupStyle   // 팝업 스타일
    let message: Message    // 팝업창에 나타낼 메시지
}
