//
//  ViewController.swift
//  KakaoLoginTest
//
//  Created by 김태훈 on 2021/02/03.
//

import UIKit
import KakaoSDKAuth

class ViewController: UIViewController {

    @IBOutlet weak var kakaoLoginButton: UIButton!
    
    @IBAction func kakaoLoginBtnTapped(_ sender: UIButton) {
        // 카카오톡 설치 여부 확인
        if AuthApi.isKakaoTalkLoginAvailable() {
            // 카카오톡으로 로그인
            AuthApi.shared.loginWithKakaoTalk { (oauthToken, error) in
                if let error = error {
                    print("Login Error: \(error)")
                } else {
                    print("loginWithKakao Succeded")
                    
                    _ = oauthToken
                    let accessToken = oauthToken?.accessToken
                    print("KaKaoAccessToken: \(accessToken ?? "none")")
                }
            }
        } else {
            AuthApi.shared.loginWithKakaoAccount { (oauthToken, error) in
                if let error = error {
                    print(error)
                } else {
                    print("loginWithKakao Succeded")
                    
                    _ = oauthToken
                    let accessToken = oauthToken?.accessToken
                    print("KaKaoAccessToken: \(accessToken ?? "none")")
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    
}

