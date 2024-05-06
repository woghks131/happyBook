//
//  HappyBookApp.swift
//  HappyBook
//
//  Created by 박재환 on 4/20/24.
//

import SwiftUI
import KakaoSDKCommon
import KakaoSDKAuth
import KakaoSDKUser

@main
struct HappyBookApp: App {
    
    init() {
        configureAppearance()
    }
    
    var body: some Scene {
        WindowGroup {
            if (AuthApi.hasToken()) {
                AccountView()
                    .environmentObject(Store())
            } else {
                LoginView()
                    .onOpenURL { url in
                        if (AuthApi.isKakaoTalkLoginUrl(url)) {
                            _ = AuthController.handleOpenUrl(url: url)
                        }
                    }
            }
            
        }
    }
    
    private func configureAppearance() {
        //Kakao SDK 초기화
        KakaoSDK.initSDK(appKey: "f5c557c3d0ca0adae67596aa78d23197")
        
        UITableView.appearance().backgroundColor = .clear
        UISegmentedControl.appearance().selectedSegmentTintColor = .peach
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
    }
}
