//
//  KakaoSignInButton.swift
//  HappyBook
//
//  Created by 박재환 on 4/20/24.
//

import SwiftUI
import KakaoSDKCommon
import KakaoSDKAuth
import KakaoSDKUser

struct KakaoSignInButton: View {
    var body: some View {
        Button {
            //카카오톡 실행 가능 여부
            if (UserApi.isKakaoTalkLoginAvailable()) {
                UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in
                    if let error = error {
                        print(error)
                    }
//                    if let oauthToken = oauthToken {
//                        print("회원가입 API CALL")
//                    }
                }
            } else {
                UserApi.shared.loginWithKakaoAccount {(oauthToken, error) in
                    if let error = error {
                        print(error)
                    }
//                    if let oauthToken = oauthToken {
//                        print("kakao success !")
//                    }
                }
            }
        } label: {
            Image("kakaoLoginButton")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: UIScreen.main.bounds.width * 0.8)
        }
    }
}

#Preview {
    KakaoSignInButton()
}
