//
//  ViewController.swift
//  AppleLoginTest
//
//  Created by 김태훈 on 2021/02/01.
//

import UIKit
import AuthenticationServices

class ViewController: UIViewController {

    @IBOutlet weak var loginStackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setupProviderLoginView()
    }

    func setupProviderLoginView() {
        let authorizationBtn = ASAuthorizationAppleIDButton(authorizationButtonType: .signIn, authorizationButtonStyle: .black)
        authorizationBtn.addTarget(self, action: #selector(handleAuthorizationAppleIDBtnPressed), for: .touchUpInside)
        loginStackView.addArrangedSubview(authorizationBtn)
    }
    
    /// 인증을 처리할 메서드
    @objc
    func handleAuthorizationAppleIDBtnPressed() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
}

extension ViewController: ASAuthorizationControllerDelegate {
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
        
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            
            let userIdentifier = appleIDCredential.user
            let fullName = appleIDCredential.fullName
            let email = appleIDCredential.email
            
            print("UserID: \(userIdentifier)")
            print("FullName: \(fullName)")
            print("Email: \(email)")
            
        case let passwordCredential as ASPasswordCredential:
            
            let username = passwordCredential.user
            let password = passwordCredential.password
            
        default:
            break
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // 에러 처리
    }
}

extension ViewController: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}
