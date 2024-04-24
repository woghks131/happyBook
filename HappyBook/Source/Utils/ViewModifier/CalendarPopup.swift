//
//  CalendarPopup.swift
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

fileprivate struct CalendarPopup<Message: View>: ViewModifier {
    let size: CGSize?       // 팝업창의 크기
    let style: PopupStyle   // 팝업 스타일
    let message: Message
    
    init(
        size: CGSize? = nil,
        style: PopupStyle = .none,
        message: Message
    ) {
        self.size = size
        self.style = style
        self.message = message
    }
    
    func body(content: Content) -> some View {
        content //팝업창을 띄운 뷰
            .blur(radius: style == .blur ? 2 : 0)   //blur 스타일인 경우에만 적용
            .overlay(Rectangle().fill(Color.black.opacity(style == .dimmed ? 0.4 : 0))) //dimmed 스타일인 경우에만 적용
            .overlay(calenderPopupContent)  // 달력팝업창으로 표현될 뷰
    }
    
    private var calenderPopupContent: some View {
        GeometryReader { g in
            VStack { self.message }
              .frame(width: self.size?.width ?? g.size.width * 0.9,
                     height: self.size?.height ?? g.size.height * 0.4)
              .background(Color.primary.colorInvert())
              .cornerRadius(12)
              .shadow(color: .primaryShadow, radius: 15, x: 5, y: 5)
              .overlay(self.calendarMark, alignment: .top)
              .frame(width: g.frame(in: .local).width, height: g.frame(in: .local).height)
        }
    }
    
    private var calendarMark: some View {
        Symbol("calendar.circle", color: .peach)
            .font(.system(size: 60).weight(.semibold))
            .background(Color.white.scaleEffect(0.8))   //달력 마크 배경색을 흰색으로 지정
            .offset(x: 0, y: -20)   //팝ㅇ버창 상단에 걸쳐지도록 원래 위치보다 위로 가도록 조정
    }
}

fileprivate struct PopupToggle: ViewModifier {
  @Binding var isPresented: Bool
  func body(content: Content) -> some View {
    content
      .disabled(isPresented)
      .onTapGesture { self.isPresented.toggle() }
  }
}

fileprivate struct PopupItem<Item: Identifiable>: ViewModifier {
  @Binding var item: Item?
  func body(content: Content) -> some View {
    content
      .disabled(item != nil)
      .onTapGesture { self.item = nil }
  }
}

extension View {
  func popup<Content: View>(
    isPresented: Binding<Bool>,
    size: CGSize? = nil,
    style: PopupStyle = .none,
    @ViewBuilder content: () -> Content
  ) -> some View {
    if isPresented.wrappedValue {
      let popup = CalendarPopup(size: size, style: style, message: content())
      let popupToggle = PopupToggle(isPresented: isPresented)
      let modifiedContent = self.modifier(popup).modifier(popupToggle)
      return AnyView(modifiedContent)
    } else {
      return AnyView(self)
    }
  }
  
  func popup<Content: View, Item: Identifiable>(
    item: Binding<Item?>,
    size: CGSize? = nil,
    style: PopupStyle = .none,
    @ViewBuilder content: (Item) -> Content
  ) -> some View {
    if let selectedItem = item.wrappedValue {
      let content = content(selectedItem)
      let popup = CalendarPopup(size: size, style: style, message: content)
      let popupItem = PopupItem(item: item)
      let modifiedContent = self.modifier(popup).modifier(popupItem)
      return AnyView(modifiedContent)
    } else {
      return AnyView(self)
    }
  }
  
  func popupOverContext<Item: Identifiable, Content: View>(
    item: Binding<Item?>,
    size: CGSize? = nil,
    style: PopupStyle = .none,
    ignoringEdges edges: Edge.Set = .all,
    @ViewBuilder content: (Item) -> Content
  ) -> some View  {
    let isNonNil = item.wrappedValue != nil
    return ZStack {
      self
        .blur(radius: isNonNil && style == .blur ? 2 : 0)
      
      if isNonNil {
        Color.black
          .luminanceToAlpha()
          .popup(item: item, size: size, style: style, content: content)
          .edgesIgnoringSafeArea(edges)
      }
    }
  }
}
