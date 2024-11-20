//
//  AppleLoginService.swift
//  imdang
//
//  Created by daye on 11/14/24.
//
import Foundation
import AuthenticationServices
import RxSwift


class AppleLoginService: NSObject, ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    
    static let shared = AppleLoginService()
    let loginResult = PublishSubject<Result<ASAuthorizationAppleIDCredential, Error>>()
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow } ?? UIWindow()
    }
    
    func startSignInWithApple() {
        let provider = ASAuthorizationAppleIDProvider()
        let request = provider.createRequest()
        request.requestedScopes = [.fullName, .email] //이름, 메일
        
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.presentationContextProvider = self
        controller.performRequests()
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            
            let userIdentifier = appleIDCredential.user
            let fullName = appleIDCredential.fullName
            let email = appleIDCredential.email
            
            // user info
            print("사용자 ID: \(userIdentifier)\n")
            print("사용자 name: \(String(describing: fullName))\n")
            print("사용자 email: \(String(describing: email))\n")
            
            loginResult.onNext(.success(appleIDCredential))
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        let nsError = error as NSError
            if nsError.domain == ASAuthorizationError.errorDomain && nsError.code == ASAuthorizationError.canceled.rawValue {
                print("취소됨")
            } else {
                print("Apple Login Error: \(error.localizedDescription)")
                loginResult.onNext(.failure(error))
            }
        
    }
    
    
}
