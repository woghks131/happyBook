//
//  MainTabView.swift
//  HappyBook
//
//  Created by 박재환 on 4/20/24.
//

import SwiftUI

struct MainTabView: View {
    
    private enum Tabs {
        case account, statistics, asset, more
    }
    
    @EnvironmentObject private var store: Store
    
    @State private var selectedTab: Tabs = .account
    
    
    var body: some View {
        TabView(selection: $selectedTab) {
            Group {
                account
                statistics
                asset
                more
            }
            .accentColor(.primary)
        }
        .accentColor(.peach)
        .edgesIgnoringSafeArea(.top)
    }
}

private extension MainTabView {
    
    //가계부
    var account: some View {
        AccountView()
            .tag(Tabs.account)
            .tabItem(image: "book.closed", text: "가계부")
    }
    
    //통계
    var statistics: some View {
        StatisticsView()
            .tag(Tabs.statistics)
            .tabItem(image: "chart.bar.xaxis", text: "통계")
    }
    
    //자산
    var asset: some View {
        AssetView()
            .tag(Tabs.asset)
            .tabItem(image: "wonsign", text: "자산")
    }
    
    //더보기
    var more: some View {
        MoreView()
            .tag(Tabs.more)
            .tabItem(image: "ellipsis", text: "더보기")
    }
}

fileprivate extension View {
    func tabItem(image: String, text: String) -> some View {
        self.tabItem {
            Symbol(image, scale: .large)
                .font(Font.system(size: 17, weight: .light))
            Text(text)
        }
    }
}


#Preview {
    MainTabView()
        .environmentObject(Store())
}
